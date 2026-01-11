import 'package:dart_frog/dart_frog.dart';

final _users = <Map<String, dynamic>>[
  {'id': 1, 'name': 'Alice'},
  {'id': 2, 'name': 'Bob'},
  {'id': 3, 'name': 'Charlie'},
];

Future<Response> onRequest(RequestContext context) async {
  // get method to fetch users
  if (context.request.method == HttpMethod.get) {
    return Response.json(body: _users);
  }

  // post method to add a new user
  if (context.request.method == HttpMethod.post) {
    final body = await context.request.json() as Map<String, dynamic>;

    final newUser = {
      'id': _users.length + 1,
      'name': body['name'],
    };
    _users.add(newUser);
    return Response.json(body: newUser, statusCode: 201);
  }

  return Response(statusCode: 405);
}
