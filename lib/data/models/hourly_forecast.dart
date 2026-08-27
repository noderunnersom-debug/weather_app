import 'package:weather/domain/entity/hourly_forecast_entity.dart';

class HourlyForecastModel {
  final DateTime time;
  final int temp;

  const HourlyForecastModel({
    required this.time,
    required this.temp,
  });

  factory HourlyForecastModel.fromJson(Map<String, dynamic> json) {
    return HourlyForecastModel(
      time: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temp: json['temp'].round(),
    );
  }

  HourlyForecastEntity toEntity() => HourlyForecastEntity(
    time: time,
    temp: temp,
  );
}