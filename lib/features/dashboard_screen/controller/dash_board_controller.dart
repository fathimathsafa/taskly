import 'package:flutter/material.dart';
import '../../task_adding_screen/repository/task_repository.dart';
import '../../../../core/routes/app_routes.dart';
import '../model/task_model.dart';

class DashboardController extends ChangeNotifier {
  final ITaskRepository _repository;
  List<Task> _tasks = [];
  bool _isLoading = false;

  String? _selectedFilter = 'all';
  String _searchQuery = '';

  DashboardController({ITaskRepository? repository})
      : _repository = repository ?? TaskRepository() {
    loadTasks();
  }

  bool get isLoading => _isLoading;
  List<Task> get tasks => List.unmodifiable(_tasks);

  String? get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;

  int get totalTasks => _tasks.length;

  int get pendingTasks =>
      _tasks.where((t) => t.status.toLowerCase() == 'pending' || t.status.toLowerCase() == 'on hold').length;

  int get inProgressTasks =>
      _tasks.where((t) => t.status.toLowerCase() == 'in progress').length;

  int get completedTasks =>
      _tasks.where((t) => t.status.toLowerCase() == 'completed').length;

  List<Task> get recentTasks => filteredTasks;

  List<Task> get filteredTasks {
    return _tasks.where((t) {
      final filter = _selectedFilter?.toLowerCase() ?? 'all';
      bool matchesFilter = true;

      if (filter == 'pending' || filter == 'not started') {
        matchesFilter = t.status.toLowerCase() == 'pending' || t.status.toLowerCase() == 'not started';
      } else if (filter == 'in progress') {
        matchesFilter = t.status.toLowerCase() == 'in progress';
      } else if (filter == 'on hold') {
        matchesFilter = t.status.toLowerCase() == 'on hold';
      } else if (filter == 'completed') {
        matchesFilter = t.status.toLowerCase() == 'completed';
      }

      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          t.title.toLowerCase().contains(query) ||
          t.project.toLowerCase().contains(query) ||
          t.description.toLowerCase().contains(query) ||
          t.assignee.toLowerCase().contains(query);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  void loadTasks() {
    _isLoading = true;
    notifyListeners();
    try {
      _tasks = _repository.getAllTasks();
    } catch (_) {
      _tasks = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
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
      reviewer: (reviewer != null && reviewer.isNotEmpty) ? reviewer : 'Admin User',
    );

    _tasks.insert(0, newTask);
    notifyListeners();
    try {
      await _repository.saveTask(newTask);
    } catch (_) {}
  }

  Future<void> updateTaskStatus(String id, String newStatus) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final updatedTask = _tasks[index].copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
      );
      _tasks[index] = updatedTask;
      notifyListeners();
      try {
        await _repository.updateTask(updatedTask);
      } catch (_) {}
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
    try {
      await _repository.deleteTask(id);
    } catch (_) {}
  }

  void setFilter(String? filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void logout(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }
}
