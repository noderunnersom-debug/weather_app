import 'package:dio/dio.dart';
import 'package:weather/core/utils/constants.dart';
import 'package:weather/data/models/geocoding_model.dart';
import 'package:weather/data/models/weather_model.dart';
import 'package:weather/data/source/remote/home_weather_data_api_source.dart';

class HomeWeatherDataImplSource implements HomeWeatherDataApiSource {
  final Dio dio;

  HomeWeatherDataImplSource(this.dio);

  @override
  Future<WeatherModel> getCurrentPlaceWeather({
    required double lat,
    required double lon,
  }) async {
    final response = await dio.get<Map<String, dynamic>>(
      'data/3.0/onecall',
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'exclude': 'minutely',
        'appid': Constants.apiKey,
        'units': 'metric',
      },
    );
    return WeatherModel.fromJson(response.data!);
  }

  @override
  Future<List<GeocodingModel>> searchCities(String query) async {
    if (query.isEmpty) return [];

    try {
      final response = await dio.get<List<dynamic>>(
        'geo/1.0/direct',
        queryParameters: <String, dynamic>{
          'q': query,
          'limit': 10,
          'appid': Constants.apiKey,
        },
      );
      if (response.data != null) {
        return (response.data as List)
            .map(
              (json) => GeocodingModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to search cities: $e');
    }
  }

  @override
  Future<String?> reverseGeocodeCityName({
    required double lat,
    required double lon,
  }) async {
    try {
      final response = await dio.get<List<dynamic>>(
        'geo/1.0/reverse',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'limit': 1,
          'appid': Constants.apiKey,
        },
      );
      final list = response.data;
      if (list == null || list.isEmpty) return null;
      return (list.first as Map<String, dynamic>)['name'] as String?;
    } catch (_) {
      return null;
    }
  }
}
