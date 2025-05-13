import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:3000/tasks'; // 👈 Adjust for your network needs

  // Fetch Tasks
  Future<List<Task>> fetchTasks() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => Task.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load tasks: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to load tasks: $e');
    }
  }

  // Create Task
  Future<void> createTask(Task task) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(task.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create task: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  // Update Task
  Future<void> updateTask(Task task) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${task.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(task.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update task: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  // Delete Task
  Future<void> deleteTask(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete task: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }
}
