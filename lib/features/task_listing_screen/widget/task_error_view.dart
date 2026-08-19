import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';

class TaskErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const TaskErrorView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.error.withValues(alpha: 0.15),
              border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              size: 48,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Something Went Wrong',
            style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          Text(
            errorMessage.isNotEmpty
                ? errorMessage
                : 'Failed to fetch task list. Please check your connection and try again.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 20),
            label: Text(
              'Retry Loading Tasks',
              style: AppTextStyles.button.copyWith(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              elevation: 4,
              shadowColor: AppColors.error.withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
