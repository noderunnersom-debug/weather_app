import 'package:flutter/material.dart';
import 'package:weather/core/theme/app_colors.dart';
import 'package:weather/domain/entity/hourly_forecast_entity.dart';

class HourlyForecastWidget extends StatelessWidget {
  final List<HourlyForecastEntity> hourly;
  const HourlyForecastWidget({super.key, required this.hourly});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                'ПОЧАСОВОЙ ПРОГНОЗ',
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: hourly.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final hour =  hourly[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.oneHourForecastWidget,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.oneHourForecastBorder,
                      ),
                    ),
                    width: 75,
                    height: double.infinity,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          hour.formattedTime
                        ),
                        Icon(
                          Icons.cloud_queue_sharp,
                          color: AppColors.textPrimary,
                        ),
                        Text(
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          '${hour.temp}°',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
