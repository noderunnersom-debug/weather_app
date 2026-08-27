import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather/core/services/location_service.dart';
import 'package:weather/core/storage/selected_city_storage.dart';
import 'package:weather/domain/entity/weather_model_entity.dart';
import 'package:weather/domain/usecase/usecase.dart';
import 'package:weather/feature/home_page/presentation/bloc/home_bloc.dart';

class MockGetWeatherDataUsecase extends Mock implements GetWeatherDataUsecase {}

class MockSelectedCityStorage extends Mock implements SelectedCityStorage {}

class MockLocationService extends Mock implements LocationService {}

void main() {
  late MockGetWeatherDataUsecase getWeatherDataUsecase;
  late MockSelectedCityStorage selectedCityStorage;
  late MockLocationService locationService;

  const testWeather = WeatherEntity(
    daily: [],
    hourly: [],
    currentTemp: 20,
    cityName: 'Berlin',
    description: 'clear sky',
  );

  setUp(() {
    getWeatherDataUsecase = MockGetWeatherDataUsecase();
    selectedCityStorage = MockSelectedCityStorage();
    locationService = MockLocationService();
  });

  group('HomeBloc — HomeGetCurrentPlaceWeatherEvent', () {
    blocTest<HomeBloc, HomeState>(
      'эмиттит [Loading, Loaded] погодой по текущим координатам',
      setUp: () {
        when(() => locationService.getCurrentPosition()).thenAnswer(
          (_) async =>
              const LocationCoordinates(latitude: 52.52, longitude: 13.405),
        );
        when(
          () => getWeatherDataUsecase.getCurrentPlaceWeather(
            lat: 52.52,
            lon: 13.405,
          ),
        ).thenAnswer((_) async => testWeather);
      },
      build: () =>
          HomeBloc(getWeatherDataUsecase, selectedCityStorage, locationService),
      act: (bloc) => bloc.add(HomeGetCurrentPlaceWeatherEvent()),
      expect: () => [
        isA<HomeLoadingState>(),
        isA<HomeLoadedState>().having((s) => s.weather, 'weather', testWeather),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'эмиттит понятную ошибку, если геолокация выключена',
      setUp: () {
        when(
          () => locationService.getCurrentPosition(),
        ).thenThrow(Exception('Location services are disabled.'));
      },
      build: () =>
          HomeBloc(getWeatherDataUsecase, selectedCityStorage, locationService),
      act: (bloc) => bloc.add(HomeGetCurrentPlaceWeatherEvent()),
      expect: () => [
        isA<HomeLoadingState>(),
        isA<HomeError>().having(
          (s) => s.message,
          'message',
          contains('Геолокация выключена'),
        ),
      ],
    );
  });

  group('HomeBloc — LoadSavedCityWeatherEvent', () {
    blocTest<HomeBloc, HomeState>(
      'эмиттит [Loading, Loaded] погодой сохранённого города, если он есть',
      setUp: () {
        when(() => selectedCityStorage.getCity()).thenAnswer(
          (_) async => {'lat': 52.52, 'lon': 13.405, 'name': 'Berlin'},
        );
        when(
          () => getWeatherDataUsecase.getCurrentPlaceWeather(
            lat: 52.52,
            lon: 13.405,
            cityName: 'Berlin',
          ),
        ).thenAnswer((_) async => testWeather);
      },
      build: () =>
          HomeBloc(getWeatherDataUsecase, selectedCityStorage, locationService),
      act: (bloc) => bloc.add(LoadSavedCityWeatherEvent()),
      expect: () => [
        isA<HomeLoadingState>(),
        isA<HomeLoadedState>().having((s) => s.weather, 'weather', testWeather),
      ],
      verify: (_) {
        verify(
          () => getWeatherDataUsecase.getCurrentPlaceWeather(
            lat: 52.52,
            lon: 13.405,
            cityName: 'Berlin',
          ),
        ).called(1);
      },
    );

    blocTest<HomeBloc, HomeState>(
      'эмиттит [Loading, Error] с понятным сообщением, если usecase падает',
      setUp: () {
        when(() => selectedCityStorage.getCity()).thenAnswer(
          (_) async => {'lat': 52.52, 'lon': 13.405, 'name': 'Berlin'},
        );
        when(
          () => getWeatherDataUsecase.getCurrentPlaceWeather(
            lat: 52.52,
            lon: 13.405,
            cityName: 'Berlin',
          ),
        ).thenThrow(Exception('Connection timeout'));
      },
      build: () =>
          HomeBloc(getWeatherDataUsecase, selectedCityStorage, locationService),
      act: (bloc) => bloc.add(LoadSavedCityWeatherEvent()),
      expect: () => [
        isA<HomeLoadingState>(),
        isA<HomeError>().having(
          (s) => s.message,
          'message',
          contains('интернет'),
        ),
      ],
    );
  });
}
