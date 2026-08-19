import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/features/dashboard_screen/model/task_model.dart';
import 'package:taskly/core/repository/task_repository.dart';
import 'package:taskly/features/task_listing_screen/controller/task_listing_controller.dart';

class MockTaskRepository implements ITaskRepository {
  final List<Task> _tasks;

  MockTaskRepository(this._tasks);

  @override
  List<Task> getAllTasks() => List.unmodifiable(_tasks);

  @override
  Future<void> saveTask(Task task) async {
    _tasks.add(task);
  }

  @override
  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) _tasks[index] = task;
  }

  @override
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
  }
}

void main() {
  group('Search and Filter Logic Unit Tests', () {
    late List<Task> sampleTasks;
    late MockTaskRepository mockRepo;
    late TaskListingController controller;

    setUp(() {
      sampleTasks = [
        Task(
          id: 'TSK-1',
          title: 'Fix Authentication Bug',
          description: 'Resolve token refresh issue on login.',
          status: 'pending',
          priority: 'high',
          dueDate: DateTime(2026, 8, 25),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          project: 'Taskly Workspace',
          assignee: 'Alice',
        ),
        Task(
          id: 'TSK-2',
          title: 'Design Dashboard UI',
          description: 'Create responsive dark mode layout.',
          status: 'in progress',
          priority: 'medium',
          dueDate: DateTime(2026, 8, 28),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          project: 'Taskly Workspace',
          assignee: 'Bob',
        ),
        Task(
          id: 'TSK-3',
          title: 'Setup Database Migration',
          description: 'Migrate local Hive storage schema.',
          status: 'completed',
          priority: 'low',
          dueDate: DateTime(2026, 8, 30),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          project: 'Taskly Workspace',
          assignee: 'Charlie',
        ),
      ];

      mockRepo = MockTaskRepository(sampleTasks);
      controller = TaskListingController(repository: mockRepo);
    });

    test('Search matches title correctly', () {
      controller.setSearchQuery('Authentication');
      expect(controller.filteredTasks.length, equals(1));
      expect(controller.filteredTasks.first.id, equals('TSK-1'));
    });

    test('Search matches description correctly', () {
      controller.setSearchQuery('responsive dark mode');
      expect(controller.filteredTasks.length, equals(1));
      expect(controller.filteredTasks.first.id, equals('TSK-2'));
    });

    test('Status filter filters pending tasks correctly', () {
      controller.setStatusFilter('Pending');
      expect(controller.filteredTasks.length, equals(1));
      expect(controller.filteredTasks.first.status, equals('pending'));
    });

    test('Status filter filters completed tasks correctly', () {
      controller.setStatusFilter('Completed');
      expect(controller.filteredTasks.length, equals(1));
      expect(controller.filteredTasks.first.status, equals('completed'));
    });

    test('Priority filter filters high priority tasks correctly', () {
      controller.setPriorityFilter('High');
      expect(controller.filteredTasks.length, equals(1));
      expect(controller.filteredTasks.first.priority, equals('high'));
    });

    test('Due date filter filters tasks by matching date', () {
      controller.setDueDateFilter(DateTime(2026, 8, 28));
      expect(controller.filteredTasks.length, equals(1));
      expect(controller.filteredTasks.first.id, equals('TSK-2'));
    });

    test('Search and Status filter work together concurrently', () {
      controller.setSearchQuery('Fix');
      controller.setStatusFilter('Pending');
      expect(controller.filteredTasks.length, equals(1));

      controller.setStatusFilter('Completed');
      expect(controller.filteredTasks, isEmpty);
    });

    test('Reset filters clears all search query and filter states', () {
      controller.setSearchQuery('Fix');
      controller.setStatusFilter('Pending');
      controller.setPriorityFilter('High');
      controller.setDueDateFilter(DateTime(2026, 8, 25));

      expect(controller.hasActiveFilter, isTrue);

      controller.resetFilters();

      expect(controller.searchQuery, isEmpty);
      expect(controller.selectedStatus, equals('All'));
      expect(controller.selectedPriority, equals('All'));
      expect(controller.selectedDueDate, isNull);
      expect(controller.hasActiveFilter, isFalse);
      expect(controller.filteredTasks.length, equals(3));
    });
  });
}
