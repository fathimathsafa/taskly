import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';
import '../../dashboard_screen/model/task_model.dart';
import '../../task_listing_screen/controller/task_listing_controller.dart';
import '../controller/task_details_controller.dart';

class TaskStatusActions extends StatelessWidget {
  final Task task;
  final TaskDetailsController controller;
  final TaskListingController taskListingController;

  const TaskStatusActions({
    super.key,
    required this.task,
    required this.controller,
    required this.taskListingController,
  });

  @override
  Widget build(BuildContext context) {
    final statusOptions = [
      {'status': 'pending', 'label': 'Pending', 'icon': Icons.hourglass_empty_rounded, 'color': AppColors.warning},
      {'status': 'in progress', 'label': 'In Progress', 'icon': Icons.sync_rounded, 'color': AppColors.info},
      {'status': 'on hold', 'label': 'On Hold', 'icon': Icons.pause_circle_outline_rounded, 'color': AppColors.warning},
      {'status': 'completed', 'label': 'Completed', 'icon': Icons.check_circle_outline_rounded, 'color': AppColors.success},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Change Task Status',
          style: AppTextStyles.subtitle.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: statusOptions.map((opt) {
            final optStatus = opt['status'] as String;
            final label = opt['label'] as String;
            final icon = opt['icon'] as IconData;
            final color = opt['color'] as Color;
            final isSelected = task.status.toLowerCase() == optStatus.toLowerCase();

            return InkWell(
              onTap: () => controller.updateStatus(optStatus, taskListingController),
              borderRadius: BorderRadius.circular(14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? color.withValues(alpha: 0.2) : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? color : AppColors.border,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                  boxShadow: isSelected
                      ? [BoxShadow(color: color.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 4))]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 18,
                      color: isSelected ? color : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: AppTextStyles.subtitle.copyWith(
                        color: isSelected ? color : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
