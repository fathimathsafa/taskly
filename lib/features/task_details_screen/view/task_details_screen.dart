import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../dashboard_screen/model/task_model.dart';
import '../../task_listing_screen/controller/task_listing_controller.dart';
import '../controller/task_details_controller.dart';
import '../widget/task_details_grid.dart';
import '../widget/task_details_header.dart';
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
    final size = MediaQuery.of(context).size;
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
          body: Stack(
            children: [
              // Ambient Glow Accent Background
              Positioned(
                top: -size.width * 0.35,
                right: -size.width * 0.25,
                child: Container(
                  width: size.width * 0.9,
                  height: size.width * 0.9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.16),
                        AppColors.primary.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),

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
                          TaskDetailsHeader(
                            controller: controller,
                            taskListingController: taskListingController,
                          ),

                          const SizedBox(height: 20),

                          TaskDetailsInfoCard(task: currentTask),

                          const SizedBox(height: 20),

                          TaskDetailsGrid(task: currentTask),

                          const SizedBox(height: 24),

                          // 4. Interactive Change Status Buttons
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
            ],
          ),
        );
      },
    );
  }
}
