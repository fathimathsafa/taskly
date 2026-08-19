import '../../../core/errors/app_exception.dart';
import '../../../core/repository/task_repository.dart';
import '../../dashboard_screen/model/task_model.dart';

class TaskAddingService {
  final ITaskRepository _repository;

  TaskAddingService({ITaskRepository? repository})
      : _repository = repository ?? TaskRepository();

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Task title is required.';
    }
    if (value.trim().length < 3) {
      return 'Task title must be at least 3 characters.';
    }
    if (value.trim().length > 100) {
      return 'Task title cannot exceed 100 characters.';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Task description is required.';
    }
    if (value.trim().length < 5) {
      return 'Task description must be at least 5 characters.';
    }
    if (value.trim().length > 500) {
      return 'Task description cannot exceed 500 characters.';
    }
    return null;
  }

  String? validateDueDate(DateTime? date) {
    if (date == null) {
      return 'Please select a valid due date for the task.';
    }
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(date.year, date.month, date.day);

    if (selectedDay.isBefore(today)) {
      return 'Due date cannot be in the past.';
    }
    return null;
  }

  String? validateAssignee(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Assigned user is required.';
    }
    return null;
  }

  Future<Task> addNewTask({
    required String title,
    required String description,
    required String status,
    required String priority,
    required DateTime dueDate,
    required String assignee,
    String? project,
  }) async {
    final titleErr = validateTitle(title);
    if (titleErr != null) throw ValidationException(titleErr);

    final descErr = validateDescription(description);
    if (descErr != null) throw ValidationException(descErr);

    final dateErr = validateDueDate(dueDate);
    if (dateErr != null) throw ValidationException(dateErr);

    final assigneeErr = validateAssignee(assignee);
    if (assigneeErr != null) throw ValidationException(assigneeErr);

    final id = 'TSK-${(1000 + DateTime.now().millisecondsSinceEpoch % 9000)}';

    final newTask = Task(
      id: id,
      title: title.trim(),
      description: description.trim(),
      status: status.toLowerCase(),
      priority: priority.toLowerCase(),
      dueDate: dueDate,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      project: project?.trim().isNotEmpty == true ? project!.trim() : 'Taskly Workspace',
      assignee: assignee.trim(),
    );

    await _repository.saveTask(newTask);

    return newTask;
  }
}
