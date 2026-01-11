import 'package:dart_frog/dart_frog.dart';
import 'package:my_project/src/todo_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      final todos = getAllTodos();
      return Response.json(body: todos.map((e) => e.toJson()).toList());
    case HttpMethod.post:
      final body = await context.request.json() as Map<String, dynamic>;
      final title = body['title'] as String?;
      if (title == null || title.isEmpty) {
        return Response(statusCode: 400, body: 'Title is required');
      }
      createTodo(title);
      return Response(statusCode: 201, body: 'Todo created');
    case HttpMethod.delete:
    case HttpMethod.put:
    case HttpMethod.patch:
    case HttpMethod.head:
    case HttpMethod.options:
      return Response(statusCode: 405);
  }
}
