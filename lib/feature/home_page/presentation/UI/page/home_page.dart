import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/core/widgets/gradient_background.dart';
import 'package:weather/feature/home_page/presentation/UI/widgets/app_bar.dart';
import 'package:weather/feature/home_page/presentation/UI/widgets/bottom_bar.dart';
import 'package:weather/feature/home_page/presentation/UI/widgets/forecast_for_the_week.dart';
import 'package:weather/feature/home_page/presentation/UI/widgets/hourly_forecast.dart';
import 'package:weather/feature/home_page/presentation/UI/widgets/info_about_the_city.dart';
import 'package:weather/feature/home_page/presentation/bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadSavedCityWeatherEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HomeLoadedState) {
              return Stack(
                children: [
                  FractionallySizedBox(
                    heightFactor: 0.5,
                    widthFactor: 1,
                    child: Column(
                      children: [
                        Expanded(flex: 1, child: AppBarWidget()),
                        Expanded(flex: 2, child: InfoAboutTheCity()),
                        Expanded(
                          flex: 2,
                          child: HourlyForecastWidget(
                            hourly: state.weather.hourly,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.5,
                    minChildSize: 0.5,
                    maxChildSize: 1,
                    builder: (context, scrollController) =>
                        ForecastForTheWeekWidget(
                          daily: state.weather.daily,
                          scrollController: scrollController,
                        ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: BottomBarWidget(),
                  ),
                ],
              );
            }
            if (state is HomeError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
