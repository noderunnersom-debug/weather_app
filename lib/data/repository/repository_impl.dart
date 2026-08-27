import 'package:injectable/injectable.dart';
import 'package:weather/data/source/remote/home_weather_data_api_source.dart';
import 'package:weather/domain/entity/city_entity.dart';
import 'package:weather/domain/entity/weather_model_entity.dart';
import 'package:weather/domain/repository/repository.dart';

@LazySingleton(as: Repository)
class RepositoryImpl implements Repository {
  final HomeWeatherDataApiSource homeWeatherDataApiSource;

  RepositoryImpl(this.homeWeatherDataApiSource);

  @override
  Future<WeatherEntity> getCurrentPlaceWeather({
    required double lat,
    required double lon,
    String? knownCityName,
  }) async {
    final model = await homeWeatherDataApiSource.getCurrentPlaceWeather(
      lat: lat,
      lon: lon,
    );

    String resolvedName = knownCityName ?? '';
    if (resolvedName.isEmpty) {
      resolvedName =
          await homeWeatherDataApiSource.reverseGeocodeCityName(
            lat: lat,
            lon: lon,
          ) ??
          model.cityName;
    }

    final entity = model.toEntity();
    return WeatherEntity(
      daily: entity.daily,
      hourly: entity.hourly,
      currentTemp: entity.currentTemp,
      cityName: resolvedName,
      description: entity.description,
    );
  }

  @override
  Future<List<CityEntity>> searchCities(String query) async {
    final cities = await homeWeatherDataApiSource.searchCities(query);
    return cities
        .map(
          (model) => CityEntity(
            name: model.name,
            country: model.country,
            state: model.state,
            lat: model.lat,
            lon: model.lon,
          ),
        )
        .toList();
  }
}
