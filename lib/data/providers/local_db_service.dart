import 'package:hive/hive.dart';
import '../models/task_model.dart';

class LocalDbService {
  static const String boxName = 'tasks';

  // Initialize Hive and open the box
  Future<Box<Task>> _openBox() async {
    try {
      var box = await Hive.openBox<Task>(boxName);
      return box;
    } catch (e) {
      throw Exception('Failed to open box: $e');
    }
  }

  // Save tasks to Hive (Clear existing and add new tasks)
  Future<void> saveTasks(List<Task> tasks) async {
    try {
      final box = await _openBox();
      await box.clear(); // Optional: Replace old cache
      for (var task in tasks) {
        await box.add(task);
      }
    } catch (e) {
      throw Exception('Failed to save tasks: $e');
    }
  }

  // Get tasks from Hive
  Future<List<Task>> getTasks() async {
    try {
      final box = await _openBox();
      return box.values.toList();
    } catch (e) {
      throw Exception('Failed to get tasks: $e');
    }
  }

  // Insert a task into Hive
  Future<void> insertTask(Task task) async {
    try {
      final box = await _openBox();
      await box.add(task);
    } catch (e) {
      throw Exception('Failed to insert task: $e');
    }
  }

  // Update an existing task in Hive
  Future<void> updateTask(Task task, int index) async {
    try {
      final box = await _openBox();
      await box.putAt(index, task);
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  // Delete a task from Hive
  Future<void> deleteTask(int index) async {
    try {
      final box = await _openBox();
      await box.deleteAt(index);
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }
}
