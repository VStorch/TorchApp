import 'package:http/http.dart' as http;
import 'dart:convert';

// Modelo de dados
class TimeSlot {
  final int? id;
  final String startTime;
  final String endTime;
  final bool isBooked;

  TimeSlot({
    this.id,
    required this.startTime,
    required this.endTime,
    this.isBooked = false,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      isBooked: json['booked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}

// Serviço de API
class ApiService {
  // ALTERE ESTA URL PARA O ENDEREÇO DO SEU BACKEND
  static const String baseUrl = 'http://10.0.2.2:8080';

  // Para Android Emulator use: http://10.0.2.2:8080
  // Para dispositivo físico use o IP da sua máquina: http://192.168.x.x:8080

  // Criar um único slot
  static Future<TimeSlot> createSlot({
    required int serviceId,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/slots'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'serviceId': serviceId,
          'date': date,
          'startTime': startTime,
          'endTime': endTime,
        }),
      );

      if (response.statusCode == 201) {
        return TimeSlot.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Erro ao criar horário: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Criar múltiplos slots (bulk)
  static Future<List<TimeSlot>> createSlotsBulk({
    required int serviceId,
    required String date,
    required String startTime,
    required String endTime,
    required int intervalMinutes,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/slots/bulk'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'serviceId': serviceId,
          'date': date,
          'startTime': startTime,
          'endTime': endTime,
          'intervalMinutes': intervalMinutes,
        }),
      );

      if (response.statusCode == 201) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => TimeSlot.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao gerar horários: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Buscar slots disponíveis
  static Future<List<TimeSlot>> getAvailableSlots({
    required int serviceId,
    required String date,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/slots?serviceId=$serviceId&targetDate=$date'),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => TimeSlot.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao buscar horários');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Deletar slot
  static Future<void> deleteSlot(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/slots/$id'),
      );

      if (response.statusCode != 204) {
        throw Exception('Erro ao deletar horário');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}