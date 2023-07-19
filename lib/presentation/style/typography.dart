import 'package:flutter/material.dart';
import 'package:pray_quiet/presentation/style/colors.dart';

class AppTypography {
  static m3TitlelLarge({Color? color, double? fontSize}) {
    return TextStyle(
      color: color ?? AppColors.text,
      fontSize: fontSize ?? 25,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.2,
      fontFamily: 'Nunito',
    );
  }

  static m3TitlelMedium({Color? color, double? fontSize}) {
    return TextStyle(
      color: color ?? AppColors.text,
      fontSize: fontSize ?? 20,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.1,
      fontFamily: 'Nunito',
    );
  }

  static m3BodylLarge({
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    return TextStyle(
      color: color ?? AppColors.text,
      fontSize: fontSize ?? 15,
      fontWeight: fontWeight ?? FontWeight.w500,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.1,
      fontFamily: 'Nunito',
    );
  }

  static m3BodylMedium({Color? color, double? fontSize}) {
    return TextStyle(
      color: color ?? AppColors.text,
      fontSize: fontSize ?? 13,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.1,
      fontFamily: 'Nunito',
    );
  }
}
