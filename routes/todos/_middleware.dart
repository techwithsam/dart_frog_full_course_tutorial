import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(
        (handler) => (context) async {
          final response = await handler(context);
          return response.copyWith(
            headers: {
              'Access-Control-Allow-Origin': '*',
              'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
              'Access-Control-Allow-Headers': 'Content-Type',
            },
          );
        },
      );
}
