import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:torch_app/data/pet_shop_services/petshop_service.dart';

class PetShopServiceService {
  static const String baseUrl = 'http://10.0.2.2:8080/services';

  static Future<PetShopService?> addService(PetShopService service) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(service.toJson()),
    );

    if (response.statusCode == 201) {
      return PetShopService.fromJson(jsonDecode(response.body));
    } else {
      print('Erro ao cadastrar: ${response.body}');
      return null;
    }
  }


  static Future<List<PetShopService>> getByPetShopId(int petShopId) async {
    final response = await http.get(Uri.parse('$baseUrl/petshops/$petShopId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => PetShopService.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar serviços: ${response.body}');
    }
  }


  static Future<bool> deleteService(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    return response.statusCode == 204;
  }


  static Future<bool> updateService(int id, PetShopService service) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(service.toJson()),
    );
    return response.statusCode == 200;
  }
}