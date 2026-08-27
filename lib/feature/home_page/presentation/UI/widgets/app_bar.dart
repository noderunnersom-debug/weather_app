import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:weather/core/router/router_path.dart';
import 'package:weather/core/theme/app_colors.dart';
import 'package:weather/feature/home_page/presentation/bloc/home_bloc.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoadedState) {
          final weather = state.weather;
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Text(
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  weather.cityName,
                ),
                Spacer(),
                IconButton(
                  onPressed: () async {
                    final result = await context.pushNamed(
                      RouterPath.searchPage,
                    );
                    if (!context.mounted) return;
                    if (result == true) {
                      context.read<HomeBloc>().add(LoadSavedCityWeatherEvent());
                    }
                  },
                  icon: Icon(Icons.search, color: AppColors.textPrimary),
                ),
              ],
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
