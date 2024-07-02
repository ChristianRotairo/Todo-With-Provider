import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'project/features/todo/data/datasources/post_todo.dart';
import 'project/features/todo/data/repositories/todo_repository.dart';
import 'project/features/todo/presentation/bloc/todo_bloc.dart';
import 'project/features/todo/presentation/pages/todo/todo_screen.dart';

void main() {
  final TodoRepository todoRepository = FetchTodoRepositoryImpl();
  runApp(MyApp(todoRepository: todoRepository));
}

class MyApp extends StatelessWidget {
  final TodoRepository todoRepository;

  MyApp({required this.todoRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoBloc>(
          create: (context) => TodoBloc(todoRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Todo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePageContent(),
      ),
    );
  }
}
