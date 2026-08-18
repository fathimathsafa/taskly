import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ---------------- Brand (Luxury Dark Navy & Purple Violet Glow) ----------------
  static const Color primary = Color(0xFF8B5CF6);
  static const Color primaryDark = Color(0xFF7C3AED);
  static const Color primaryLight = Color(0xFF2E1065);
  static const Color primarySoft = Color(0xFFDDD6FE);

  static const Color secondary = Color(0xFFF59E0B);

  // ---------------- Gradients ----------------
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF0B0F19)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ---------------- Shadows ----------------
  static List<BoxShadow> get primaryShadow => [
        const BoxShadow(
          color: Color(0x3D8B5CF6),
          blurRadius: 20,
          offset: Offset(0, 8),
          spreadRadius: -2,
        ),
      ];

  static List<BoxShadow> get cardShadow => [
        const BoxShadow(
          color: Color(0x50000000),
          blurRadius: 24,
          offset: Offset(0, 8),
          spreadRadius: -2,
        ),
      ];

  // ---------------- Neutrals (Dark Navy & Platinum White) ----------------
  static const Color background = Color(0xFF0B0F19);
  static const Color surface = Color(0xFF1E293B);
  static const Color surfaceSubtle = Color(0xFF334155);
  static const Color border = Color(0xFF334155);
  static const Color borderFocused = Color(0xFF8B5CF6);
  static const Color divider = Color(0xFF1E293B);

  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFF64748B);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // ---------------- Feedback ----------------
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFF43F5E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // ---------------- Task Status ----------------
  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusInProgress = Color(0xFF3B82F6);
  static const Color statusCompleted = Color(0xFF10B981);

  static const Color statusPendingBg = Color(0x26F59E0B);
  static const Color statusInProgressBg = Color(0x263B82F6);
  static const Color statusCompletedBg = Color(0x2610B981);

  // ---------------- Task Priority ----------------
  static const Color priorityLow = Color(0xFF10B981);
  static const Color priorityMedium = Color(0xFFF59E0B);
  static const Color priorityHigh = Color(0xFFF43F5E);

  static const Color priorityLowBg = Color(0x2610B981);
  static const Color priorityMediumBg = Color(0x26F59E0B);
  static const Color priorityHighBg = Color(0x26F43F5E);

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