import 'dart:convert';
import 'package:http/http.dart' as http;

class VerificationService {
  static const String baseUrl = 'http://10.0.2.2:8080/verification';

  /// Envia o código de verificação para o e-mail informado
  static Future<String> sendVerificationCode(String email) async {
    final url = Uri.parse('$baseUrl/send');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'];
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Erro ao enviar código.',
      );
    }
  }

  /// Verifica se o código informado é válido
  static Future<String> checkVerificationCode(String email, String code) async {
    final url = Uri.parse('$baseUrl/check');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'code': code}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'];
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Código incorreto ou expirado.',
      );
    }
  }
}
