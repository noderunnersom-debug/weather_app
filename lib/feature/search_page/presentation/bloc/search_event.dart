part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}

class SearchCitiesEvent extends SearchEvent {
  final String query;
  SearchCitiesEvent(this.query);
}

class ClearSearchEvent extends SearchEvent {}