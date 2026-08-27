import 'package:equatable/equatable.dart';

class DailyForecastEntity extends Equatable {
  final DateTime date;
  final int maxTempDaily;
  final int minTempDaily;

  const DailyForecastEntity({
    required this.date,
    required this.maxTempDaily,
    required this.minTempDaily,
  });

  @override
  List<Object?> get props => [date, maxTempDaily, minTempDaily];
}
