import 'package:my_project/src/todo_model.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();
final _todos = <String, Todo>{};

/// get all todos
List<Todo> getAllTodos() => _todos.values.toList();

/// get a tod
Todo? getTodoById(String id) => _todos[id];

/// create
void createTodo(String title) {
  final id = _uuid.v4();
  _todos[id] = Todo(id: id, title: title);
}

/// update
void updateTodo(String id, {String? title, bool? isCompleted}) {
  final todo = _todos[id];
  if (todo == null) return;
  _todos[id] = Todo(
    id: id,
    title: title ?? todo.title,
    isCompleted: isCompleted ?? todo.isCompleted,
  );
}

/// delete
void deleteTodo(String id) => _todos.remove(id);
