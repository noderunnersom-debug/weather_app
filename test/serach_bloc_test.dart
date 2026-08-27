import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather/domain/entity/city_entity.dart';
import 'package:weather/domain/usecase/search_cities_usecase.dart';
import 'package:weather/feature/search_page/presentation/bloc/search_bloc.dart';

class MockSearchCitiesUsecase extends Mock implements SearchCitiesUsecase {}

void main() {
  late MockSearchCitiesUsecase searchCitiesUsecase;

  const testCity = CityEntity(
    name: 'Berlin',
    country: 'DE',
    state: '',
    lat: 52.52,
    lon: 13.405,
  );

  const staleCity = CityEntity(
    name: 'Bergen',
    country: 'NO',
    state: '',
    lat: 60.39,
    lon: 5.32,
  );

  setUp(() {
    searchCitiesUsecase = MockSearchCitiesUsecase();
  });

  group('SearchBloc — базовые сценарии', () {
    blocTest<SearchBloc, SearchState>(
      'пустой запрос после debounce эмиттит SearchInitial',
      build: () => SearchBloc(searchCitiesUsecase),
      act: (bloc) => bloc.add(SearchCitiesEvent('')),
      wait: const Duration(milliseconds: 450),
      expect: () => [isA<SearchInitial>()],
    );

    blocTest<SearchBloc, SearchState>(
      'запрос короче 2 символов игнорируется — к usecase не идём',
      build: () => SearchBloc(searchCitiesUsecase),
      act: (bloc) => bloc.add(SearchCitiesEvent('B')),
      wait: const Duration(milliseconds: 450),
      expect: () => [],
      verify: (_) => verifyNever(() => searchCitiesUsecase.execute(any())),
    );

    blocTest<SearchBloc, SearchState>(
      'успешный поиск эмиттит [Loading, Loaded]',
      setUp: () {
        when(() => searchCitiesUsecase.execute('Berlin'))
            .thenAnswer((_) async => [testCity]);
      },
      build: () => SearchBloc(searchCitiesUsecase),
      act: (bloc) => bloc.add(SearchCitiesEvent('Berlin')),
      wait: const Duration(milliseconds: 450),
      expect: () => [
        isA<SearchLoading>(),
        isA<SearchLoaded>().having((s) => s.cities, 'cities', [testCity]),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'пустой список городов эмиттит SearchError',
      setUp: () {
        when(() => searchCitiesUsecase.execute('Xyzzy'))
            .thenAnswer((_) async => []);
      },
      build: () => SearchBloc(searchCitiesUsecase),
      act: (bloc) => bloc.add(SearchCitiesEvent('Xyzzy')),
      wait: const Duration(milliseconds: 450),
      expect: () => [
        isA<SearchLoading>(),
        isA<SearchError>().having((s) => s.message, 'message', 'Город не найден'),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'ошибка usecase маппится в понятное сообщение',
      setUp: () {
        when(() => searchCitiesUsecase.execute('Berlin'))
            .thenThrow(Exception('Connection timeout'));
      },
      build: () => SearchBloc(searchCitiesUsecase),
      act: (bloc) => bloc.add(SearchCitiesEvent('Berlin')),
      wait: const Duration(milliseconds: 450),
      expect: () => [
        isA<SearchLoading>(),
        isA<SearchError>().having((s) => s.message, 'message', contains('интернет')),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'ClearSearchEvent — мгновенный SearchInitial, без debounce',
      build: () => SearchBloc(searchCitiesUsecase),
      act: (bloc) => bloc.add(ClearSearchEvent()),
      expect: () => [isA<SearchInitial>()],
    );
  });

  group('SearchBloc — debounce и switchMap', () {
    test(
      'debounce схлопывает быстрый ввод — до usecase доходит только последний запрос',
      () {
        fakeAsync((async) {
          when(() => searchCitiesUsecase.execute(any()))
              .thenAnswer((_) async => [testCity]);

          final bloc = SearchBloc(searchCitiesUsecase);

          bloc.add(SearchCitiesEvent('B'));
          async.elapse(const Duration(milliseconds: 100));
          bloc.add(SearchCitiesEvent('Be'));
          async.elapse(const Duration(milliseconds: 100));
          bloc.add(SearchCitiesEvent('Berlin'));
          async.elapse(const Duration(milliseconds: 500));

          verify(() => searchCitiesUsecase.execute('Berlin')).called(1);
          verifyNever(() => searchCitiesUsecase.execute('B'));
          verifyNever(() => searchCitiesUsecase.execute('Be'));

          bloc.close();
        });
      },
    );

    test(
      'switchMap отменяет устаревший запрос — медленный ответ не перетирает актуальный',
      () {
        fakeAsync((async) {
          final slowCompleter = Completer<List<CityEntity>>();

          when(() => searchCitiesUsecase.execute('Be'))
              .thenAnswer((_) => slowCompleter.future);
          when(() => searchCitiesUsecase.execute('Berlin'))
              .thenAnswer((_) async => [testCity]);

          final bloc = SearchBloc(searchCitiesUsecase);

          bloc.add(SearchCitiesEvent('Be'));
          async.elapse(const Duration(milliseconds: 500));

          bloc.add(SearchCitiesEvent('Berlin'));
          async.elapse(const Duration(milliseconds: 500));

          expect(bloc.state, isA<SearchLoaded>());
          expect((bloc.state as SearchLoaded).cities, [testCity]);

          slowCompleter.complete([staleCity]);
          async.flushMicrotasks();

          expect(bloc.state, isA<SearchLoaded>());
          expect((bloc.state as SearchLoaded).cities, [testCity]);

          bloc.close();
        });
      },
    );
  });
}