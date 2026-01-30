import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio;

  AuthService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl:
                  "https://my-project-1lg5ivc-samuel-adekunle-techwithsam.globeapp.dev",
              connectTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 5),
              headers: {'Content-Type': 'application/json'},
            ),
          );

  Future<String> login({
    required String username,
    required String password,
  }) async {
    final response = await _dio.post(
      '/auth/login',
      data: {'username': username, 'password': password},
    );
    final data = response.data as Map<String, dynamic>;
    final token = data['token'] as String?;
    if (token == null || token.isEmpty) {
      throw Exception('Invalid token response');
    }
    return token;
  }

  Future<void> register({
    required String username,
    required String password,
  }) async {
    await _dio.post(
      '/auth/register',
      data: {'username': username, 'password': password},
    );
  }
}
