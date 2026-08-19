import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';
import '../../dashboard_screen/model/task_model.dart';

class TaskDetailsInfoCard extends StatelessWidget {
  final Task task;

  const TaskDetailsInfoCard({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final priorityColor = AppColors.priorityColor(task.priority);
    final priorityBgColor = AppColors.priorityBgColor(task.priority);
    final statusColor = AppColors.statusColor(task.status);
    final statusBgColor = AppColors.statusBgColor(task.status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      task.status.toUpperCase(),
                      style: AppTextStyles.badge.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: priorityBgColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: priorityColor.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.flag_rounded, size: 12, color: priorityColor),
                    const SizedBox(width: 4),
                    Text(
                      '${task.priority.toUpperCase()} PRIORITY',
                      style: AppTextStyles.badge.copyWith(
                        color: priorityColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            task.title,
            style: AppTextStyles.h1.copyWith(
              color: AppColors.textPrimary,
              fontSize: 20,
              height: 1.35,
            ),
          ),

          const SizedBox(height: 16),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 12),

          Text(
            'Description',
            style: AppTextStyles.subtitle.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Text(
              task.description.isNotEmpty ? task.description : 'No description provided.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
