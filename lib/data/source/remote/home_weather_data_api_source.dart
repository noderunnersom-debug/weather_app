import 'package:weather/data/models/geocoding_model.dart';
import 'package:weather/data/models/weather_model.dart';

abstract class HomeWeatherDataApiSource {
  Future<WeatherModel> getCurrentPlaceWeather({
    required double lat,
    required double lon,
  });
  Future<List<GeocodingModel>> searchCities(String query);
  Future<String?> reverseGeocodeCityName({required double lat, required double lon});
}