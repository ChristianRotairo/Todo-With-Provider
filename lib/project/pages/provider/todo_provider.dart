import 'package:flutter/material.dart';
import '../../network/api.dart';

class TodoProvider with ChangeNotifier {
  final TodoService _todoService = TodoService();
  List<Todo> _todos = [];
  int? _editingId;
  bool _isLoading = false; // Add this line

  List<Todo> get todos => _todos;
  int? get editingId => _editingId;
  bool get isLoading => _isLoading; // Add this line

  TodoProvider() {
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    _isLoading = true; // Set loading state
    notifyListeners();

    _todos = await _todoService.getTodos();

    _isLoading = false; // Reset loading state
    notifyListeners();
  }

  void startEditing(Todo todo) {
    _editingId = todo.id;
    notifyListeners();
  }

  void stopEditing() {
    _editingId = null;
    notifyListeners();
  }


// Add Data
  Future<void> addTodo(String todo, BuildContext context) async {
    if (todo.isNotEmpty) {
      _isLoading = true; // Set loading state
      notifyListeners();

      await _todoService.createTodo(todo, context);
      await fetchTodos();

      _isLoading = false; // Reset loading state
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todo text cannot be empty'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


// Update Data
  Future<void> updateTodo(String todo) async {
    if (todo.isNotEmpty) {
      _isLoading = true; // Set loading state
      notifyListeners();

      await _todoService.updateTodo(_editingId!, todo);
      stopEditing();
      await fetchTodos();

      _isLoading = false; // Reset loading state
      notifyListeners();
    }
  }


// Delete Data
  Future<void> deleteTodoItem(int id) async {
    _isLoading = true; // Set loading state
    notifyListeners();

    await _todoService.deleteTodo(id);
    await fetchTodos();

    _isLoading = false; // Reset loading state
    notifyListeners();
  }
}