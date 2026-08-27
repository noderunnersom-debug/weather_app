import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:weather/core/di/si.dart';
import 'package:weather/core/router/router.dart';
import 'package:weather/core/theme/app_colors.dart';
import 'package:weather/feature/home_page/presentation/bloc/home_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  final talker = TalkerFlutter.init(settings: TalkerSettings(colors: {}));
  initializeDateFormatting('ru');
  getIt.registerSingleton<Talker>(talker);
  configureDependencies();

  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: buildListProviders(locator: getIt),
      child: MaterialApp.router(
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.primaryGradientTop,
          colorScheme: const ColorScheme.dark(
            surface: AppColors.primaryGradientTop,
          ),
        ),
        title: 'MyApp',
        routerConfig: RouterInit.router,
      ),
    );
  }
}

List<BlocProvider> buildListProviders({required GetIt locator}) =>
    <BlocProvider>[
      BlocProvider<HomeBloc>(create: (context) => locator<HomeBloc>()),
    ];
