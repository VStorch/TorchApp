import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:torch_app/data/user/user.dart';
import 'package:http_parser/http_parser.dart' show MediaType;


class UserService {
  static const String baseUrl = 'http://10.0.2.2:8080/users';

  // Metódo para adicionar um novo usuário ao servidor
  static Future<bool> addUser(User user) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    return response.statusCode == 201; // 201 Created
  }

  // Verifica se email já existe no servidor
  static Future<bool> emailExists(String email) async {
    final url = Uri.parse("$baseUrl/email/$email");
    final response = await http.get(url);
    return response.statusCode == 200;
  }

  // Buscar todos os usuários
  static Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar usuários');
    }
  }

  // Método de Login
  static Future<bool> loginUser(String email, String password) async {
    final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password})
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String?> updloadUserImage(int userId, File imageFile) async {
    try {
      print('🔵 Iniciando upload da imagem...');
      print('🔵 Caminho do arquivo: ${imageFile.path}');
      print('🔵 Arquivo existe: ${await imageFile.exists()}');

      final uri = Uri.parse('$baseUrl/$userId/upload-image');
      final request = http.MultipartRequest('POST', uri);

      final extension = imageFile.path.split('.').last.toLowerCase();
      print('🔵 Extensão detectada: $extension');

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          filename: imageFile.path.split('/').last,
          contentType: MediaType('image', extension == 'png' ? 'png' : 'jpeg'),
        ),
      );

      print('🔵 Enviando request...');
      final response = await request.send();
      print('🔵 Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        print('🟢 Resposta do servidor: $body');
        final json = jsonDecode(body);
        return json['profileImage'];
      } else {
        final body = await response.stream.bytesToString();
        print('🔴 Erro do servidor: $body');
      }

      print('🔴 Erro no upload: Status ${response.statusCode}');
      return null;
    } catch (e) {
      print('🔴 Exceção ao fazer upload da imagem: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getUserById(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$userId'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Erro ao buscar usuário: $e');
      return null;
    }
  }


  // =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  // Métodos de validação

  static bool isValidEmail(String email) {
    // Expressão regular para verificar um e-mail básico
    String pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    RegExp regExp = RegExp(pattern);

    return regExp.hasMatch(email);
  }

  static bool isValidPassword(String password){
    return password.length >= 8;
  }

  static bool isValidName(String name){
    String pattern = r'^[a-zA-ZáéíóúãõâêîôûçÇ ]+$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(name);
  }

  static bool isValidSurname(String surname){
    String pattern = r'^[a-zA-ZáéíóúãõâêîôûçÇ ]+$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(surname);
  }
}