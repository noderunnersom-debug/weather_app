
part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoadingState extends HomeState {}

final class HomeLoadedState extends HomeState {
  final WeatherEntity weather;
  HomeLoadedState(this.weather);
}

final class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}