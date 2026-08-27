import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'location_service.dart';

@LazySingleton(as: LocationService)
class GeolocatorLocationService implements LocationService {
  @override
  Future<LocationCoordinates> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    final position = await Geolocator.getCurrentPosition();
    return LocationCoordinates(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}