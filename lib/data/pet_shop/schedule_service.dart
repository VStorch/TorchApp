import 'dart:convert';
import 'package:http/http.dart' as http;

class ScheduleService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/schedules';

  //  Ordem fixa dos dias da semana
  static const List<String> _diasOrdenados = [
    'Seg',
    'Ter',
    'Qua',
    'Qui',
    'Sex',
    'Sáb',
    'Dom',
  ];

  /// Salvar horários em lote
  Future<Map<String, dynamic>> saveBulkSchedules({
    required int petShopId,
    required Map<String, Map<String, String>> schedules,
  }) async {
    try {
      final List<Map<String, String>> schedulesList = [];

      print('🔵 Salvando horários recebidos: $schedules');

      //  Percorre na ordem correta dos dias
      for (var day in _diasOrdenados) {
        print('🔍 Verificando dia: $day');
        if (schedules.containsKey(day)) {
          final times = schedules[day]!;
          print('   → abre: ${times['abre']}, fecha: ${times['fecha']}');

          if (times['abre']!.isNotEmpty && times['fecha']!.isNotEmpty) {
            schedulesList.add({
              'day': day,
              'openTime': times['abre']!,
              'closeTime': times['fecha']!,
            });
            print('    Adicionado à lista');
          } else {
            print('   ⚠ Ignorado (horários vazios)');
          }
        } else {
          print('   ⚠ Dia não encontrado no mapa schedules');
        }
      }

      final body = {
        'petShopId': petShopId,
        'schedules': schedulesList,
      };

      print('📤 Enviando horários: ${jsonEncode(body)}');

      final response = await http.post(
        Uri.parse('$baseUrl/bulk'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('📥 Status: ${response.statusCode}');
      print('📥 Response: ${response.body}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': 'Erro ao salvar horários: ${response.statusCode}',
        };
      }
    } catch (e) {
      print(' Erro ao salvar horários: $e');
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }

  /// Buscar horários de um Pet Shop
  Future<Map<String, dynamic>> getSchedulesByPetShop(int petShopId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/petshop/$petShopId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        print('🔍 Dados recebidos do backend: $data');

        //  Usa LinkedHashMap para manter a ordem de inserção
        final Map<String, Map<String, String>> schedules = {};

        //  Insere na ordem correta dos dias
        for (var day in _diasOrdenados) {
          print('🔍 Procurando dia: $day');

          //  Para Sábado, tenta com e sem acento
          final possibleValues = day == 'Sáb'
              ? ['SÁB', 'SAB', 'SABADO', 'SÁBADO']
              : [day.toUpperCase()];

          print('   Valores possíveis: $possibleValues');

          final schedule = data.firstWhere(
                (s) {
              final dayFromBackend = s['dayOfWeek']?.toString().toUpperCase() ?? '';
              print('   Comparando com backend: $dayFromBackend');
              return possibleValues.contains(dayFromBackend);
            },
            orElse: () => null,
          );

          if (schedule != null) {
            schedules[day] = {
              'abre': schedule['openTime'] ?? '',
              'fecha': schedule['closeTime'] ?? '',
            };
            print('    Dia $day encontrado: ${schedules[day]}');
          } else {
            print('   ⚠ Dia $day NÃO encontrado no backend');
          }
        }

        print(' Schedules final montado: $schedules');

        return {
          'success': true,
          'data': schedules,
        };
      } else if (response.statusCode == 404) {
        return {
          'success': true,
          'data': {}, // Nenhum horário cadastrado ainda
        };
      } else {
        return {
          'success': false,
          'message': 'Erro ao buscar horários: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Erro ao buscar horários: $e');
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }

  /// Deletar todos os horários de um Pet Shop
  Future<Map<String, dynamic>> deleteAllSchedules(int petShopId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/petshop/$petShopId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Horários deletados com sucesso',
        };
      } else {
        return {
          'success': false,
          'message': 'Erro ao deletar horários: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
      };
    }
  }
}