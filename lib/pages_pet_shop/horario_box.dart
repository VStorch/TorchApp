import 'package:flutter/material.dart';
import 'schedulePage.dart';

class HorarioBox extends StatelessWidget {
  final Map<String, Map<String, String>>? horarios;
  final Function(dynamic) onEdit;

  const HorarioBox({super.key, required this.horarios, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final horizontalPadding = screenWidth * 0.05; // 5% da tela
    final verticalPadding = screenWidth * 0.03;
    final iconSize = screenWidth * 0.045; // proporcional ao tamanho da tela
    final borderRadius = screenWidth * 0.045;
    final buttonHorizontalPadding = screenWidth * 0.08;
    final buttonVerticalPadding = screenWidth * 0.035;
    final spacing = screenWidth * 0.03;

    if (horarios == null) {
      return ElevatedButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SchedulePage()),
          );
          onEdit(result);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF4E04D),
          padding: EdgeInsets.symmetric(
              horizontal: buttonHorizontalPadding, vertical: buttonVerticalPadding),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(
          "Cadastrar Horários",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04),
        ),
      );
    }

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
          padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
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
            children: horarios!.entries.map((entry) {
              final dia = entry.key;
              final abre = entry.value['abre'] ?? '';
              final fecha = entry.value['fecha'] ?? '';

              return Padding(
                padding: EdgeInsets.symmetric(vertical: spacing / 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: iconSize, color: Colors.black54),
                        SizedBox(width: spacing / 2),
                        Text(dia,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: screenWidth * 0.038)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.schedule, size: iconSize, color: Colors.black54),
                        SizedBox(width: spacing / 3),
                        Text("$abre - $fecha", style: TextStyle(fontSize: screenWidth * 0.036)),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: spacing),
        ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SchedulePage()),
            );
            onEdit(result);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF4E04D),
            padding: EdgeInsets.symmetric(
                horizontal: buttonHorizontalPadding, vertical: buttonVerticalPadding),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: Text(
            "Editar horários",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04),
          ),
        ),
      ],
    );
  }
}
