import 'package:torch_app/data/user.dart';

class UserDb {
  static final List<User> _users = [];

  static void addUser(User user) {
    _users.add(user);
  }

  static bool checkUser(String email, String password) {
    for (User user in _users) {
      if (user.email == email && user.password == password) {
        return true;
      }
    }
    return false;
  }

  static bool emailExists(String email) {
    for (User user in _users) {
      if (user.email == email) {
        return true;
      }
    }
    return false;
  }

}