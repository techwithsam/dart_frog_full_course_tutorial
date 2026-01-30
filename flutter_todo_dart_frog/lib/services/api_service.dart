import 'package:dio/dio.dart';
import 'package:flutter_todo_dart_frog/models/todo.dart';

class ApiService {
  final Dio _dio;

  ApiService({String? token})
    : _dio = Dio(
        BaseOptions(
          baseUrl:
              "https://my-project-1lg5ivc-samuel-adekunle-techwithsam.globeapp.dev",
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
          headers: {
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

  Future<List<Todo>> getTodos() async {
    try {
      final response = await _dio.get('/todos');
      if (response.data is List) {
        final todos = (response.data as List)
            .map((todoJson) => Todo.fromJson(todoJson as Map<String, dynamic>))
            .toList();
        return todos;
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createTodo(Todo todo) async {
    try {
      await _dio.post('/todos', data: todo.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      await _dio.put('/todos/${todo.id}', data: todo.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await _dio.delete('/todos/$id');
    } catch (e) {
      rethrow;
    }
  }
}
