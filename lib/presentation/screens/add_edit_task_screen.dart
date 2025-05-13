import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/task_model.dart';
import '../../../logic/bloc/task_bloc.dart';
import '../../../logic/bloc/task_event.dart';
import '../../utils/validators.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;
  final int? index;

  const AddEditTaskScreen({super.key, this.task, this.index});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _isCompleted = widget.task?.isCompleted ?? false;
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final newTask = Task(
        id: widget.task?.id ?? DateTime.now().toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        isCompleted: _isCompleted,
      );

      final bloc = context.read<TaskBloc>();
      if (widget.task != null && widget.index != null) {
        bloc.add(UpdateTask(newTask, widget.index!));
      } else {
        bloc.add(AddTask(newTask));
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                title: const Text('Completed'),
                value: _isCompleted,
                onChanged: (bool? value) {
                  setState(() {
                    _isCompleted = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _saveTask,
                    child: const Text('Save'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}