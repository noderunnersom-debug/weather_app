import 'package:shared_preferences/shared_preferences.dart';

class SelectedCityStorage {
  static const _latKey = 'selected_city_lat';
  static const _lonKey  = 'selected_city_lon';
  static const _nameKey = 'selected_city_name';

  Future<void> saveCity({
    required double lat,
    required double lon,
    required String name,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setDouble(_latKey, lat);
    await prefs.setDouble(_lonKey, lon);
    await prefs.setString(_nameKey, name);
  }

  Future<Map<String, dynamic>?> getCity() async {
    final prefs = await SharedPreferences.getInstance();

    final lat = prefs.getDouble(_latKey);
    final lon = prefs.getDouble(_lonKey);
    final name = prefs.getString(_nameKey);

    if(lat == null || lon == null || name == null) return null;
    return {
      'lat': lat,
      'lon': lon,
      'name': name,
    };
  }
}