part of 'search_bloc.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

final class SearchLoaded extends SearchState {
  final List<CityEntity> cities;
  SearchLoaded(this.cities);
}

final class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}