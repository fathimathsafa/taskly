import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:taskly/features/dashboard_screen/model/task_model.dart';
import 'package:taskly/core/repository/task_repository.dart';
import 'package:taskly/features/task_listing_screen/controller/task_listing_controller.dart';
import 'package:taskly/features/task_listing_screen/view/task_listing_screen.dart';

class MockTaskRepository implements ITaskRepository {
  final List<Task> _tasks = [];

  @override
  List<Task> getAllTasks() => List.unmodifiable(_tasks);

  @override
  Future<void> saveTask(Task task) async {
    _tasks.add(task);
  }

  @override
  Future<void> updateTask(Task task) async {}

  @override
  Future<void> deleteTask(String id) async {}
}

void main() {
  group('Task Listing Screen Widget Tests', () {
    Widget buildTestableWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider<TaskListingController>(
          create: (_) => TaskListingController(repository: MockTaskRepository()),
          child: const TaskListingScreen(),
        ),
      );
    }

    testWidgets('TaskListingScreen renders Search bar, Filter button, and Task Listing header', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text('Task Listing'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Filter'), findsOneWidget);
    });
  });
}
