// lib/services/promotion_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/promotion.dart';

class PromotionService {
  // Altere para o IP do seu backend
  static const String baseUrl = 'http://10.0.2.2:8080/api/promotions';
  // Para emulador Android: 'http://10.0.2.2:8080/api/promotions'
  // Para dispositivo real: 'http://SEU_IP:8080/api/promotions'

  // Buscar todas as promoções
  Future<List<Promotion>> getAllPromotions() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Promotion.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao buscar promoções');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Criar nova promoção
  Future<Promotion> createPromotion(Promotion promotion) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(promotion.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Promotion.fromJson(json.decode(response.body));
      } else {
        throw Exception('Erro ao criar promoção');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Atualizar promoção
  Future<Promotion> updatePromotion(int id, Promotion promotion) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(promotion.toJson()),
      );

      if (response.statusCode == 200) {
        return Promotion.fromJson(json.decode(response.body));
      } else {
        throw Exception('Erro ao atualizar promoção');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Deletar promoção
  Future<void> deletePromotion(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Erro ao deletar promoção');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Buscar promoções ativas
  Future<List<Promotion>> getActivePromotions() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/active'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Promotion.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao buscar promoções ativas');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}