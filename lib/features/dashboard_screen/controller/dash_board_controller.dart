import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/auth_storage_service.dart';
import '../model/task_model.dart';
import '../service/dash_board_service.dart';

class DashboardController extends ChangeNotifier {
  final DashBoardService _service;

  List<Task> _allTasks = [];
  List<Task> _recentTasks = [];
  bool _isLoading = false;

  String? _selectedFilter = 'all';
  String _searchQuery = '';

  DashboardController({DashBoardService? service})
      : _service = service ?? DashBoardService() {
    loadTasks();
  }

  bool get isLoading => _isLoading;
  List<Task> get tasks => List.unmodifiable(_allTasks);

  String? get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;

  int get totalTasks => _service.calculateTotalCount(_allTasks);
  int get pendingTasks => _service.calculatePendingCount(_allTasks);
  int get inProgressTasks => _service.calculateInProgressCount(_allTasks);
  int get completedTasks => _service.calculateCompletedCount(_allTasks);

  List<Task> get recentTasks => _recentTasks;
  List<Task> get filteredTasks => _recentTasks;

  void loadTasks() {
    _isLoading = true;
    notifyListeners();
    try {
      _allTasks = _service.getAllSortedTasks();
      _recentTasks = _service.getRecentAddedTasks(
        filter: _selectedFilter,
        searchQuery: _searchQuery,
        limit: 5,
      );
    } catch (_) {
      _allTasks = [];
      _recentTasks = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _recentTasks = _service.getRecentAddedTasks(
      filter: _selectedFilter,
      searchQuery: _searchQuery,
      limit: 5,
    );
    notifyListeners();
  }

  void setFilter(String? filter) {
    _selectedFilter = filter;
    _recentTasks = _service.getRecentAddedTasks(
      filter: _selectedFilter,
      searchQuery: _searchQuery,
      limit: 5,
    );
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
    await _service.addTask(
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
      project: project,
      assignee: assignee,
      reviewer: reviewer,
    );
    loadTasks();
  }

  Future<void> updateTaskStatus(String id, String newStatus) async {
    final index = _allTasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      await _service.updateTaskStatus(id, newStatus);
      loadTasks();
    }
  }

  Future<void> deleteTask(String id) async {
    await _service.deleteTask(id);
    loadTasks();
  }

  Future<void> logout(BuildContext context) async {
    await AuthStorageService.clearSession();
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
    }
  }
}
