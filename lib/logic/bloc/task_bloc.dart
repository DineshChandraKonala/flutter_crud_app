import 'package:flutter_bloc/flutter_bloc.dart';
import 'task_event.dart';
import 'task_state.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc(this.repository) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await repository.getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError('Failed to load tasks: $e'));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentTasks = (state as TaskLoaded).tasks;
      final List<Task> updatedTasks = List.from(currentTasks)..add(event.task);
      emit(TaskLoaded(updatedTasks));

      try {
        await repository.addTask(event.task);
      } catch (e) {
        emit(TaskError('Failed to add task: $e'));
      }
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentTasks = (state as TaskLoaded).tasks;
      final List<Task> updatedTasks = List.from(currentTasks);
      updatedTasks[event.index] = event.task;
      emit(TaskLoaded(updatedTasks));

      try {
        await repository.updateTask(event.task);
      } catch (e) {
        emit(TaskError('Failed to update task: $e'));
      }
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final currentTasks = (state as TaskLoaded).tasks;
      final List<Task> updatedTasks = List.from(currentTasks)..removeAt(event.index);
      emit(TaskLoaded(updatedTasks));

      try {
        await repository.deleteTask(event.index);
      } catch (e) {
        emit(TaskError('Failed to delete task: $e'));
      }
    }
  }
}