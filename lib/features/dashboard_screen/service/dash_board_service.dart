import '../model/task_model.dart';
import '../repository/dash_board_repository.dart';

class DashBoardService {
  final IDashBoardRepository _repository;

  DashBoardService({IDashBoardRepository? repository})
      : _repository = repository ?? DashBoardRepository();

  List<Task> getAllSortedTasks() {
    final tasks = _repository.getDashboardTasks();
    tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return tasks;
  }

  List<Task> getRecentAddedTasks({
    String? filter = 'all',
    String searchQuery = '',
    int limit = 5,
  }) {
    final sortedTasks = getAllSortedTasks();

    final filtered = sortedTasks.where((task) {
      final selectedFilter = filter?.toLowerCase() ?? 'all';
      bool matchesFilter = true;

      if (selectedFilter == 'pending' || selectedFilter == 'not started') {
        matchesFilter = task.status.toLowerCase() == 'pending' || task.status.toLowerCase() == 'on hold';
      } else if (selectedFilter == 'in progress') {
        matchesFilter = task.status.toLowerCase() == 'in progress';
      } else if (selectedFilter == 'on hold') {
        matchesFilter = task.status.toLowerCase() == 'on hold';
      } else if (selectedFilter == 'completed') {
        matchesFilter = task.status.toLowerCase() == 'completed';
      }

      final query = searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          task.title.toLowerCase().contains(query) ||
          task.description.toLowerCase().contains(query);

      return matchesFilter && matchesSearch;
    }).toList();

    return filtered.take(limit).toList();
  }

  int calculateTotalCount(List<Task> tasks) => tasks.length;

  int calculatePendingCount(List<Task> tasks) {
    return tasks.where((t) {
      final status = t.status.toLowerCase();
      return status == 'pending' || status == 'on hold' || status == 'not started';
    }).length;
  }

  int calculateInProgressCount(List<Task> tasks) {
    return tasks.where((t) => t.status.toLowerCase() == 'in progress').length;
  }

  int calculateCompletedCount(List<Task> tasks) {
    return tasks.where((t) => t.status.toLowerCase() == 'completed').length;
  }

  Future<void> addTask({
    required String title,
    required String description,
    required String priority,
    DateTime? dueDate,
    String? project,
    String? assignee,
    String? reviewer,
  }) async {
    final newTask = Task(
      id: 'TSK-${(1000 + DateTime.now().millisecondsSinceEpoch % 9000)}',
      title: title.trim(),
      description: description.trim(),
      status: 'pending',
      priority: priority,
      dueDate: dueDate,
      createdAt: DateTime.now(),
      project: (project != null && project.isNotEmpty) ? project : 'Taskly Workspace',
      assignee: (assignee != null && assignee.isNotEmpty) ? assignee : 'Admin User',
      reviewer: (reviewer != null && reviewer.isNotEmpty) ? reviewer : '',
    );
    await _repository.saveTask(newTask);
  }

  Future<void> updateTaskStatus(String id, String status) async {
    await _repository.updateTaskStatus(id, status);
  }

  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
  }
}
