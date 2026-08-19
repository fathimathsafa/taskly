import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ---------------- Brand (Luxury White & Warm Gold Touch) ----------------
  static const Color primary = Color(0xFFC5A059);
  static const Color primaryDark = Color(0xFF9A7B38);
  static const Color primaryLight = Color(0xFFFAF5E8);
  static const Color primarySoft = Color(0xFF8A6D2A);

  static const Color secondary = Color(0xFFD4AF37);

  // ---------------- Gradients ----------------
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFF9A7B38)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFE5C158), Color(0xFFC5A059)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFFAF8F5)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ---------------- Shadows ----------------
  static List<BoxShadow> get primaryShadow => [
        const BoxShadow(
          color: Color(0x33C5A059),
          blurRadius: 18,
          offset: Offset(0, 6),
          spreadRadius: -1,
        ),
      ];

  static List<BoxShadow> get cardShadow => [
        const BoxShadow(
          color: Color(0x0C1E1B18),
          blurRadius: 16,
          offset: Offset(0, 4),
          spreadRadius: 0,
        ),
      ];

  // ---------------- Neutrals (Warm Ivory White & Espresso Dark Text) ----------------
  static const Color background = Color(0xFFFAF8F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSubtle = Color(0xFFF7F4EF);
  static const Color border = Color(0xFFEFEBE4);
  static const Color borderFocused = Color(0xFFC5A059);
  static const Color divider = Color(0xFFEFEBE4);

  static const Color textPrimary = Color(0xFF1A1612);
  static const Color textSecondary = Color(0xFF686158);
  static const Color textDisabled = Color(0xFFA39B90);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // ---------------- Feedback ----------------
  static const Color success = Color(0xFF059669);
  static const Color error = Color(0xFFE11D48);
  static const Color warning = Color(0xFFD97706);
  static const Color info = Color(0xFF2563EB);

  // ---------------- Task Status ----------------
  static const Color statusPending = Color(0xFFC58A00);
  static const Color statusInProgress = Color(0xFF2563EB);
  static const Color statusCompleted = Color(0xFF059669);

  static const Color statusPendingBg = Color(0xFFFFF8E7);
  static const Color statusInProgressBg = Color(0xFFEFF6FF);
  static const Color statusCompletedBg = Color(0xFFECFDF5);

  // ---------------- Task Priority ----------------
  static const Color priorityLow = Color(0xFF059669);
  static const Color priorityMedium = Color(0xFFC58A00);
  static const Color priorityHigh = Color(0xFFE11D48);

  static const Color priorityLowBg = Color(0xFFECFDF5);
  static const Color priorityMediumBg = Color(0xFFFFF8E7);
  static const Color priorityHighBg = Color(0xFFFFF1F2);

  // ---------------- Helpers ----------------
  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return statusPending;
      case 'in progress':
        return statusInProgress;
      case 'completed':
        return statusCompleted;
      default:
        return textSecondary;
    }
  }

  static Color statusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return statusPendingBg;
      case 'in progress':
        return statusInProgressBg;
      case 'completed':
        return statusCompletedBg;
      default:
        return border;
    }
  }

  static Color priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return priorityLow;
      case 'medium':
        return priorityMedium;
      case 'high':
        return priorityHigh;
      default:
        return textSecondary;
    }
  }

  static Color priorityBgColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return priorityLowBg;
      case 'medium':
        return priorityMediumBg;
      case 'high':
        return priorityHighBg;
      default:
        return border;
    }
  }
}