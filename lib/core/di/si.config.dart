// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../data/repository/repository_impl.dart' as _i632;
import '../../data/source/remote/home_weather_data_api_source.dart' as _i9;
import '../../domain/repository/repository.dart' as _i131;
import '../../domain/usecase/search_cities_usecase.dart' as _i604;
import '../../domain/usecase/usecase.dart' as _i1001;
import '../../feature/home_page/presentation/bloc/home_bloc.dart' as _i823;
import '../../feature/search_page/presentation/bloc/search_bloc.dart' as _i11;
import '../services/geolocator_location_service.dart' as _i501;
import '../services/location_service.dart' as _i669;
import '../storage/selected_city_storage.dart' as _i883;
import 'si.dart' as _i1033;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.factory<_i361.Dio>(() => registerModule.dio);
  gh.lazySingleton<_i883.SelectedCityStorage>(
    () => registerModule.selectedCityStorage(),
  );
  gh.lazySingleton<_i669.LocationService>(
    () => _i501.GeolocatorLocationService(),
  );
  gh.lazySingleton<_i9.HomeWeatherDataApiSource>(
    () => registerModule.homeWeatherDataApiSource(gh<_i361.Dio>()),
  );
  gh.lazySingleton<_i131.Repository>(
    () => _i632.RepositoryImpl(gh<_i9.HomeWeatherDataApiSource>()),
  );
  gh.factory<_i604.SearchCitiesUsecase>(
    () => _i604.SearchCitiesUsecase(gh<_i131.Repository>()),
  );
  gh.factory<_i1001.GetWeatherDataUsecase>(
    () => _i1001.GetWeatherDataUsecase(gh<_i131.Repository>()),
  );
  gh.factory<_i11.SearchBloc>(
    () => _i11.SearchBloc(gh<_i604.SearchCitiesUsecase>()),
  );
  gh.lazySingleton<_i823.HomeBloc>(
    () => _i823.HomeBloc(
      gh<_i1001.GetWeatherDataUsecase>(),
      gh<_i883.SelectedCityStorage>(),
      gh<_i669.LocationService>(),
    ),
  );
  return getIt;
}

class _$RegisterModule extends _i1033.RegisterModule {}
