import 'package:flutter/material.dart';
import '../../dashboard_screen/model/task_model.dart';
import '../../task_listing_screen/controller/task_listing_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';

class TaskDetailsController extends ChangeNotifier {
  Task? _task;

  Task? get task => _task;

  void setTask(Task t) {
    _task = t;
    notifyListeners();
  }

  // Action 1: Change Status
  void updateStatus(String newStatus, TaskListingController taskListingController) {
    if (_task == null) return;

    final updatedTask = _task!.copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
    );

    _task = updatedTask;
    notifyListeners();

    // Sync with main TaskListingController
    taskListingController.updateTaskStatus(updatedTask.id, newStatus);
  }

  // Action 2: Edit Task Details
  void updateTaskDetails({
    required String title,
    required String description,
    required String priority,
    required String assignee,
    required DateTime? dueDate,
    required TaskListingController taskListingController,
  }) {
    if (_task == null) return;

    final updatedTask = _task!.copyWith(
      title: title.trim(),
      description: description.trim(),
      priority: priority,
      assignee: assignee.trim(),
      dueDate: dueDate,
      updatedAt: DateTime.now(),
    );

    _task = updatedTask;
    notifyListeners();

    // Sync back with task list controller
    final index = taskListingController.tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      taskListingController.deleteTask(updatedTask.id);
      taskListingController.addTask(
        title: updatedTask.title,
        description: updatedTask.description,
        priority: updatedTask.priority,
        status: updatedTask.status,
        assignee: updatedTask.assignee,
        dueDate: updatedTask.dueDate,
        project: updatedTask.project,
      );
    }
  }

  // Action 3: Delete Task
  Future<void> deleteTask(
    BuildContext context,
    TaskListingController taskListingController,
  ) async {
    if (_task == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 24),
            const SizedBox(width: 10),
            Text('Delete Task', style: AppTextStyles.h3),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${_task!.title}"? This action cannot be undone.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('Cancel', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(dialogContext, true),
            icon: const Icon(Icons.delete_forever_rounded, size: 18, color: Colors.white),
            label: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      final taskId = _task!.id;
      taskListingController.deleteTask(taskId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Text('Task deleted successfully', style: AppTextStyles.subtitle.copyWith(color: Colors.white)),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

      Navigator.pop(context);
    }
  }
}
