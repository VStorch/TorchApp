import 'package:torch_app/data/user.dart';

class UserDb {
  static final List<User> _users = [];

  static void addUser(User user) {
    _users.add(user);
  }

  // Método para verificar se o o email e a senha estão corretos
  static bool checkUser(String email, String password) {
    for (User user in _users) {
      if (user.email == email && user.password == password) {
        return true;
      }
    }
    return false;
  }

  // Método para verificar se o email existe
  static bool emailExists(String email) {
    for (User user in _users) {
      if (user.email == email) {
        return true;
      }
    }
    return false;
  }
  // Método para verificar se o email é válido
  static bool isValidEmail(String email) {
    // Expressão regular para verificar um e-mail básico
    String pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    RegExp regExp = RegExp(pattern);

    return regExp.hasMatch(email);
  }

  //Método verificador de senha
  static bool isValidPassword(String password){
    return password.length <8;
  }

  //Método verificador de nome
  static bool isValidName(String name){
    String pattern =
        r'^[a-zA-ZáéíóúãõâêîôûçÇ ]';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(name);
  }
  //Método verificador de sobrenome
  static bool isValidSurname(String surname){
    String pattern =
        r'^[a-zA-ZáéíóúãõâêîôûçÇ ]';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(surname);
  }
}