import 'package:my_project/src/todo_model.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();
final _todos = <String, Todo>{};

/// get all todos
List<Todo> getAllTodos(String userId) =>
    _todos.values.where((todo) => todo.userId == userId).toList();

/// get a tod
Todo? getTodoById(String id) => _todos[id];

/// create
void createTodo(String title, String userId) {
  final id = _uuid.v4();
  _todos[id] = Todo(id: id, title: title, userId: userId);
}

/// update
void updateTodo(String id, String userId, {String? title, bool? isCompleted}) {
  final todo = _todos[id];
  if (todo == null) return;
  _todos[id] = Todo(
    id: id,
    title: title ?? todo.title,
    isCompleted: isCompleted ?? todo.isCompleted,
    userId: userId,
  );
}

/// delete
void deleteTodo(String id, String userId) {
  final todo = _todos[id];
  if (todo != null && todo.userId == userId) {
    _todos.remove(id);
  }
}
