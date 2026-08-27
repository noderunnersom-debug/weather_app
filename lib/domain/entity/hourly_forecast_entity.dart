import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class HourlyForecastEntity extends Equatable {
  final DateTime time;
  final int temp;

  const HourlyForecastEntity({
    required this.time,
    required this.temp,
  });

  String get formattedTime => DateFormat('HH:mm').format(time);

  @override
  List<Object?> get props => [time, temp];
}