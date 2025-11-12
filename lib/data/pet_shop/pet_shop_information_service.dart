import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class PetShopInformationService {
  // Altere para o IP da sua máquina se estiver testando em dispositivo físico
  static const String baseUrl = 'http://10.0.2.2:8080/api/petshop-information';
  // Para emulador Android: 'http://10.0.2.2:8080/api/petshop-information'
  // Para dispositivo físico: 'http://SEU_IP:8080/api/petshop-information'

  // Criar informações do Pet Shop
  Future<Map<String, dynamic>> createPetShopInformation({
    required String name,
    required String description,
    required List<String> services,
    required int userId,
    String? instagram,
    String? facebook,
    String? website,
    String? whatsapp,
    String? commercialPhone,
    String? commercialEmail,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'description': description,
          'services': services,
          'instagram': instagram,
          'facebook': facebook,
          'website': website,
          'whatsapp': whatsapp,
          'commercialPhone': commercialPhone,
          'commercialEmail': commercialEmail,
          'userId': userId,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Erro ao criar Pet Shop');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Buscar informações por ID do Pet Shop
  Future<Map<String, dynamic>> getPetShopInformationById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Pet Shop não encontrado');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Buscar informações por ID do usuário
  Future<Map<String, dynamic>> getPetShopInformationByUserId(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/$userId'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Pet Shop não encontrado');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Atualizar informações do Pet Shop
  Future<Map<String, dynamic>> updatePetShopInformation({
    required int id,
    required String name,
    required String description,
    required List<String> services,
    required int userId,
    String? instagram,
    String? facebook,
    String? website,
    String? whatsapp,
    String? commercialPhone,
    String? commercialEmail,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'description': description,
          'services': services,
          'instagram': instagram,
          'facebook': facebook,
          'website': website,
          'whatsapp': whatsapp,
          'commercialPhone': commercialPhone,
          'commercialEmail': commercialEmail,
          'userId': userId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Erro ao atualizar Pet Shop');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Upload da logo
  Future<Map<String, dynamic>> uploadLogo(int petShopId, File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/$petShopId/logo'),
      );

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Erro ao fazer upload da logo');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Deletar Pet Shop
  Future<Map<String, dynamic>> deletePetShopInformation(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Erro ao deletar Pet Shop');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}