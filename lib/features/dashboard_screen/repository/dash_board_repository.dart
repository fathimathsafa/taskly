import '../../task_adding_screen/repository/task_repository.dart';
import '../model/task_model.dart';

abstract class IDashBoardRepository {
  List<Task> getDashboardTasks();
  Future<void> saveTask(Task task);
  Future<void> updateTaskStatus(String id, String status);
  Future<void> deleteTask(String id);
}

class DashBoardRepository implements IDashBoardRepository {
  final ITaskRepository _taskRepository;

  DashBoardRepository({ITaskRepository? taskRepository})
      : _taskRepository = taskRepository ?? TaskRepository();

  @override
  List<Task> getDashboardTasks() {
    return _taskRepository.getAllTasks();
  }

  @override
  Future<void> saveTask(Task task) async {
    await _taskRepository.saveTask(task);
  }

  @override
  Future<void> updateTaskStatus(String id, String status) async {
    final tasks = _taskRepository.getAllTasks();
    final index = tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final updated = tasks[index].copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
      await _taskRepository.updateTask(updated);
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    await _taskRepository.deleteTask(id);
  }
}
