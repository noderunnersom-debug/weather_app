import 'package:weather/domain/entity/weather_model_entity.dart';
import 'package:weather/domain/entity/city_entity.dart';

abstract class Repository {
  Future<WeatherEntity> getCurrentPlaceWeather({
    required double lat,
    required double lon,
    String? knownCityName,
  });
  Future<List<CityEntity>> searchCities(String query);
}