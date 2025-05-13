import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/task_model.dart';
import '../../../logic/bloc/task_bloc.dart';
import '../../../logic/bloc/task_event.dart';
import '../../../logic/bloc/task_state.dart';
import 'add_edit_task_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        centerTitle: true,
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            final tasks = state.tasks;
            if (tasks.isEmpty) {
              return const Center(child: Text('No tasks yet'));
            }
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskCard(
                  task: task,
                  index: index,
                );
              },
            );
          } else if (state is TaskError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Add some tasks'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditTaskScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final Task task;
  final int index;

  const TaskCard({super.key, required this.task, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(task.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                color: task.isCompleted ? Colors.green : Colors.grey,
              ),
              onPressed: () {
                final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
                context.read<TaskBloc>().add(UpdateTask(updatedTask, index));
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                context.read<TaskBloc>().add(DeleteTask(task.id, index));
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEditTaskScreen(task: task, index: index),
            ),
          );
        },
      ),
    );
  }
}