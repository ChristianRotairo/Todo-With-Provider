import 'package:flutter/material.dart';
import 'package:new_todo/project/pages/todo/todo_screen.dart';
import 'package:provider/provider.dart';
import 'project/pages/provider/todo_provider.dart';
// Adjust this path based on your file structure

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TodoProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePageContent(),
    );
  }
}
