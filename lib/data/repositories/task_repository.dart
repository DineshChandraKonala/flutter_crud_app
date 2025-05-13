import '../models/task_model.dart';
import '../providers/api_service.dart';
import '../providers/local_db_service.dart';

class TaskRepository {
  final ApiService _apiService = ApiService();
  final LocalDbService _dbService = LocalDbService();

  Future<List<Task>> getTasks() async {
    try {
      // Attempt to fetch tasks from the API
      final remoteTasks = await _apiService.fetchTasks();
      
      // Cache the tasks in local storage for offline use
      await _dbService.saveTasks(remoteTasks);
      
      return remoteTasks;
    } catch (e) {
      // Log the error for better tracking (optional)
      print('Error fetching remote tasks: $e');
      
      // Fallback to local storage if API fails
      return await _dbService.getTasks(); 
    }
  }

  Future<void> addTask(Task task) async {
    try {
      // Add the task to the remote server
      await _apiService.createTask(task);
      
      // Cache the task in local storage
      await _dbService.insertTask(task);
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      // Update the task on the remote server
      await _apiService.updateTask(task);
      
      // Here we assume `task.id` can be used to find the task in local storage
      final tasks = await _dbService.getTasks();
      final index = tasks.indexWhere((t) => t.id == task.id);
      
      if (index != -1) {
        // Update the task locally
        await _dbService.updateTask(task, index);
      }
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      // Delete the task from the remote server
      await _apiService.deleteTask(id);
      
      // Delete the task from local storage
      final tasks = await _dbService.getTasks();
      final index = tasks.indexWhere((task) => task.id == id);
      
      if (index != -1) {
        await _dbService.deleteTask(index);
      }
    } catch (e) {
      print('Error deleting task: $e');
    }
  }
}
