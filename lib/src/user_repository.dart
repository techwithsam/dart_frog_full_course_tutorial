import 'package:collection/collection.dart';
import 'package:my_project/src/user_model.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();
final _users = <String, User>{};

/// Find user by username
User? findUserByUsername(String username) {
  return _users.values.firstWhereOrNull((u) => u.username == username);
}

/// Find user by id
User? findUserById(String id) {
  return _users[id];
}

/// Create user
User createUser({required String username, required String passwordHash}) {
  final id = _uuid.v4();
  final user = User(id: id, username: username, hashedPassword: passwordHash);
  _users[id] = user;
  return user;
}
