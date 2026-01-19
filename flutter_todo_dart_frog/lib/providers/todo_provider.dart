import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_dart_frog/models/todo.dart';
import 'package:flutter_todo_dart_frog/services/api_service.dart';
import 'package:uuid/uuid.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final todoListProvider = AsyncNotifierProvider<TodoListNotifier, List<Todo>>(
  () {
    return TodoListNotifier();
  },
);

class TodoListNotifier extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    return ref.watch(apiServiceProvider).getTodos();
  }

  Future<void> addTodo(String title) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final newTodo = Todo(
        id: const Uuid().v4(),
        title: title,
        completed: false,
      );
      await ref.read(apiServiceProvider).createTodo(newTodo);
      final todos = await ref.read(apiServiceProvider).getTodos();
      return todos;
    });
  }

  Future<void> toggleTodo(Todo todo) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final updatedTodo = todo.copyWith(completed: !todo.completed);
      await ref.read(apiServiceProvider).updateTodo(updatedTodo);
      final todos = await ref.read(apiServiceProvider).getTodos();
      return todos;
    });
  }

  Future<void> deleteTodo(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(apiServiceProvider).deleteTodo(id);
      final todos = await ref.read(apiServiceProvider).getTodos();
      return todos;
    });
  }
}
