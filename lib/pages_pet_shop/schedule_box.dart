import 'package:flutter/material.dart';
import 'schedulePage.dart';

class ScheduleBox extends StatelessWidget {
  final Map<String, Map<String, String>>? schedules;
  final Function(dynamic) onEdit;

  const ScheduleBox({super.key, required this.schedules, required this.onEdit});

  // ✅ Ordem fixa dos dias da semana
  static const List<String> _diasOrdenados = [
    'Seg',
    'Ter',
    'Qua',
    'Qui',
    'Sex',
    'Sáb',
    'Dom',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final horizontalPadding = screenWidth * 0.05;
    final verticalPadding = screenWidth * 0.03;
    final iconSize = screenWidth * 0.045;
    final borderRadius = screenWidth * 0.045;
    final buttonHorizontalPadding = screenWidth * 0.08;
    final buttonVerticalPadding = screenWidth * 0.035;
    final spacing = screenWidth * 0.03;

    print('📦 ScheduleBox build chamado');
    print('📦 schedules recebido: $schedules');
    print('📦 schedules é null? ${schedules == null}');
    print('📦 schedules.isEmpty? ${schedules?.isEmpty}');

    // ✅ Verifica se tem ALGUM dia com horário válido
    final hasAnySchedule = schedules != null &&
        schedules!.values.any((times) =>
        times['abre']?.isNotEmpty == true ||
            times['fecha']?.isNotEmpty == true);

    print('📦 hasAnySchedule? $hasAnySchedule');

    if (!hasAnySchedule) {
      print('📦 Mostrando botão CADASTRAR');
      return ElevatedButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SchedulePage(initialSchedules: {}),
            ),
          );

          if (result != null && result is Map<String, Map<String, String>>) {
            final merged = {...?schedules, ...result};
            onEdit(merged);
          } else {
            onEdit(null);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF4E04D),
          padding: EdgeInsets.symmetric(
              horizontal: buttonHorizontalPadding,
              vertical: buttonVerticalPadding),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(
          "Cadastrar Horários",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.04),
        ),
      );
    }

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
          padding: EdgeInsets.symmetric(
              vertical: verticalPadding, horizontal: horizontalPadding),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9C4),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.black54, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Percorre os dias na ordem correta
              for (var day in _diasOrdenados)
                if (schedules!.containsKey(day))
                  Builder(
                    builder: (context) {
                      final openTime = schedules![day]!['abre'] ?? '';
                      final closeTime = schedules![day]!['fecha'] ?? '';

                      // Só mostra se tiver pelo menos um horário
                      if (openTime.isEmpty && closeTime.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: spacing / 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    size: iconSize, color: Colors.black54),
                                SizedBox(width: spacing / 2),
                                Text(day,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: screenWidth * 0.038)),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.schedule,
                                    size: iconSize, color: Colors.black54),
                                SizedBox(width: spacing / 3),
                                Text("$openTime - $closeTime",
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.036)),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            ],
          ),
        ),
        SizedBox(height: spacing),
        ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SchedulePage(initialSchedules: schedules ?? {}),
              ),
            );

            if (result != null && result is Map<String, Map<String, String>>) {
              final merged = {...?schedules, ...result};
              onEdit(merged);
            } else {
              onEdit(null);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF4E04D),
            padding: EdgeInsets.symmetric(
                horizontal: buttonHorizontalPadding,
                vertical: buttonVerticalPadding),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: Text(
            "Editar horários",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.04),
          ),
        ),
      ],
    );
  }
}