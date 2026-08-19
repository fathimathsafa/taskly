import '../../../../core/services/task_storage_service.dart';
import '../../dashboard_screen/model/task_model.dart';

class TaskDetailsService {
  final TaskStorageService _storageService;

  TaskDetailsService({TaskStorageService? storageService})
      : _storageService = storageService ?? TaskStorageService();

  /// Updates task status directly in Hive storage
  Future<void> updateTaskStatus(String id, String status) async {
    final tasks = _storageService.getAllTasks();
    final index = tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final updatedTask = tasks[index].copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
      await _storageService.updateTask(updatedTask);
    }
  }

  /// Updates full task details directly in Hive storage
  Future<void> updateTask(Task task) async {
    await _storageService.updateTask(task);
  }

  /// Deletes task from Hive storage by ID
  Future<void> deleteTask(String id) async {
    await _storageService.deleteTask(id);
  }

  /// Fetches a fresh task instance by ID from Hive storage
  Task? getTaskById(String id) {
    try {
      final tasks = _storageService.getAllTasks();
      return tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}
