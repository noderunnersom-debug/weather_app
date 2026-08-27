import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather/core/theme/app_colors.dart';

class BottomBarWidget extends StatelessWidget {
  const BottomBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloudy_snowing,color: AppColors.textAccent, size: 15,),
              Text(
                style: TextStyle(color: AppColors.textAccent, fontSize: 8, fontWeight: FontWeight.w500),
                'Погода',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
