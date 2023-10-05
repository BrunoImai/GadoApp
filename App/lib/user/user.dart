
class UserRequest {
  final String name;
  final String cellphone;
  final String password;
  final String email;

  UserRequest({required this.name, required this.cellphone, required this.password, required this.email});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cellphone': cellphone,
      'email': email,
      'password': password,
    };
  }
}


class UserLoginRequest {
  final String cellphone;
  final String password;

  UserLoginRequest({required this.cellphone, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'cellphone': cellphone,
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