import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pray_quiet/presentation/style/style.dart';

enum PrayQuietThemeType {
  light,
  dark,
  system,
}

final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: AppColors.primary,
    // background: AppColors.background,
  ),
  useMaterial3: true,
  textTheme: TextTheme(
    labelLarge: TextStyle(fontSize: 15.sp),
    bodyMedium: TextStyle(fontSize: 14.sp),
  ),
  fontFamily: 'Nunito',
);

final darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: AppColors.primary,
    // background: AppColors.backgroundDark,
  ),
  useMaterial3: true,
  textTheme: TextTheme(
    labelLarge: TextStyle(fontSize: 15.sp),
    bodyMedium: TextStyle(fontSize: 14.sp),
  ),
  fontFamily: 'Nunito',
);
