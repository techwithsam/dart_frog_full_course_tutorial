import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_todo_dart_frog/models/todo.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Platform.isAndroid
          ? "http://10.0.2.2:8080"
          : "http://localhost:8080",
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
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
