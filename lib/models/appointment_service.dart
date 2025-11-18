// lib/models/appointment_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AppointmentService {
  static const String baseUrl = 'http://10.0.2.2:8080';

  // Buscar pets do usuário
  static Future<List<Map<String, dynamic>>> getUserPets(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/pets/users/$userId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((pet) => pet as Map<String, dynamic>).toList();
      } else {
        throw Exception('Erro ao carregar pets: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Criar agendamento COM suporte a cupom de desconto ← ATUALIZADO
  static Future<Map<String, dynamic>> createAppointment({
    required int userId,
    required int petId,
    required int petShopId,
    required int serviceId,
    required int slotId,
    String? couponCode,           // ← NOVO
    double? discountPercent,      // ← NOVO
    double? finalPrice,           // ← NOVO
  }) async {
    try {
      final body = {
        'userId': userId,
        'petId': petId,
        'petShopId': petShopId,
        'serviceId': serviceId,
        'slotId': slotId,
        if (couponCode != null && couponCode.isNotEmpty) 'couponCode': couponCode,
        if (discountPercent != null) 'discountPercent': discountPercent,
        if (finalPrice != null) 'finalPrice': finalPrice,
      };

      print('📤 Criando agendamento com dados: $body');

      final response = await http.post(
        Uri.parse('$baseUrl/appointments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        print('✅ Agendamento criado com sucesso!');
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print('❌ Erro ${response.statusCode}: ${response.body}');
        throw Exception('Erro ao criar agendamento: ${response.body}');
      }
    } catch (e) {
      print('❌ Erro ao criar agendamento: $e');
      throw Exception('Erro de conexão: $e');
    }
  }

  // Buscar todos os agendamentos
  static Future<List<Map<String, dynamic>>> getAllAppointments() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/appointments'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((appointment) => appointment as Map<String, dynamic>).toList();
      } else {
        throw Exception('Erro ao carregar agendamentos: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Buscar agendamentos por usuário
  static Future<List<Map<String, dynamic>>> getUserAppointments(int userId) async {
    try {
      final allAppointments = await getAllAppointments();

      // Filtrar agendamentos do usuário
      return allAppointments.where((appointment) {
        return appointment['userId'] == userId;
      }).toList();
    } catch (e) {
      throw Exception('Erro ao carregar agendamentos do usuário: $e');
    }
  }

  // Cancelar agendamento
  static Future<void> cancelAppointment(int appointmentId) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/appointments/$appointmentId'),
      );

      if (response.statusCode != 200) {
        throw Exception('Erro ao cancelar agendamento: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Deletar agendamento
  static Future<void> deleteAppointment(int appointmentId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/appointments/$appointmentId'),
      );

      if (response.statusCode != 204) {
        throw Exception('Erro ao deletar agendamento: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Confirmar agendamento (muda status de PENDING para CONFIRMED)
  static Future<void> confirmAppointment(int appointmentId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/appointments/$appointmentId/confirm'),
      );

      if (response.statusCode != 200) {
        throw Exception('Erro ao confirmar agendamento: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Concluir agendamento (muda status para COMPLETED)
  static Future<void> completeAppointment(int appointmentId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/appointments/$appointmentId/complete'),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao concluir agendamento: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Avaliar Pet Shop
  static Future<void> evaluatePetShop({
    required int userId,
    required int petShopId,
    required int rating,
    String? comment,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/evaluate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'petShopId': petShopId,
          'rating': rating,
          'comment': comment ?? '',
        }),
      );

      if (response.statusCode != 201) {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Erro ao enviar avaliação');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Verificar se usuário já avaliou um Pet Shop
  static Future<bool> hasUserEvaluated({
    required int userId,
    required int petShopId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/evaluate/$petShopId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> evaluations = jsonDecode(response.body);

        // Verificar se existe alguma avaliação deste usuário
        return evaluations.any((evaluation) => evaluation['userId'] == userId);
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}