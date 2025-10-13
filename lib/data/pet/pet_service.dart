import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:torch_app/data/pet/pet.dart';

class PetService {
  static const String baseUrl = 'http://10.0.2.2:8080/pets';

  // Adicionar novo pet
  static Future<bool> addPet(Pet pet) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pet.toJson()),
    );
    return response.statusCode == 201; // 201 Created
  }

  // Buscar todos os pets
  static Future<List<Pet>> getPets() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Pet.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar pets');
    }
  }

  // Buscar pet por ID
  static Future<Pet?> getPetById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Pet.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  // Atualizar pet
  static Future<bool> updatePet(Pet pet) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${pet.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pet.toJson()),
    );
    return response.statusCode == 200; // 200 OK
  }

  // Remover pet
  static Future<bool> deletePet(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    return response.statusCode == 204; // 204 No Content
  }
}
