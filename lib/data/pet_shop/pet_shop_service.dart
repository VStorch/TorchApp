import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:torch_app/data/pet_shop/pet_shop.dart';

class PetShopService {
  static const String baseUrl = 'http://10.0.2.2:8080/petshops';

  Future<List<PetShop>> getPetShops() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => PetShop.fromJson(e)).toList();
      } else {
        throw Exception('Erro ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar PetShops: $e');
      return [];
    }
  }

  void toggleFavorite(PetShop shop) {
    shop.toggleFavorite();
  }
}
