import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/models/task_model.dart';
import 'data/repositories/task_repository.dart';
import 'logic/bloc/task_bloc.dart';
import 'logic/bloc/task_event.dart';
import 'presentation/screens/home_screen.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => TaskRepository(),
      child: BlocProvider<TaskBloc>(
        create: (context) => TaskBloc(context.read<TaskRepository>())..add(LoadTasks()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppStrings.appTitle,
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            scaffoldBackgroundColor: AppColors.background,
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}