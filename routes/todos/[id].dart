import 'package:dart_frog/dart_frog.dart';
import 'package:my_project/src/todo_repository.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final todo = getTodoById(id);
  if (todo == null) return Response(statusCode: 404);

  switch (context.request.method) {
    case HttpMethod.get:
      return Response.json(body: todo.toJson());
    case HttpMethod.put:
      final body = await context.request.json() as Map<String, dynamic>;
      final title = body['title'] as String?;
      final isCompleted = body['isCompleted'] as bool?;
      updateTodo(id, title: title, isCompleted: isCompleted);
      return Response.json(body: getTodoById(id)!.toJson());
    case HttpMethod.delete:
      deleteTodo(id);
      return Response(statusCode: 204);
    case HttpMethod.post:
    case HttpMethod.patch:
    case HttpMethod.head:
    case HttpMethod.options:
      return Response(statusCode: 405);
  }
}
