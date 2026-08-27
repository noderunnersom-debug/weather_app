import 'package:equatable/equatable.dart';
import 'hourly_forecast_entity.dart';
import 'daily_forecrast_entity.dart';

class WeatherEntity extends Equatable {
  final List<DailyForecastEntity> daily;
  final List<HourlyForecastEntity> hourly;
  final int currentTemp;
  final String cityName;
  final String description;

  const WeatherEntity({
    required this.daily,
    required this.hourly,
    required this.currentTemp,
    required this.cityName,
    required this.description,
  });

  @override
  List<Object?> get props => [daily, hourly, currentTemp, cityName, description];
}