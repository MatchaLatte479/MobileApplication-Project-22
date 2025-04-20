// user_model.dart - For storing current user info
class User {
  final int id;
  final String username;
  final String email;

  User({required this.id, required this.username, required this.email});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
    );
  }
}