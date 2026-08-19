import 'package:flutter/material.dart';
import '../../../../core/errors/app_exception.dart';
import '../../task_adding_screen/repository/task_repository.dart';
import '../../dashboard_screen/model/task_model.dart';

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
  bool get simulateError => _simulateError;

  // Fetch / Load Tasks from TaskRepository
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

  // Pull to Refresh
  Future<void> refreshTasks() async {
    await loadTasks();
  }

  // Retry Action
  void retry() {
    _simulateError = false;
    loadTasks();
  }

  // Toggle Error State Simulation
  void toggleSimulateError() {
    _simulateError = !_simulateError;
    loadTasks();
  }

  // Filtering & Search
  List<Task> get filteredTasks {
    return _tasks.where((task) {
      final query = _searchQuery.toLowerCase().trim();
      final matchesSearch = query.isEmpty ||
          task.title.toLowerCase().contains(query) ||
          task.description.toLowerCase().contains(query) ||
          task.assignee.toLowerCase().contains(query) ||
          task.project.toLowerCase().contains(query);

      bool matchesStatus = true;
      if (_selectedStatus != 'All') {
        matchesStatus = task.status.toLowerCase() == _selectedStatus.toLowerCase();
      }

      bool matchesPriority = true;
      if (_selectedPriority != 'All') {
        matchesPriority = task.priority.toLowerCase() == _selectedPriority.toLowerCase();
      }

      return matchesSearch && matchesStatus && matchesPriority;
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

  void resetFilters() {
    _searchQuery = '';
    _selectedStatus = 'All';
    _selectedPriority = 'All';
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

  // Operations via TaskRepository
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

  Future<void> addTask({
    required String title,
    required String description,
    required String priority,
    required String status,
    required String assignee,
    required DateTime? dueDate,
    String? project,
  }) async {
    final newTask = Task(
      id: 'TSK-${(1000 + DateTime.now().millisecondsSinceEpoch % 9000)}',
      title: title.trim(),
      description: description.trim(),
      status: status,
      priority: priority,
      assignee: assignee.trim().isEmpty ? 'Admin User' : assignee.trim(),
      dueDate: dueDate,
      createdAt: DateTime.now(),
      project: project?.trim().isNotEmpty == true ? project!.trim() : 'Taskly Workspace',
    );

    _tasks.insert(0, newTask);
    notifyListeners();
    try {
      await _repository.saveTask(newTask);
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
