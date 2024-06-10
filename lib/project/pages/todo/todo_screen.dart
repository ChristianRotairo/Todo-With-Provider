import 'package:flutter/material.dart';
import 'package:new_todo/project/pages/provider/todo_provider.dart';
import 'package:provider/provider.dart';

class MyHomePageContent extends StatefulWidget {
  @override
  _MyHomePageContentState createState() => _MyHomePageContentState();
}

class _MyHomePageContentState extends State<MyHomePageContent> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'New Todo',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: todoProvider.isLoading
                ? null
                : () async {
                    await todoProvider.addTodo(_controller.text, context);
                    _controller.clear();
                  },
            child: const Text('Add Todo'),
          ),
          Expanded(
            child: Consumer<TodoProvider>(
              builder: (context, todoProvider, child) {
                if (todoProvider.todos.isEmpty) {
                  return const Center(child: Text('No todos found'));
                } else {
                  return Stack(
                    children: [
                      ListView.builder(
                        itemCount: todoProvider.todos.length,
                        itemBuilder: (context, index) {
                          final todo = todoProvider.todos[index];
                          return ListTile(
                            title: Text(todo.todo ?? 'No description'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: todoProvider.isLoading
                                      ? null
                                      : () {
                                          todoProvider.startEditing(todo);
                                          showEditDialog(context, todoProvider,
                                              todo.todo ?? '');
                                        },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: todoProvider.isLoading
                                      ? null
                                      : () async {
                                          await todoProvider
                                              .deleteTodoItem(todo.id!);
                                        },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      if (todoProvider.isLoading)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

Future<void> showEditDialog(
  BuildContext context, TodoProvider todoProvider, String initialText) async {
  final TextEditingController _editController =
      TextEditingController(text: initialText);

  final editedTodo = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit Todo'),
      content: TextField(
        controller: _editController,
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, _editController.text);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );

  if (editedTodo != null) {
    await todoProvider.updateTodo(editedTodo);
    _editController.dispose(); // Dispose the controller if editedTodo is not null
  }
}

}