import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DesignTokens {
  static const Color gold = Color(0xFFB8860B);
  static const Color goldLight = Color(0xFFD4A843);
  static const Color goldSoft = Color(0xFFF5E6C0);
  static const Color ivory = Color(0xFFFAF6ED);
  static const Color navy = Color(0xFF0D1B2A);
  static const Color navyMid = Color(0xFF1A2E45);
  static const Color copticRed = Color(0xFF8B2020);
  static const Color sage = Color(0xFF4A7B5C);
  static const Color cream = Color(0xFFFFFDF7);

  static TextStyle heading([Color? color]) =>
      GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.w700, color: color ?? gold);

  static TextStyle ar([double size = 16, Color? color, FontWeight? weight]) => GoogleFonts.cairo(
        fontSize: size,
        color: color ?? navy,
        fontWeight: weight ?? FontWeight.w600,
      );

  static TextStyle ui([double size = 14, Color? color, FontWeight? weight]) =>
      GoogleFonts.inter(fontSize: size, color: color ?? navyMid, fontWeight: weight ?? FontWeight.w500);

  static BoxShadow shadow([double opacity = 0.12]) =>
      BoxShadow(color: Colors.black.withValues(alpha: opacity), blurRadius: 16, offset: const Offset(0, 4));
}
