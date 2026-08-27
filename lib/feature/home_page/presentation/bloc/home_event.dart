part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class LoadSavedCityWeatherEvent extends HomeEvent {}

class HomeGetCurrentPlaceWeatherEvent  extends HomeEvent {}
