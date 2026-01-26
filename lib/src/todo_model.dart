///
class Todo {
  ///
  Todo({
    required this.id,
    required this.title,
    required this.userId,
    this.isCompleted = false,
  });

  /// fromJson
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      userId: json['userId'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  /// id
  final String id;

  /// title
  final String title;

  /// userId
  final String userId;

  /// isCompleted
  bool isCompleted;

  /// toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'userId': userId,
      'isCompleted': isCompleted,
    };
  }
}
