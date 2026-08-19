import '../services/task_storage_service.dart';
import '../../features/dashboard_screen/model/task_model.dart';

abstract class ITaskRepository {
  List<Task> getAllTasks();
  Future<void> saveTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
}

class TaskRepository implements ITaskRepository {
  final TaskStorageService _storageService;

  TaskRepository({TaskStorageService? storageService})
      : _storageService = storageService ?? TaskStorageService();

  @override
  List<Task> getAllTasks() {
    return _storageService.getAllTasks();
  }

  @override
  Future<void> saveTask(Task task) async {
    await _storageService.saveTask(task);
  }

  @override
  Future<void> updateTask(Task task) async {
    await _storageService.updateTask(task);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _storageService.deleteTask(id);
  }
}
