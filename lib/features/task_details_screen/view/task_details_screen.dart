import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';
import '../../dashboard_screen/model/task_model.dart';
import '../../task_listing_screen/controller/task_listing_controller.dart';
import '../controller/task_details_controller.dart';
import '../widget/task_details_grid.dart';
import '../widget/task_details_info_card.dart';
import '../widget/task_status_actions.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task? initialTask;

  const TaskDetailsScreen({
    super.key,
    this.initialTask,
  });

  @override
  Widget build(BuildContext context) {
    final taskListingController = context.watch<TaskListingController>();
    final Task? taskArg = initialTask ?? ModalRoute.of(context)?.settings.arguments as Task?;

    return Consumer<TaskDetailsController>(
      builder: (context, controller, child) {
        if (taskArg != null && (controller.task == null || controller.task!.id != taskArg.id)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.setTask(taskArg);
          });
        }

        final currentTask = controller.task ?? taskArg;

        if (currentTask == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
              ),
              title: const Text('Task Details'),
            ),
            body: Center(
              child: Text(
                'No task details available.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.textPrimary,
                size: 24,
              ),
            ),
            title: Text(
              'Task Details',
              style: AppTextStyles.h1.copyWith(
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            centerTitle: false,
          ),
          body: Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Error Notification Banner
                          if (controller.hasError) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 20),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      controller.errorMessage ?? 'An error occurred',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.error,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.error),
                                    onPressed: () => controller.clearError(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          TaskDetailsInfoCard(task: currentTask),

                          const SizedBox(height: 20),

                          TaskDetailsGrid(task: currentTask),

                          const SizedBox(height: 24),

                          // Interactive Change Status & Action Buttons
                          TaskStatusActions(
                            task: currentTask,
                            controller: controller,
                            taskListingController: taskListingController,
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Loading Overlay Indicator
              if (controller.isLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.25),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
