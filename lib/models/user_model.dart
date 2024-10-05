class User {
  int? id;
  String username;
  String email;
  String password;

  User(
      {this.id,
      required this.username,
      required this.email,
      required this.password});

  // Convert User object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  // Convert Map to User object
  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
    );
  }
}
