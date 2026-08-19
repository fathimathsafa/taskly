import 'package:flutter/material.dart';
import '../../../../core/errors/app_exception.dart';
import '../../dashboard_screen/model/task_model.dart';
import '../../../core/repository/task_repository.dart';

enum TaskListingState { initial, loading, loaded, error }

class TaskListingController extends ChangeNotifier {
  final ITaskRepository _repository;

  List<Task> _tasks = [];
  TaskListingState _state = TaskListingState.initial;
  String _errorMessage = '';

  final Set<String> _selectedTaskIds = {};
  String _searchQuery = '';
  String _selectedStatus = 'All';
  String _selectedPriority = 'All';
  DateTime? _selectedDueDate;
  bool _simulateError = false;

  TaskListingController({ITaskRepository? repository})
      : _repository = repository ?? TaskRepository() {
    loadTasks();
  }

  // Getters
  List<Task> get tasks => List.unmodifiable(_tasks);
  TaskListingState get state => _state;
  bool get isLoading => _state == TaskListingState.loading;
  bool get hasError => _state == TaskListingState.error;
  String get errorMessage => _errorMessage;

  Set<String> get selectedTaskIds => Set.unmodifiable(_selectedTaskIds);
  bool isTaskSelected(String taskId) => _selectedTaskIds.contains(taskId);
  int get selectedCount => _selectedTaskIds.length;
  bool get hasSelection => _selectedTaskIds.isNotEmpty;

  String get searchQuery => _searchQuery;
  String get selectedStatus => _selectedStatus;
  String get selectedPriority => _selectedPriority;
  DateTime? get selectedDueDate => _selectedDueDate;
  bool get simulateError => _simulateError;

  bool get hasActiveFilter =>
      _selectedStatus != 'All' ||
      _selectedPriority != 'All' ||
      _selectedDueDate != null ||
      _searchQuery.trim().isNotEmpty;

  Future<void> loadTasks() async {
    _state = TaskListingState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      if (_simulateError) {
        throw const StorageException('Failed to load tasks. Storage system encountered an error.');
      }

      _tasks = _repository.getAllTasks();
      _state = TaskListingState.loaded;
    } catch (e) {
      _state = TaskListingState.error;
      _errorMessage = e is AppException ? e.message : 'Error loading tasks: ${e.toString()}';
    } finally {
      notifyListeners();
    }
  }

  Future<void> refreshTasks() async {
    await loadTasks();
  }

  void retry() {
    _simulateError = false;
    loadTasks();
  }

  void toggleSimulateError() {
    _simulateError = !_simulateError;
    loadTasks();
  }

  List<Task> get filteredTasks {
    return _tasks.where((task) {
      final query = _searchQuery.toLowerCase().trim();
      final matchesSearch = query.isEmpty ||
          task.title.toLowerCase().contains(query) ||
          task.description.toLowerCase().contains(query);

      bool matchesStatus = true;
      if (_selectedStatus != 'All') {
        final status = _selectedStatus.toLowerCase();
        if (status == 'pending') {
          matchesStatus = task.status.toLowerCase() == 'pending' ||
              task.status.toLowerCase() == 'not started' ||
              task.status.toLowerCase() == 'on hold';
        } else {
          matchesStatus = task.status.toLowerCase() == status;
        }
      }

      bool matchesPriority = true;
      if (_selectedPriority != 'All') {
        matchesPriority = task.priority.toLowerCase() == _selectedPriority.toLowerCase();
      }

      bool matchesDate = true;
      if (_selectedDueDate != null) {
        matchesDate = task.dueDate != null &&
            task.dueDate!.year == _selectedDueDate!.year &&
            task.dueDate!.month == _selectedDueDate!.month &&
            task.dueDate!.day == _selectedDueDate!.day;
      }

      return matchesSearch && matchesStatus && matchesPriority && matchesDate;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setStatusFilter(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  void setPriorityFilter(String priority) {
    _selectedPriority = priority;
    notifyListeners();
  }

  void setDueDateFilter(DateTime? date) {
    _selectedDueDate = date;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedStatus = 'All';
    _selectedPriority = 'All';
    _selectedDueDate = null;
    notifyListeners();
  }

  // Selection
  void toggleTaskSelection(String taskId) {
    if (_selectedTaskIds.contains(taskId)) {
      _selectedTaskIds.remove(taskId);
    } else {
      _selectedTaskIds.add(taskId);
    }
    notifyListeners();
  }

  void selectAll() {
    _selectedTaskIds.addAll(filteredTasks.map((t) => t.id));
    notifyListeners();
  }

  void clearSelection() {
    _selectedTaskIds.clear();
    notifyListeners();
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
    _selectedTaskIds.remove(id);
    notifyListeners();
    try {
      await _repository.deleteTask(id);
    } catch (_) {}
  }

  Future<void> deleteSelectedTasks() async {
    final idsToDelete = List<String>.from(_selectedTaskIds);
    _tasks.removeWhere((t) => _selectedTaskIds.contains(t.id));
    _selectedTaskIds.clear();
    notifyListeners();
    for (final id in idsToDelete) {
      try {
        await _repository.deleteTask(id);
      } catch (_) {}
    }
  }
}
