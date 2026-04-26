import 'package:agpeya/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundIvory,
      primaryColor: AppColors.primaryGoldLight,
      cardColor: AppColors.cardLight,
      textTheme: GoogleFonts.interTextTheme(),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryGoldLight,
        secondary: AppColors.copticRed,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundNavy,
      primaryColor: AppColors.primaryGoldDark,
      cardColor: AppColors.cardDark,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryGoldDark,
        secondary: AppColors.copticRed,
      ),
    );
  }
}
