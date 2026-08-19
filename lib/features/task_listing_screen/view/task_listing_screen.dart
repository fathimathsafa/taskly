import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';
import '../controller/task_listing_controller.dart';
import '../widget/task_card.dart';
import '../widget/task_empty_view.dart';
import '../widget/task_error_view.dart';
import '../widget/task_listing_header.dart';
import '../widget/task_loading_view.dart';

class TaskListingScreen extends StatelessWidget {
  const TaskListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskListingController>(
      builder: (context, controller, child) {
        final searchController = TextEditingController.fromValue(
          TextEditingValue(
            text: controller.searchQuery,
            selection: TextSelection.collapsed(offset: controller.searchQuery.length),
          ),
        );

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
              'Task Listing',
              style: AppTextStyles.h1.copyWith(
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            centerTitle: false,
          ),

          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.pushNamed(context, '/add-task'),
            backgroundColor: AppColors.primary,
            elevation: 8,
            icon: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
            label: const Text(
              'Add Task',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),

          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () => controller.refreshTasks(),
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TaskListingHeader(
                          controller: controller,
                          searchController: searchController,
                        ),

                        const SizedBox(height: 16),

                        _buildBodyContent(context, controller),

                        const SizedBox(height: 80), // Bottom padding for FAB space
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBodyContent(BuildContext context, TaskListingController controller) {
    if (controller.isLoading) {
      return const TaskLoadingView();
    }

    if (controller.hasError) {
      return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: TaskErrorView(
          errorMessage: controller.errorMessage,
          onRetry: () => controller.retry(),
        ),
      );
    }

    final tasks = controller.filteredTasks;

    if (tasks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: TaskEmptyView(
          title: controller.searchQuery.isNotEmpty || controller.selectedStatus != 'All' || controller.selectedPriority != 'All'
              ? 'No Matching Tasks'
              : 'No Tasks Yet',
          subtitle: controller.searchQuery.isNotEmpty || controller.selectedStatus != 'All' || controller.selectedPriority != 'All'
              ? 'No tasks match your active search filter criteria.'
              : 'Your task list is empty. Get started by tapping the Add Task button!',
          onResetFilters: controller.searchQuery.isNotEmpty || controller.selectedStatus != 'All' || controller.selectedPriority != 'All'
              ? () => controller.resetFilters()
              : null,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final isSelected = controller.isTaskSelected(task.id);

        return TaskCard(
          task: task,
          isSelected: isSelected,
          onSelectToggle: () => controller.toggleTaskSelection(task.id),
          onStatusChange: (newStatus) => controller.updateTaskStatus(task.id, newStatus),
          onDelete: () => controller.deleteTask(task.id),
        );
      },
    );
  }
}
