import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:weather/core/services/location_service.dart';
import 'package:weather/core/utils/error_message_mapper.dart';
import 'package:weather/domain/entity/weather_model_entity.dart';
import 'package:weather/core/storage/selected_city_storage.dart';
import 'package:weather/domain/usecase/usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

@lazySingleton
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetWeatherDataUsecase getWeatherDataUsecase;
  final SelectedCityStorage selectedCityStorage;
  final LocationService locationService;

  HomeBloc(
    this.getWeatherDataUsecase,
    this.selectedCityStorage,
    this.locationService,
  ) : super(HomeInitial()) {
    on<HomeGetCurrentPlaceWeatherEvent>(_onGetCurrentPlaceWeather);
    on<LoadSavedCityWeatherEvent>(_onLoadSavedCityWeather);
  }

  Future<void> _onGetCurrentPlaceWeather(
    HomeGetCurrentPlaceWeatherEvent event,
    Emitter<HomeState> emit,
  ) async {
    await _loadCurrentLocationWeather(emit);
  }

  Future<void> _onLoadSavedCityWeather(
    LoadSavedCityWeatherEvent event,
    Emitter<HomeState> emit,
  ) async {
    final savedCity = await selectedCityStorage.getCity();
    if (savedCity == null) {
      await _loadCurrentLocationWeather(emit);
      return;
    }

    emit(HomeLoadingState());

    try {
      final weather = await getWeatherDataUsecase.getCurrentPlaceWeather(
        lat: savedCity['lat'] as double,
        lon: savedCity['lon'] as double,
        cityName: savedCity['name'] as String?,
      );
      emit(HomeLoadedState(weather));
    } catch (e) {
      emit(HomeError(friendlyErrorMessage(e.toString())));
    }
  }

  Future<void> _loadCurrentLocationWeather(Emitter<HomeState> emit) async {
    emit(HomeLoadingState());

    try {
      final coordinates = await locationService.getCurrentPosition();
      final weather = await getWeatherDataUsecase.getCurrentPlaceWeather(
        lat: coordinates.latitude,
        lon: coordinates.longitude,
      );
      emit(HomeLoadedState(weather));
    } catch (e) {
      emit(HomeError(friendlyErrorMessage(e.toString())));
    }
  }
}
