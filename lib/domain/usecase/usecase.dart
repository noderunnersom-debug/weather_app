import 'package:injectable/injectable.dart';
import 'package:weather/domain/entity/weather_model_entity.dart';
import 'package:weather/domain/repository/repository.dart';

@injectable
class GetWeatherDataUsecase {
  final Repository repo;

  GetWeatherDataUsecase(this.repo);

  Future<WeatherEntity> getCurrentPlaceWeather({
    required double lat,
    required double lon,
    String? cityName,
  }) async {
    return await repo.getCurrentPlaceWeather(
      lat: lat,
      lon: lon,
      knownCityName: cityName,
    );
  }
}
