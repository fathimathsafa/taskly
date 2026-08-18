import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ---------------- Brand ----------------
  static const Color primary = Color(0xFF4A63E7);
  static const Color primaryDark = Color(0xFF3548C4);
  static const Color primaryLight = Color(0xFFEEF1FD);

  static const Color secondary = Color(0xFF16C79A);

  // ---------------- Neutrals ----------------
  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE4E7EC);
  static const Color divider = Color(0xFFEAECF0);

  static const Color textPrimary = Color(0xFF1D2433);
  static const Color textSecondary = Color(0xFF667085);
  static const Color textDisabled = Color(0xFFA0A6B1);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // ---------------- Feedback ----------------
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // ---------------- Task Status ----------------
  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusInProgress = Color(0xFF3B82F6);
  static const Color statusCompleted = Color(0xFF22C55E);

  static const Color statusPendingBg = Color(0xFFFEF3E2);
  static const Color statusInProgressBg = Color(0xFFEAF2FE);
  static const Color statusCompletedBg = Color(0xFFE9F9EF);

  // ---------------- Task Priority ----------------
  static const Color priorityLow = Color(0xFF22C55E);
  static const Color priorityMedium = Color(0xFFF59E0B);
  static const Color priorityHigh = Color(0xFFEF4444);

  static const Color priorityLowBg = Color(0xFFE9F9EF);
  static const Color priorityMediumBg = Color(0xFFFEF3E2);
  static const Color priorityHighBg = Color(0xFFFDECEC);

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