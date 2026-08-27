import 'package:equatable/equatable.dart';

class CityEntity extends Equatable {
  final String name;
  final String country;
  final String state;
  final double lat;
  final double lon;

  const CityEntity({
    required this.name,
    required this.country,
    required this.state,
    required this.lat,
    required this.lon,
  });

  String get fullName =>
      state.isEmpty ? '$name, $country' : '$name, $state, $country';

  @override
  List<Object?> get props => [name, country, state, lat, lon];
}