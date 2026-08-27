import 'package:flutter/material.dart';
import 'package:weather/core/extention/date_format.dart' show WheatherDateFormat;
import 'package:weather/core/theme/app_colors.dart';
import 'package:weather/domain/entity/daily_forecrast_entity.dart';

class ForecastForTheWeekWidget extends StatelessWidget {
  final ScrollController scrollController;
  final List<DailyForecastEntity> daily;
  const ForecastForTheWeekWidget({
    super.key,
    required this.scrollController,
    required this.daily,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.draggableScrollableSheet,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: const Text(
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                'Прогноз',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              style: TextStyle(color: AppColors.textSecondary),
              'ПРОГНОЗ НА 7 ДНЕЙ',
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: daily.length,
              itemBuilder: (context, index) {
                final day = daily[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.border, width: 1),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Text(
                            style: TextStyle(color: AppColors.textPrimary),
                            day.date.formattedDate,
                          ),
                          Icon(Icons.sunny, color: AppColors.textPrimary),
                          Spacer(),
                          Text(
                            style: TextStyle(color: AppColors.textSecondary),
                            '${day.minTempDaily}°',
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: TemperatureRangeOnScale(
                              maxTemp: day.maxTempDaily,
                              minTemp: day.minTempDaily,
                            ),
                          ),
                          Text(
                            style: TextStyle(color: AppColors.textPrimary),
                            '${day.maxTempDaily}°',
                          ),
                        ],
                      ),
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

class TemperatureRangeOnScale extends StatelessWidget {
  final int minTemp;
  final int maxTemp;
  final int scaleMin = -20;
  final int scaleMax = 40;

  const TemperatureRangeOnScale({
    super.key,
    required this.minTemp,
    required this.maxTemp,
  });

  @override
  Widget build(BuildContext context) {
    double start = (minTemp - scaleMin) / (scaleMax - scaleMin);
    double end = (maxTemp - scaleMin) / (scaleMax - scaleMin);

    start = start.clamp(0.0, 1.0);
    end = end.clamp(0.0, 1.0);

    return Container(
      width: 150,
      height: 6,
      decoration: BoxDecoration(
        color: AppColors.temperatureRangeOnScaleColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double startX = constraints.maxWidth * start;
          double widthX = constraints.maxWidth * (end - start);

          return Stack(
            children: [
              Positioned(
                left: startX,
                width: widthX,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.temperatureRangeOnScaleAccentColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
