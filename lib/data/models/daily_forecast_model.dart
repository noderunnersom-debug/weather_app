import 'package:weather/domain/entity/daily_forecrast_entity.dart';

class DailyForecastModel {
  final DateTime date;
  final int maxTempDaily;
  final int minTempDaily;

  const DailyForecastModel({
    required this.date,
    required this.maxTempDaily,
    required this.minTempDaily,
  });

  factory DailyForecastModel.fromJson(Map<String, dynamic> json) {
    return DailyForecastModel(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      maxTempDaily: json['temp']['max'].round(),
      minTempDaily: json['temp']['min'].round(),
    );
  }

  DailyForecastEntity toEntity() => DailyForecastEntity(
    date: date,
    maxTempDaily: maxTempDaily,
    minTempDaily: minTempDaily,
  );
}