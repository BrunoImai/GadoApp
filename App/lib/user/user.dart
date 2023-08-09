
class UserRequest {
  final String name;
  final String email;
  final String password;

  UserRequest({required this.name, required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }
}


class UserLoginRequest {
  final String email;
  final String password;

  UserLoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class LoggedUser {
  String token;
  int id;
  String name;
  String email;
  bool isAdm;

  LoggedUser(this.token, this.id, this.name, this.email, this.isAdm);
}