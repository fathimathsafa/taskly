import 'package:flutter_test/flutter_test.dart';
import 'package:taskly/features/task_adding_screen/service/task_adding_service.dart';

void main() {
  group('Task Validation Unit Tests', () {
    late TaskAddingService service;

    setUp(() {
      service = TaskAddingService();
    });

    test('Empty title validation returns required error', () {
      final result = service.validateTitle('');
      expect(result, equals('Task title is required.'));
    });

    test('Short title (< 3 chars) returns length error', () {
      final result = service.validateTitle('AB');
      expect(result, equals('Task title must be at least 3 characters.'));
    });

    test('Valid title returns null', () {
      final result = service.validateTitle('Design Landing Page');
      expect(result, isNull);
    });

    test('Empty description validation returns required error', () {
      final result = service.validateDescription('');
      expect(result, equals('Task description is required.'));
    });

    test('Short description (< 5 chars) returns length error', () {
      final result = service.validateDescription('Test');
      expect(result, equals('Task description must be at least 5 characters.'));
    });

    test('Valid description returns null', () {
      final result = service.validateDescription('Complete initial prototype layout for client review.');
      expect(result, isNull);
    });

    test('Null due date returns selection error', () {
      final result = service.validateDueDate(null);
      expect(result, equals('Please select a valid due date for the task.'));
    });

    test('Past due date returns past date error', () {
      final pastDate = DateTime.now().subtract(const Duration(days: 2));
      final result = service.validateDueDate(pastDate);
      expect(result, equals('Due date cannot be in the past.'));
    });

    test('Future due date returns null', () {
      final futureDate = DateTime.now().add(const Duration(days: 5));
      final result = service.validateDueDate(futureDate);
      expect(result, isNull);
    });

    test('Empty assignee returns required error', () {
      final result = service.validateAssignee('');
      expect(result, equals('Assigned user is required.'));
    });

    test('Valid assignee returns null', () {
      final result = service.validateAssignee('Admin User');
      expect(result, isNull);
    });
  });
}
