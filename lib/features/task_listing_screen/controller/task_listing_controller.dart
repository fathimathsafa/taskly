import 'package:flutter/material.dart';
import '../../dashboard_screen/model/task_model.dart';

enum TaskListingState { initial, loading, loaded, error }

class TaskListingController extends ChangeNotifier {
  List<Task> _tasks = [];
  TaskListingState _state = TaskListingState.initial;
  String _errorMessage = '';
  
  final Set<String> _selectedTaskIds = {};
  String _searchQuery = '';
  String _selectedStatus = 'All';
  String _selectedPriority = 'All';
  bool _simulateError = false;

  TaskListingController() {
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

  // Initial Task Seed Data
  List<Task> _generateInitialTasks() {
    final now = DateTime.now();
    return [
      Task(
        id: 'task_101',
        title: 'Design System & Dark Theme UI Kit',
        description: 'Create responsive dark mode theme with primary violet glow accents, clean typography, and reusable glassmorphism cards.',
        status: 'in progress',
        priority: 'high',
        assignee: 'Fathima Nasrin V K',
        reviewer: 'Alex Morgan',
        dueDate: now.add(const Duration(days: 3)),
        createdAt: now.subtract(const Duration(days: 2)),
        project: 'Taskly UI Architecture',
      ),
      Task(
        id: 'task_102',
        title: 'Backend API Authentication Setup',
        description: 'Implement JWT refresh tokens, OAuth2 integration, and secure keychain token storage across mobile endpoints.',
        status: 'pending',
        priority: 'high',
        assignee: 'Mohammed Rizwan',
        reviewer: 'Fathima Nasrin V K',
        dueDate: now.add(const Duration(days: 5)),
        createdAt: now.subtract(const Duration(days: 1)),
        project: 'Taskly Core Auth Service',
      ),
      Task(
        id: 'task_103',
        title: 'Push Notification Integration (iOS & Android)',
        description: 'Configure APNS and Firebase Cloud Messaging for instant task assignment alert triggers.',
        status: 'completed',
        priority: 'medium',
        assignee: 'Fathima Nasrin V K',
        reviewer: 'Sarah Jenkins',
        dueDate: now.subtract(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(days: 6)),
        project: 'Lemon Interiors - CRM',
      ),
      Task(
        id: 'task_104',
        title: 'Meeting Room Booking Slot Engine',
        description: 'Develop interactive calendar view for room availability checks and real-time conflict prevention.',
        status: 'on hold',
        priority: 'low',
        assignee: 'David Chen',
        reviewer: 'Mohammed Rizwan',
        dueDate: now.add(const Duration(days: 10)),
        createdAt: now.subtract(const Duration(days: 3)),
        project: 'Enterprise Resource Portal',
      ),
      Task(
        id: 'task_105',
        title: 'Offline Sync & SQLite Database Caching',
        description: 'Sync background changes automatically when network connection transitions from offline back to online state.',
        status: 'pending',
        priority: 'medium',
        assignee: 'Fathima Nasrin V K',
        reviewer: 'Alex Morgan',
        dueDate: now.add(const Duration(days: 7)),
        createdAt: now.subtract(const Duration(hours: 14)),
        project: '{SW} DashX Accounts Portal',
      ),
    ];
  }

  // Fetch / Load Tasks
  Future<void> loadTasks() async {
    _state = TaskListingState.loading;
    _errorMessage = '';
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 900));

    if (_simulateError) {
      _state = TaskListingState.error;
      _errorMessage = 'Failed to load tasks. Server responded with status code 500 (Internal Server Error).';
    } else {
      if (_tasks.isEmpty) {
        _tasks = _generateInitialTasks();
      }
      _state = TaskListingState.loaded;
    }
    notifyListeners();
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

  // Toggle Error State Simulation (For testing error screen)
  void toggleSimulateError() {
    _simulateError = !_simulateError;
    loadTasks();
  }

  // Filtering & Search
  List<Task> get filteredTasks {
    return _tasks.where((task) {
      // Search match
      final query = _searchQuery.toLowerCase().trim();
      final matchesSearch = query.isEmpty ||
          task.title.toLowerCase().contains(query) ||
          task.description.toLowerCase().contains(query) ||
          task.assignee.toLowerCase().contains(query) ||
          task.project.toLowerCase().contains(query);

      // Status filter
      bool matchesStatus = true;
      if (_selectedStatus != 'All') {
        matchesStatus = task.status.toLowerCase() == _selectedStatus.toLowerCase();
      }

      // Priority filter
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

  // Operations
  void addTask({
    required String title,
    required String description,
    required String priority,
    required String status,
    required String assignee,
    required DateTime? dueDate,
    String? project,
  }) {
    final newTask = Task(
      id: 'task_${DateTime.now().millisecondsSinceEpoch}',
      title: title.trim(),
      description: description.trim(),
      status: status,
      priority: priority,
      assignee: assignee.trim().isEmpty ? 'Fathima Nasrin V K' : assignee.trim(),
      dueDate: dueDate,
      createdAt: DateTime.now(),
      project: project?.trim().isNotEmpty == true ? project!.trim() : 'General',
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
    _selectedTaskIds.remove(id);
    notifyListeners();
  }

  void deleteSelectedTasks() {
    _tasks.removeWhere((t) => _selectedTaskIds.contains(t.id));
    _selectedTaskIds.clear();
    notifyListeners();
  }
}
