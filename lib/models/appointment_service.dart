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

  // Criar agendamento
  static Future<Map<String, dynamic>> createAppointment({
    required int userId,
    required int petId,
    required int petShopId,
    required int serviceId,
    required int slotId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/appointments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'petId': petId,
          'petShopId': petShopId,
          'serviceId': serviceId,
          'slotId': slotId,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Erro ao criar agendamento: ${response.body}');
      }
    } catch (e) {
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
        print('📦 Dados recebidos do backend: $data'); // DEBUG
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

      // DEBUG: Ver o que está vindo
      print('🔍 TODOS OS AGENDAMENTOS:');
      for (var appointment in allAppointments) {
        print('Pet Shop Name: ${appointment['petShopName']}');
        print('Service Name: ${appointment['serviceName']}');
        print('Pet Name: ${appointment['petName']}');
        print('Pet Shop ID: ${appointment['petShopId']}');
        print('---');
      }

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
}