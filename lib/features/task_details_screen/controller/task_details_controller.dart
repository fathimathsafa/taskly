import 'package:flutter/material.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';
import '../../dashboard_screen/controller/dash_board_controller.dart';
import '../../dashboard_screen/model/task_model.dart';
import '../../task_listing_screen/controller/task_listing_controller.dart';
import '../service/task_details_service.dart';

class TaskDetailsController extends ChangeNotifier {
  final TaskDetailsService _service;

  Task? _task;
  bool _isLoading = false;
  String? _errorMessage;

  TaskDetailsController({TaskDetailsService? service})
      : _service = service ?? TaskDetailsService();

  Task? get task => _task;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null && _errorMessage!.isNotEmpty;

  void setTask(Task t) {
    _task = t;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> updateStatus(
    String newStatus, {
    DashboardController? dashboardController,
    TaskListingController? taskListingController,
  }) async {
    if (_task == null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedTask = _task!.copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
      );

      await _service.updateTaskStatus(updatedTask.id, newStatus);
      _task = updatedTask;

      dashboardController?.loadTasks();
      taskListingController?.loadTasks();
    } catch (e) {
      _errorMessage = e is AppException
          ? e.message
          : 'Failed to update task status: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateTaskDetails({
    required String title,
    required String description,
    required String priority,
    required String assignee,
    required DateTime? dueDate,
    DashboardController? dashboardController,
    TaskListingController? taskListingController,
  }) async {
    if (_task == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedTask = _task!.copyWith(
        title: title.trim(),
        description: description.trim(),
        priority: priority,
        assignee: assignee.trim(),
        dueDate: dueDate,
        updatedAt: DateTime.now(),
      );

      await _service.updateTask(updatedTask);
      _task = updatedTask;

      dashboardController?.loadTasks();
      taskListingController?.loadTasks();

      return true;
    } catch (e) {
      _errorMessage = e is AppException
          ? e.message
          : 'Failed to update task details: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTask(
    BuildContext context, {
    DashboardController? dashboardController,
    TaskListingController? taskListingController,
  }) async {
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
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
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

    if (confirm != true || !context.mounted) return;

    final taskId = _task!.id;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.deleteTask(taskId);

      dashboardController?.loadTasks();
      taskListingController?.loadTasks();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  'Task deleted successfully',
                  style: AppTextStyles.subtitle.copyWith(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      _errorMessage = e is AppException
          ? e.message
          : 'Failed to delete task: ${e.toString()}';
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
