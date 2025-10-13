import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pet.dart';

class PetService {
  static const String baseUrl = 'http://10.0.2.2:8080/pets';

  /// Adiciona um novo pet no backend
  static Future<bool> addPet(Pet pet) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pet.toJson()),
    );
    return response.statusCode == 201; // Created
  }

  /// Busca todos os pets do backend
  static Future<List<Pet>> getPets() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Pet.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar pets');
    }
  }

  /// Atualiza um pet existente
  static Future<bool> updatePet(Pet pet) async {
    if (pet.id == null) return false;
    final response = await http.put(
      Uri.parse('$baseUrl/${pet.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pet.toJson()),
    );
    return response.statusCode == 200;
  }

  /// Exclui um pet
  static Future<bool> deletePet(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    return response.statusCode == 204; // No Content
  }

  // ========== Validações simples (opcional) ==========
  static bool isValidName(String name) => name.isNotEmpty;
  static bool isValidBreed(String breed) => breed.isNotEmpty;
  static bool isValidSpecies(String species) => species.isNotEmpty;
  static bool isValidWeight(double weight) => weight > 0;
}
