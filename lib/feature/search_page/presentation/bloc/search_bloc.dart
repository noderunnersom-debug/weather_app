import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:weather/core/utils/error_message_mapper.dart';
import 'package:weather/domain/entity/city_entity.dart';
import 'package:weather/domain/usecase/search_cities_usecase.dart';

part 'search_event.dart';
part 'search_state.dart';

const _searchDebounceDuration = Duration(milliseconds: 400);

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchCitiesUsecase searchCitiesUsecase;

  SearchBloc(this.searchCitiesUsecase) : super(SearchInitial()) {
    on<SearchCitiesEvent>(
      _onSearchCities,
      transformer: (events, mapper) =>
          events.debounce(_searchDebounceDuration).switchMap(mapper),
    );
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onSearchCities(
    SearchCitiesEvent event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();

    if(query.isEmpty) {
      emit(SearchInitial());
      return;
    }
    if(query.length < 2){
      return;
    }

    emit(SearchLoading());

    try {
      final cities = await searchCitiesUsecase.execute(query);
      if(cities.isEmpty){
        emit(SearchError('Город не найден'));
      }else{
        emit(SearchLoaded(cities));
      }
    }catch (e){
      emit(SearchError(friendlyErrorMessage(e.toString())));
    }
  } 

  void _onClearSearch(ClearSearchEvent event, Emitter<SearchState> emit) {
    emit(SearchInitial());
  }
}