import 'package:dio/dio.dart';
import '../models/todo_model.dart';
import '../repositories/todo_repository.dart';

class FetchTodoRepositoryImpl implements TodoRepository {
  final Dio dio = Dio();
  final String apiUrl = 'http://10.0.2.2:8000/api/travelhistory'; // Updated API endpoint

  @override
 Future<List<Todo>> createTodo(String todo) async {
  try {
    final response = await dio.post(apiUrl, data: {'todo': todo});
    print('Create Todo Response: ${response.data}'); // Debug log

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data is Map<String, dynamic>) {
        // If the API returns a single new todo
        final newTodo = Todo.fromJson(response.data);
        return [newTodo]; // Return as a list for consistency
      } else if (response.data is List) {
        // If the API returns a list of all todos
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => Todo.fromJson(json)).toList();
      } else {
        throw Exception('Unexpected response format: ${response.data}');
      }
    } else {
      throw Exception('Failed to create todo: ${response.statusCode} ${response.statusMessage}');
    }
  } catch (e) {
    print('Error in createTodo: $e'); // Debug log
    throw Exception('Failed to create todo: $e');
  }
}

  @override
  Future<List<Todo>> getTodos() async {
    try {
      final response = await dio.get(apiUrl);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => Todo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get todos: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to fetch todos: $e');
    }
  }

  @override
Future<List<Todo>> updateTodo(int id, String todo) async {
  try {
    final response = await dio.put('$apiUrl/$id',
     data: {'todo': todo});
    if (response.statusCode == 200) {
      // Assuming the API returns the updated todo 
      // Fetch the full list of todos after updating
      return await getTodos();
    } else {
      throw Exception('Failed to update todo: ${response.statusCode} ${response.statusMessage}');
    }
  } catch (e) {
    throw Exception('Failed to update todo: $e');
  }
}

  @override
  Future<List<Todo>> deleteTodo(int id) async {
    try {
      final response = await dio.delete('$apiUrl/$id');
      if (response.statusCode == 200) {
       return await getTodos();
      } else {
        throw Exception('Failed to delete todo: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to delete todo: $e');
    }
  }
}
