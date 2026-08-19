import '../../dashboard_screen/model/task_model.dart';
import '../../../core/repository/task_repository.dart';

class TaskListingService {
  final ITaskRepository _repository;

  TaskListingService({ITaskRepository? repository})
      : _repository = repository ?? TaskRepository();

  /// Fetches all stored tasks from repository
  List<Task> getAllTasks() {
    return _repository.getAllTasks();
  }

  /// Filters tasks by search query (title/description), status, priority, and due date
  List<Task> filterTasks({
    required List<Task> tasks,
    required String searchQuery,
    required String statusFilter,
    required String priorityFilter,
    required DateTime? dueDateFilter,
  }) {
    return tasks.where((task) {
      final query = searchQuery.toLowerCase().trim();
      final matchesSearch = query.isEmpty ||
          task.title.toLowerCase().contains(query) ||
          task.description.toLowerCase().contains(query);

      bool matchesStatus = true;
      if (statusFilter != 'All') {
        final status = statusFilter.toLowerCase();
        if (status == 'pending') {
          matchesStatus = task.status.toLowerCase() == 'pending' ||
              task.status.toLowerCase() == 'not started' ||
              task.status.toLowerCase() == 'on hold';
        } else {
          matchesStatus = task.status.toLowerCase() == status;
        }
      }

      bool matchesPriority = true;
      if (priorityFilter != 'All') {
        matchesPriority = task.priority.toLowerCase() == priorityFilter.toLowerCase();
      }

      bool matchesDate = true;
      if (dueDateFilter != null) {
        matchesDate = task.dueDate != null &&
            task.dueDate!.year == dueDateFilter.year &&
            task.dueDate!.month == dueDateFilter.month &&
            task.dueDate!.day == dueDateFilter.day;
      }

      return matchesSearch && matchesStatus && matchesPriority && matchesDate;
    }).toList();
  }

  /// Updates task status directly in storage repository
  Future<void> updateTaskStatus(Task task, String newStatus) async {
    final updated = task.copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
    );
    await _repository.updateTask(updated);
  }

  /// Deletes task directly from storage repository
  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
  }
}
