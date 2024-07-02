import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_todo/project/features/todo/presentation/bloc/todo_state.dart';
import '../../bloc/todo_bloc.dart';
import '../../bloc/todo_event.dart';

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
    final todoBloc = context.read<TodoBloc>();

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
            onPressed: () {
              todoBloc.add(AddTodo(_controller.text));
              _controller.clear();
            },
            child: const Text('Add Todo'),
          ),
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state is TodoInitial) {
                  todoBloc.add(LoadTodos());
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TodoLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TodoLoaded) {
                  return ListView.builder(
                    itemCount: state.todos.length,
                    itemBuilder: (context, index) {
                      final todo = state.todos[index];
                      return ListTile(
                        title: Text(todo.todo ?? 'No description'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                showEditDialog(context, todoBloc, todo.id!, todo.todo ?? '');
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                todoBloc.add(DeleteTodo(todo.id!));
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is TodoError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('No todos found'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

 Future<void> showEditDialog(
    BuildContext context, TodoBloc todoBloc, int id, String initialText) async {
  String? editedTodo = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          TextEditingController editController = TextEditingController(text: initialText);

          return AlertDialog(
            title: const Text('Edit Todo'),
            content: TextField(
              controller: editController,
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, editController.text);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );

  if (editedTodo != null) {
    todoBloc.add(UpdateTodo(id, editedTodo));
  }
}}
