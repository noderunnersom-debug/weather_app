class LocationCoordinates {
  final double latitude;
  final double longitude;

  const LocationCoordinates({required this.latitude, required this.longitude});
}

abstract class LocationService {
  Future<LocationCoordinates> getCurrentPosition();
}