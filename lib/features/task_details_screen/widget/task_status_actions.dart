import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';
import '../../dashboard_screen/controller/dash_board_controller.dart';
import '../../dashboard_screen/model/task_model.dart';
import '../../task_listing_screen/controller/task_listing_controller.dart';
import '../controller/task_details_controller.dart';
import 'edit_task_dialog.dart';

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

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.4),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: task.status.toLowerCase(),
              dropdownColor: AppColors.surface,
              isExpanded: true,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.primary,
                size: 24,
              ),
              items: const [
                DropdownMenuItem(
                  value: 'pending',
                  child: Row(
                    children: [
                      Icon(Icons.hourglass_empty_rounded, size: 18, color: AppColors.warning),
                      SizedBox(width: 10),
                      Text('Pending'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'in progress',
                  child: Row(
                    children: [
                      Icon(Icons.sync_rounded, size: 18, color: AppColors.info),
                      SizedBox(width: 10),
                      Text('In Progress'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'on hold',
                  child: Row(
                    children: [
                      Icon(Icons.pause_circle_outline_rounded, size: 18, color: AppColors.warning),
                      SizedBox(width: 10),
                      Text('On Hold'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'completed',
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline_rounded, size: 18, color: AppColors.success),
                      SizedBox(width: 10),
                      Text('Completed'),
                    ],
                  ),
                ),
              ],
              onChanged: (val) {
                if (val != null) {
                  DashboardController? dashboardController;
                  try {
                    dashboardController = context.read<DashboardController>();
                  } catch (_) {}
                  controller.updateStatus(
                    val,
                    dashboardController: dashboardController,
                    taskListingController: taskListingController,
                  );
                }
              },
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Action Buttons Row: Edit Task & Delete Task
        Row(
          children: [
            // Edit Task Button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => EditTaskDialog.show(context, controller, taskListingController),
                icon: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 20),
                label: Text(
                  'Edit Task',
                  style: AppTextStyles.button.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                  shadowColor: AppColors.primary.withValues(alpha: 0.4),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Delete Task Button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  DashboardController? dashboardController;
                  try {
                    dashboardController = context.read<DashboardController>();
                  } catch (_) {}
                  controller.deleteTask(
                    context,
                    dashboardController: dashboardController,
                    taskListingController: taskListingController,
                  );
                },
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
                label: Text(
                  'Delete Task',
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.error, width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
