import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:taskly/features/dashboard_screen/model/task_model.dart';
import 'package:taskly/features/task_adding_screen/controller/task_adding_controller.dart';
import 'package:taskly/core/repository/task_repository.dart';
import 'package:taskly/features/task_adding_screen/view/task_adding_screen.dart';
import 'package:taskly/features/task_listing_screen/controller/task_listing_controller.dart';

class MockTaskRepository implements ITaskRepository {
  @override
  List<Task> getAllTasks() => [];

  @override
  Future<void> saveTask(Task task) async {}

  @override
  Future<void> updateTask(Task task) async {}

  @override
  Future<void> deleteTask(String id) async {}
}

void main() {
  group('Add Task Screen Widget Tests', () {
    Widget buildTestableWidget() {
      final mockRepo = MockTaskRepository();
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<TaskAddingController>(
            create: (_) => TaskAddingController(),
          ),
          ChangeNotifierProvider<TaskListingController>(
            create: (_) => TaskListingController(repository: mockRepo),
          ),
        ],
        child: const MaterialApp(
          home: TaskAddingScreen(),
        ),
      );
    }

    testWidgets('TaskAddingScreen renders form title and Save & Create Task button', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text('Create New Task'), findsOneWidget);
      expect(find.text('Save & Create Task'), findsOneWidget);
    });

    testWidgets('Validating controller with empty fields populates title and description errors', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final controller = tester.element(find.byType(TaskAddingScreen)).read<TaskAddingController>();
      final isValid = controller.validateAll();

      expect(isValid, isFalse);
      expect(controller.titleError, equals('Task title is required.'));
      expect(controller.descriptionError, equals('Task description is required.'));
    });
  });
}
