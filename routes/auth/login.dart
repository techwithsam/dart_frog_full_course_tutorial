import 'package:bcrypt/bcrypt.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:my_project/src/constant.dart';
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

  final user = findUserByUsername(username);
  if (user == null || !BCrypt.checkpw(password, user.hashedPassword)) {
    return Response(statusCode: 401, body: 'Invalid username or password.');
  }

  final jwt = JWT({
    'id': user.id,
    'username': user.username,
  });

  final token = jwt.sign(SecretKey(jwtSecret));

  return Response.json(body: {'token': token});
}
