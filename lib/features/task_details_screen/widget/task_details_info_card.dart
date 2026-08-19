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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badges Row (Priority & Status)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // Priority Badge
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

              // Status Badge
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
            ],
          ),

          const SizedBox(height: 16),

          // Title
          Text(
            task.title,
            style: AppTextStyles.h1.copyWith(
              color: AppColors.textPrimary,
              fontSize: 22,
              height: 1.3,
            ),
          ),

          if (task.project.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.folder_open_rounded, size: 15, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  task.project,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primarySoft,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 18),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 14),

          // Description Section
          Text(
            'Description',
            style: AppTextStyles.subtitle.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
            ),
            child: Text(
              task.description,
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
