import 'dart:async';
import 'package:new_todo/project/features/todo/data/models/todo_model.dart';

abstract class TodoRepository {
  Future<List<Todo>> createTodo(String todo);
  Future<List<Todo>> getTodos();
  Future<List<Todo>> updateTodo(int id, String todo);
  Future<List<Todo>> deleteTodo(int id);
}
