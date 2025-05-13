import 'package:equatable/equatable.dart';
import '../../data/models/task_model.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final Task task;

  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTask extends TaskEvent {
  final Task task;
  final int index;  // Add index for updating at specific position

  const UpdateTask(this.task, this.index);

  @override
  List<Object?> get props => [task, index];
}

class DeleteTask extends TaskEvent {
  final String id;  // Changed back to String to match Task model's id field
  final int index;  // Added index for list operations

  const DeleteTask(this.id, this.index);

  @override
  List<Object?> get props => [id, index];
}