import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/core/theme/app_colors.dart';
import 'package:weather/feature/home_page/presentation/bloc/home_bloc.dart';

class InfoAboutTheCity extends StatelessWidget {
  const InfoAboutTheCity({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoadedState) {
          final weather = state.weather;
          final daily = weather.daily[0];
          return Padding(
            padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Text(
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 100,
                          fontWeight: FontWeight.w800,
                          height: 0.9,
                        ),
                        '${weather.currentTemp}°',
                      ),
                      Icon(
                        Icons.cloud_outlined,
                        color: AppColors.textPrimary,
                        size: 35,
                      ),
                    ],
                  ),
                ),
                Text(
                  style: TextStyle(color: AppColors.textMuted, fontSize: 20),
                  weather.description,
                ),
                Text(
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 18,
                  ),
                  'Max: ${daily.maxTempDaily}° Min: ${daily.minTempDaily}°',
                ),
              ],
            ),
          );
        }
        if (state is HomeError) {
          return Text(state.message);
        }
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryGradientTop,
                AppColors.primaryGradientBottom,
              ],
            ),
          ),
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
