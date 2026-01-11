///
class Todo {
  ///
  Todo({required this.id, required this.title, this.isCompleted = false});

  /// fromJson
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  /// id
  final String id;

  /// title
  final String title;

  /// isCompleted
  bool isCompleted;

  /// toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }
}
