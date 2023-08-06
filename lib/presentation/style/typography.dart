import 'package:flutter/material.dart';

class AppTypography {
  static m3TitlelLarge(BuildContext context, {Color? color, double? fontSize}) {
    return TextStyle(
      color: color ?? Theme.of(context).colorScheme.tertiary,
      fontSize: fontSize ?? 25,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.2,
      fontFamily: 'Nunito',
    );
  }

  static m3TitlelMedium(BuildContext context,
      {Color? color, double? fontSize}) {
    return TextStyle(
      color: color ?? Theme.of(context).colorScheme.tertiary,
      fontSize: fontSize ?? 20,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.1,
      fontFamily: 'Nunito',
    );
  }

  static m3BodylLarge(
    BuildContext context, {
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    return TextStyle(
      color: color ?? Theme.of(context).colorScheme.tertiary,
      fontSize: fontSize ?? 15,
      fontWeight: fontWeight ?? FontWeight.w500,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.1,
      fontFamily: 'Nunito',
    );
  }

  static m3BodylMedium(BuildContext context, {Color? color, double? fontSize}) {
    return TextStyle(
      color: color ?? Theme.of(context).colorScheme.tertiary,
      fontSize: fontSize ?? 13,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.1,
      fontFamily: 'Nunito',
    );
  }
}
