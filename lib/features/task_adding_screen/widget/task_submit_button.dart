import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';
import '../../task_listing_screen/controller/task_listing_controller.dart';
import '../controller/task_adding_controller.dart';

class TaskSubmitButton extends StatelessWidget {
  const TaskSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TaskAddingController>();
    final taskListingController = context.read<TaskListingController>();

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: controller.isSubmitting
            ? null
            : () => controller.submitForm(context, taskListingController),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          elevation: 6,
          shadowColor: AppColors.primary.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
        ),
        child: controller.isSubmitting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_task_rounded, color: Colors.white, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    'Save & Create Task',
                    style: AppTextStyles.button.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
