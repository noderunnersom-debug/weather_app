import 'package:flutter/material.dart';
import 'package:weather/domain/entity/city_entity.dart';
import 'package:weather/core/theme/app_colors.dart';

class CityCard extends StatelessWidget {
  final CityEntity city;
  final VoidCallback onTap;

  const CityCard({
    super.key, 
    required this.city, 
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.popularCity.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.location_city, color: AppColors.textPrimary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        city.name,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        city.fullName,
                        style: TextStyle(
                          color: AppColors.textPrimary.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textPrimary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}