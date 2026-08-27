class GeocodingModel {
  final String name;
  final String country;
  final String state;
  final double  lat;
  final double  lon;

  GeocodingModel({
    required this.name,
    required this.country,
    required this.state,
    required this.lat,
    required this.lon,
  });

  factory GeocodingModel.fromJson(Map<String, dynamic> json) {
    return GeocodingModel(
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lon: (json['lon'] as num?)?.toDouble() ?? 0.0
    );
  }
}
