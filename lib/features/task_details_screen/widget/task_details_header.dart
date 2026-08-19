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
        // Leading Back Button
        InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary,
              size: 18,
            ),
          ),
        ),
        const SizedBox(width: 14),

        // Screen Title
        Expanded(
          child: Text(
            'Task Details',
            style: AppTextStyles.h1.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 24,
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
