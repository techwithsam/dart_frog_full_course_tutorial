///
class User {
  ///
  const User({
    required this.id,
    required this.username,
    required this.hashedPassword,
  });

  /// fromJson
  final String id;

  /// username
  final String username;

  /// hashedPassword
  final String hashedPassword;

  /// toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
    };
  }
}
