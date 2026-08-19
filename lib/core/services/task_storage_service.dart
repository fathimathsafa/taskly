import 'package:hive_flutter/hive_flutter.dart';
import '../../features/dashboard_screen/model/task_model.dart';
import '../errors/app_exception.dart';

class TaskStorageService {
  static const String _boxName = 'tasks_box';

  static Future<void> init() async {
    try {
      await Hive.initFlutter();
      if (!Hive.isBoxOpen(_boxName)) {
        await Hive.openBox(_boxName);
      }
    } catch (e) {
      throw StorageException('Failed to initialize local task storage: ${e.toString()}');
    }
  }

  Box get _box {
    if (!Hive.isBoxOpen(_boxName)) {
      throw const StorageException('Task storage box is not open.');
    }
    return Hive.box(_boxName);
  }

  List<Task> getAllTasks() {
    try {
      final List<Task> tasks = [];
      for (final key in _box.keys) {
        final rawMap = _box.get(key);
        if (rawMap != null && rawMap is Map) {
          tasks.add(Task.fromMap(rawMap));
        }
      }
      tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return tasks;
    } catch (e) {
      throw StorageException('Failed to fetch tasks: ${e.toString()}');
    }
  }

  Future<void> saveTask(Task task) async {
    try {
      await _box.put(task.id, task.toMap());
      await _box.flush();
    } catch (e) {
      throw StorageException('Failed to save task: ${e.toString()}');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      if (!_box.containsKey(task.id)) {
        throw NotFoundException('Task with ID ${task.id} not found.');
      }
      await _box.put(task.id, task.toMap());
      await _box.flush();
    } catch (e) {
      if (e is AppException) rethrow;
      throw StorageException('Failed to update task: ${e.toString()}');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      if (!_box.containsKey(id)) {
        throw NotFoundException('Task with ID $id not found.');
      }
      await _box.delete(id);
      await _box.flush();
    } catch (e) {
      if (e is AppException) rethrow;
      throw StorageException('Failed to delete task: ${e.toString()}');
    }
  }
}
