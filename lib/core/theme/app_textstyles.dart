import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ---------------- Headings ----------------
  static TextStyle display = GoogleFonts.urbanist(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    height: 1.2,
    letterSpacing: -0.8,
    color: AppColors.textPrimary,
  );

  static TextStyle h1 = GoogleFonts.urbanist(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static TextStyle h2 = GoogleFonts.urbanist(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
  );

  static TextStyle h3 = GoogleFonts.urbanist(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.35,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );

  // ---------------- Body ----------------
  static TextStyle bodyLarge = GoogleFonts.urbanist(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: -0.1,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.urbanist(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle bodySmall = GoogleFonts.urbanist(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  // ---------------- Labels / UI text ----------------
  static TextStyle subtitle = GoogleFonts.urbanist(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static TextStyle caption = GoogleFonts.urbanist(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: AppColors.textSecondary,
  );

  static TextStyle button = GoogleFonts.urbanist(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.1,
    color: AppColors.onPrimary,
  );

  static TextStyle badge = GoogleFonts.urbanist(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.2,
  );

  static TextStyle inputText = GoogleFonts.urbanist(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle inputHint = GoogleFonts.urbanist(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textDisabled,
  );

  static TextStyle errorText = GoogleFonts.urbanist(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.error,
  );
}
