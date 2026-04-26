import 'package:agpeya/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle heading = GoogleFonts.playfairDisplay(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle arabicBody = GoogleFonts.cairo(
    fontSize: 18,
    height: 1.8,
    color: AppColors.textPrimary,
  );

  static TextStyle coptic = const TextStyle(
    fontFamily: 'NotoSansCoptic',
    fontSize: 18,
    color: AppColors.copticRed,
  );
}
