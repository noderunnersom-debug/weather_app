import 'package:weather/data/models/daily_forecast_model.dart';
import 'package:weather/data/models/hourly_forecast.dart';
import 'package:weather/domain/entity/weather_model_entity.dart';

class WeatherModel {
  final List<DailyForecastModel> daily;
  final List<HourlyForecastModel> hourly;
  final int currentTemp;
  final String cityName;
  final String description;

  const WeatherModel({
    required this.daily,
    required this.hourly,
    required this.currentTemp,
    required this.cityName,
    required this.description,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      currentTemp: json['current']['temp'].round(),
      cityName: json['timezone'] as String,
      daily: (json['daily'] as List)
          .map((e) => DailyForecastModel.fromJson(e))
          .take(7)
          .toList(),
      hourly: (json['hourly'] as List)
          .map((e) => HourlyForecastModel.fromJson(e))
          .take(24)
          .toList(),
      description: json['current']['weather'][0]['description'],
    );
  }

  WeatherEntity toEntity() => WeatherEntity(
    daily: daily.map((e) => e.toEntity()).toList(),
    hourly: hourly.map((e) => e.toEntity()).toList(),
    currentTemp: currentTemp,
    cityName: cityName,
    description: description,
  );
}