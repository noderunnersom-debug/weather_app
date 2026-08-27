import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:weather/core/di/si.config.dart';
import 'package:weather/data/source/remote/home_weather_data_api_source.dart';
import 'package:weather/data/source/remote/home_weather_data_impl_source.dart';
import 'package:weather/core/storage/selected_city_storage.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
void configureDependencies() => $initGetIt(getIt);

@module
abstract class RegisterModule {
  Dio get dio {
    Dio dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.openweathermap.org/',
        connectTimeout: const Duration(milliseconds: 15000),
      ),
    );
    dio.interceptors.add(
      TalkerDioLogger(
        talker: getIt<Talker>(),
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          printResponseMessage: true,
          printRequestData: true,
          printResponseData: true,
          printErrorData: true,
        ),
      ),
    );
    return dio;
  }

  @lazySingleton
  HomeWeatherDataApiSource homeWeatherDataApiSource(Dio dio) =>
      HomeWeatherDataImplSource(dio);

  @lazySingleton
  SelectedCityStorage selectedCityStorage() => SelectedCityStorage();
}
