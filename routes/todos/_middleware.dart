import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:my_project/src/constant.dart';
import 'package:my_project/src/user_model.dart';
import 'package:my_project/src/user_repository.dart';

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(_authMiddleware).use(_corsMiddleware);
}

Handler _corsMiddleware(Handler handler) {
  return (context) async {
    final response = await handler(context);
    return response.copyWith(
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type',
      },
    );
  };
}

Handler _authMiddleware(Handler handler) {
  return (context) async {
    if (context.request.method == HttpMethod.options) {
      return handler(context);
    }

    final authHeader = context.request.headers['Authorization'];
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return Response(
        statusCode: 401,
        body: 'Missing or invalid Authorization header',
      );
    }

    final token = authHeader.substring(7);

    try {
      final jwt = JWT.verify(token, SecretKey(jwtSecret));
      final payload = jwt.payload as Map<String, dynamic>;
      final userId = payload['id'] as String;

      final user = findUserById(userId);
      if (user == null) {
        return Response(statusCode: 401, body: 'User not found');
      }

      return handler(context.provide<User>(() => user));
    } catch (e) {
      return Response(statusCode: 401, body: 'Invalid token: $e');
    }
  };
}
