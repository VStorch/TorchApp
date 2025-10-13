import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pet.dart';

class PetService {
  static const String baseUrl = 'http://10.0.2.2:8080/pets';

  static Future<bool> addPet(Pet pet) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pet.toJson()),
    );
    print("ADD PET STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");
    return response.statusCode == 201;
  }

  static Future<List<Pet>> getPets() async {
    final response = await http.get(Uri.parse(baseUrl));
    print("GET PETS STATUS: ${response.statusCode}");
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Pet.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar pets');
    }
  }

  static Future<bool> updatePet(Pet pet) async {
    if (pet.id == null) return false;
    final response = await http.put(
      Uri.parse('$baseUrl/${pet.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pet.toJson()),
    );
    print("UPDATE PET STATUS: ${response.statusCode}");
    return response.statusCode == 200;
  }

  static Future<bool> deletePet(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    print("DELETE PET STATUS: ${response.statusCode}");
    return response.statusCode == 204;
  }
}
