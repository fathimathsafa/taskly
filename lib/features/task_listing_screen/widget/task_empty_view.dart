import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';

class TaskEmptyView extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onResetFilters;
  final VoidCallback? onAddTask;

  const TaskEmptyView({
    super.key,
    this.title = 'No Tasks Found',
    this.subtitle = 'We couldn\'t find any tasks matching your criteria. Try adjusting your search query or filters.',
    this.onResetFilters,
    this.onAddTask,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.1),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: const Icon(
              Icons.task_alt_rounded,
              size: 48,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),

          Text(
            title,
            style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          Wrap(
            spacing: 12,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              if (onResetFilters != null)
                OutlinedButton.icon(
                  onPressed: onResetFilters,
                  icon: const Icon(Icons.filter_alt_off_rounded, size: 18),
                  label: const Text('Reset Filters'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              if (onAddTask != null)
                ElevatedButton.icon(
                  onPressed: onAddTask,
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: const Text('Create New Task'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    elevation: 4,
                    shadowColor: AppColors.primary.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
