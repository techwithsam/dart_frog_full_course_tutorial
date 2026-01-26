import 'package:bcrypt/bcrypt.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:my_project/src/user_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405, body: 'Method Not Allowed');
  }

  final body = await context.request.json() as Map<String, dynamic>;
  final username = body['username'] as String?;
  final password = body['password'] as String?;

  if (username == null ||
      username.isEmpty ||
      password == null ||
      password.isEmpty) {
    return Response(
      statusCode: 400,
      body: 'Username and password are required.',
    );
  }

  if (findUserByUsername(username) != null) {
    return Response(statusCode: 409, body: 'Username already exists.');
  }

  final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
  final user = createUser(username: username, passwordHash: hashedPassword);

  return Response.json(body: user.toJson());
}
