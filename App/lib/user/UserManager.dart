import 'package:gado_app/user/user.dart';

class UserManager {
  // Private constructor
  UserManager._();

  // Singleton instance
  static UserManager? _instance;

  // Getter for the singleton instance
  static UserManager get instance {
    _instance ??= UserManager._();
    return _instance!;
  }

  // Other properties and methods of the singleton class
  LoggedUser? loggedUser;
}
