class Todo {
  final String? todo;
  final int? id;

  // Constructor for creating a Todo object
  Todo({
    required this.todo,
    this.id,
  });

  // Factory constructor for creating a Todo object from a JSON map
  factory Todo.fromJson(Map<String, dynamic> json) {
    try {
      return Todo(
        id: json['id'],
        todo: json['todo'],
        // Add other fields as necessary
      );
    } catch (e) {
      print('Error parsing Todo: $json');
      rethrow;
    }
  }

  // Convert a Todo object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'todo': todo,
      'id': id,
    };
  }
}
