import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/features/dashboard_screen/model/task_model.dart';
import 'package:taskly/core/repository/task_repository.dart';
import 'package:taskly/features/task_listing_screen/controller/task_listing_controller.dart';

class MockTaskRepository implements ITaskRepository {
  final List<Task> _tasks;

  MockTaskRepository(this._tasks);

  @override
  List<Task> getAllTasks() => List.from(_tasks);

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
  group('Status Update and Task Deletion Unit Tests', () {
    late List<Task> sampleTasks;
    late MockTaskRepository mockRepo;
    late TaskListingController controller;

    setUp(() {
      sampleTasks = [
        Task(
          id: 'TSK-101',
          title: 'Implement Hive Storage',
          description: 'Persist tasks locally in Hive database.',
          status: 'pending',
          priority: 'medium',
          dueDate: DateTime.now().add(const Duration(days: 3)),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          project: 'Taskly Workspace',
          assignee: 'Admin User',
        ),
      ];

      mockRepo = MockTaskRepository(sampleTasks);
      controller = TaskListingController(repository: mockRepo);
    });

    test('Updating task status from pending to in progress updates task status', () async {
      await controller.updateTaskStatus('TSK-101', 'in progress');
      final updatedTask = controller.tasks.firstWhere((t) => t.id == 'TSK-101');
      expect(updatedTask.status, equals('in progress'));
    });

    test('Updating task status to completed updates task status', () async {
      await controller.updateTaskStatus('TSK-101', 'completed');
      final updatedTask = controller.tasks.firstWhere((t) => t.id == 'TSK-101');
      expect(updatedTask.status, equals('completed'));
    });

    test('Deleting task removes it from task list and storage', () async {
      expect(controller.tasks.length, equals(1));
      await controller.deleteTask('TSK-101');
      expect(controller.tasks, isEmpty);
    });
  });
}
