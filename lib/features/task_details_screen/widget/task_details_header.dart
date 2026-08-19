import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';
import '../controller/task_details_controller.dart';
import '../../task_listing_screen/controller/task_listing_controller.dart';
import 'edit_task_dialog.dart';

class TaskDetailsHeader extends StatelessWidget {
  final TaskDetailsController controller;
  final TaskListingController taskListingController;

  const TaskDetailsHeader({
    super.key,
    required this.controller,
    required this.taskListingController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
            size: 24,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 14),

        // Screen Title
        Expanded(
          child: Text(
            'Task Details',
            style: AppTextStyles.h1.copyWith(
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
        ),

        // Action: Edit Task Button
        IconButton(
          tooltip: 'Edit Task',
          onPressed: () {
            if (controller.task != null) {
              EditTaskDialog.show(context, controller, taskListingController);
            }
          },
          icon: const Icon(
            Icons.edit_note_rounded,
            color: AppColors.primary,
            size: 24,
          ),
        ),

        // Action: Delete Task Button
        IconButton(
          tooltip: 'Delete Task',
          onPressed: () => controller.deleteTask(context, taskListingController),
          icon: const Icon(
            Icons.delete_outline_rounded,
            color: AppColors.error,
            size: 22,
          ),
        ),
      ],
    );
  }
}
