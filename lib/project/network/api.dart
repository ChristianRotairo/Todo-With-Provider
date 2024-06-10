import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// Model class representing a Todo item
class Todo {
  final String? todo; // The text of the todo, now nullable
  final int? id; // The optional ID of the todo (nullable)

  // Constructor for creating a Todo object
  Todo({
    required this.todo, // Required todo text
    this.id, // Optional todo ID
  });

  // Factory constructor for creating a Todo object from a JSON map
  factory Todo.fromJson(Map<String, dynamic> json) {
    final todo = json['todo'] as String?; // Extract the todo text from the JSON, allowing null
    final id = json['id'] as int?; // Extract the todo ID from the JSON (nullable)

    // Create and return a Todo object with the extracted data
    return Todo(
      todo: todo,
      id: id,
    );
  }

  // Method to convert a Todo object to a JSON map
  Map<String, dynamic> toJson() => {
        'todo': todo, // Include the todo text in the JSON
        if (id != null) 'id': id, // Include the todo ID in the JSON if it exists
      };
}

// Service class for handling Todo-related API requests
class TodoService {
  final Dio _dio; // Instance of the Dio HTTP client
  final String _baseURL = 'http://10.0.2.2:8000/api/travelhistory'; // Base URL for the API

  // Constructor for creating a TodoService instance
  TodoService() : _dio = Dio()..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));


// Success Handling
  Todo _handleResponse(Response response) {
    final data = response.data;
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Todo.fromJson(data);
    } else {
      throw Exception('Error: ${response.statusCode} ${response.statusMessage}');
    }
  }



// Error handling
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      String errorMessage = 'Request failed: ';
      if (error.response != null) {
        errorMessage += '${error.response?.statusCode} ${error.response?.statusMessage}: ${error.response?.data}';
      } else {
        errorMessage += 'No response received.';
      }
      return Exception(errorMessage);
    } else {
      return Exception('Unexpected error: $error');
    }
  }



// Post
  Future<Todo> createTodo(String todo, BuildContext context) async {
    try {
      final response = await _dio.post(
        _baseURL,
        data: {'todo': todo},
      );
      final newTodo = _handleResponse(response);
      // Show a success SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todo added'),
          backgroundColor: Colors.green,
        ),
      );
      return newTodo;
    } catch (e) {
      // Print the error
      print('Error: $e');
      throw _handleError(e);
    }
  }


// Get
  Future<List<Todo>> getTodos() async {
    try {
      final response = await _dio.get(_baseURL);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => Todo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get todos: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }


// Update
  Future<Todo> updateTodo(int id, String todo) async {
    try {
      final response = await _dio.put(
        '$_baseURL/$id',
        data: {'todo': todo},
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

// Delete
  Future<void> deleteTodo(int id) async {
    try {
      final response = await _dio.delete('$_baseURL/$id');
      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to delete todo: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }
}
