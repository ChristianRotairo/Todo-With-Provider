import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/todo_repository.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository todoRepository;

  TodoBloc(this.todoRepository) : super(TodoInitial()) {
    on<LoadTodos>((event, emit) async {
      emit(TodoLoading());
      try {
        final todos = await todoRepository.getTodos();
        emit(TodoLoaded(todos));
      } catch (e) {
        emit(TodoError(e.toString()));
      }
    });

    on<AddTodo>((event, emit) async {
      emit(TodoLoading());
      try {
        await todoRepository.createTodo(event.todo);
        final todos = await todoRepository.getTodos();
        emit(TodoLoaded(todos));
      } catch (e) {
        emit(TodoError(e.toString()));
      }
    });

    on<UpdateTodo>((event, emit) async {
      emit(TodoLoading());
      try {
        await todoRepository.updateTodo(event.id, event.updatedTodo);
        final todos = await todoRepository.getTodos();
        emit(TodoLoaded(todos));
      } catch (e) {
        emit(TodoError(e.toString()));
      }
    });

    on<DeleteTodo>((event, emit) async {
      emit(TodoLoading());
      try {
        await todoRepository.deleteTodo(event.id);
        final todos = await todoRepository.getTodos();
        emit(TodoLoaded(todos));
      } catch (e) {
        emit(TodoError(e.toString()));
      }
    });
  }
}
