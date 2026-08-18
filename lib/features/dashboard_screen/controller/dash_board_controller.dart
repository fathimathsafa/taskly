import 'package:flutter/material.dart';
import '../model/task_model.dart';

class DashboardController extends ChangeNotifier {
  final List<Task> _tasks = [
    Task(
      id: 'task_1',
      title: 'accounts app - production fix',
      description: 'Fix production bug in accounts integration module.',
      status: 'completed',
      priority: 'medium',
      project: '{SW} DashX Accounts Portal',
      assignee: 'Fathima Nasrin V K',
      reviewer: 'Fathima Nasrin V K',
      dueDate: DateTime(2026, 8, 12),
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
    Task(
      id: 'task_2',
      title: 'push notification integration ios',
      description: 'Set up APNS push notification handling for iOS builds.',
      status: 'in progress',
      priority: 'medium',
      project: 'Lemon Interiors - CRM Development',
      assignee: 'Fathima Nasrin V K',
      reviewer: 'Fathima Nasrin V K',
      dueDate: DateTime(2026, 8, 17),
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Task(
      id: 'task_3',
      title: 'create mobile app for meeting room booking',
      description: 'Develop Flutter UI for room selection and calendar slot booking.',
      status: 'on hold',
      priority: 'medium',
      project: 'Meeting Room Booking Portal',
      assignee: 'Fathima Nasrin V K',
      reviewer: 'Fathima Nasrin V K',
      dueDate: DateTime(2026, 8, 20),
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Task(
      id: 'task_4',
      title: 'Design System & Typography Refresh',
      description: 'Implement modern color scheme and dark theme support.',
      status: 'completed',
      priority: 'high',
      project: 'Taskly UI Kit',
      assignee: 'Fathima Nasrin V K',
      reviewer: 'Fathima Nasrin V K',
      dueDate: DateTime(2026, 8, 10),
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
    Task(
      id: 'task_5',
      title: 'API Integration & Sync Service',
      description: 'Connect REST endpoints and setup offline task caching layer.',
      status: 'pending',
      priority: 'medium',
      project: 'Taskly Core Sync',
      assignee: 'Fathima Nasrin V K',
      reviewer: 'Fathima Nasrin V K',
      dueDate: DateTime(2026, 8, 22),
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
  ];

  String? _selectedFilter = 'all';
  String _searchQuery = '';

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

  List<Task> get recentTasks {
    return filteredTasks;
  }

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

      final matchesSearch = _searchQuery.isEmpty ||
          t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.project.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.description.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesFilter && matchesSearch;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addTask({
    required String title,
    required String description,
    required String priority,
    DateTime? dueDate,
    String? project,
    String? assignee,
    String? reviewer,
  }) {
    final newTask = Task(
      id: 'task_${DateTime.now().millisecondsSinceEpoch}',
      title: title.trim(),
      description: description.trim(),
      status: 'pending',
      priority: priority,
      dueDate: dueDate,
      createdAt: DateTime.now(),
      project: (project != null && project.isNotEmpty) ? project : '{SW} Taskly Portal',
      assignee: (assignee != null && assignee.isNotEmpty) ? assignee : 'Fathima Nasrin V K',
      reviewer: (reviewer != null && reviewer.isNotEmpty) ? reviewer : 'Fathima Nasrin V K',
    );

    _tasks.insert(0, newTask);
    notifyListeners();
  }

  void updateTaskStatus(String id, String newStatus) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(status: newStatus);
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void setFilter(String? filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void logout(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}
