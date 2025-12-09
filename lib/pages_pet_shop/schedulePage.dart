import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SchedulePage extends StatefulWidget {
  final Map<String, Map<String, String>> initialSchedules;

  const SchedulePage({super.key, required this.initialSchedules});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final Color yellow = const Color(0xFFF4E04D);

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

  // ✅ Usa LinkedHashMap mantendo ordem de inserção
  late final Map<String, TextEditingController> _openControllers;
  late final Map<String, TextEditingController> _closeControllers;

  @override
  void initState() {
    super.initState();

    print('🟢 SchedulePage initState');
    print('🟢 initialSchedules recebido: ${widget.initialSchedules}');

    // ✅ Inicializa os controllers na ordem correta
    _openControllers = {
      for (var dia in _diasOrdenados) dia: TextEditingController()
    };

    _closeControllers = {
      for (var dia in _diasOrdenados) dia: TextEditingController()
    };

    // Preenche os controllers com os horários inicialmente passados
    if (widget.initialSchedules.isNotEmpty) {
      widget.initialSchedules.forEach((dia, valores) {
        print('🟢 Preenchendo dia: $dia com valores: $valores');

        if (_openControllers.containsKey(dia)) {
          _openControllers[dia]?.text = valores['abre'] ?? '';
          _closeControllers[dia]?.text = valores['fecha'] ?? '';
          print('   ✅ Preenchido: abre=${valores['abre']}, fecha=${valores['fecha']}');
        } else {
          print('   ⚠️ Dia $dia não tem controller ou valores inválidos');
        }
      });
    }

    // Debug: mostra todos os controllers depois de preencher
    print('🟢 Controllers após preenchimento:');
    for (var dia in _diasOrdenados) {
      print('   $dia: abre="${_openControllers[dia]?.text}" fecha="${_closeControllers[dia]?.text}"');
    }
  }

  @override
  void dispose() {
    _openControllers.forEach((_, c) => c.dispose());
    _closeControllers.forEach((_, c) => c.dispose());
    super.dispose();
  }

  Future<void> _pickTime(String day, bool isOpening) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: yellow,
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: yellow),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        final formatted = picked.format(context);
        if (isOpening) {
          _openControllers[day]!.text = formatted;
        } else {
          _closeControllers[day]!.text = formatted;
        }
      });
    }
  }

  void _saveAndReturn() {
    // ✅ Cria LinkedHashMap mantendo a ordem dos dias
    final Map<String, Map<String, String>> horarios = {};

    print('💾 Salvando horários...');

    // ✅ Percorre na ordem correta
    for (var dia in _diasOrdenados) {
      final abre = _openControllers[dia]!.text.trim();
      final fecha = _closeControllers[dia]!.text.trim();

      print('💾 Dia: $dia | Abre: "$abre" | Fecha: "$fecha"');

      // Se ambos vazios -> ignorar
      if (abre.isEmpty && fecha.isEmpty) {
        print('   ⏭️ Ignorado (vazio)');
        continue;
      }

      horarios[dia] = {
        'abre': abre,
        'fecha': fecha,
      };
      print('   ✅ Adicionado aos horários');
    }

    print('💾 Horários finais para retornar: $horarios');
    Navigator.pop(context, horarios);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Horários de Funcionamento"),
        backgroundColor: yellow,
        foregroundColor: Colors.black,
        elevation: 2,
      ),
      backgroundColor: const Color(0xFFFBF8E1),
      body: Stack(
        children: [
          ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 120),
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Defina os horários de abertura e fechamento",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              // ✅ Percorre os dias na ordem correta
              for (var day in _diasOrdenados)
                Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _openControllers[day],
                          readOnly: true,
                          onTap: () => _pickTime(day, true),
                          decoration: InputDecoration(
                            labelText: "$day - Abre",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: const Icon(Icons.access_time),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _closeControllers[day],
                          readOnly: true,
                          onTap: () => _pickTime(day, false),
                          decoration: InputDecoration(
                            labelText: "$day - Fecha",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: const Icon(Icons.access_time),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              // Botão salvar
              Center(
                child: ElevatedButton(
                  onPressed: _saveAndReturn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellow,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    "Salvar Horários",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),

          // Lottie cachorro
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: SizedBox(
                height: 120,
                width: 200,
                child: Lottie.asset(
                  'lib/assets/images/Boxer.json',
                  repeat: true,
                  animate: true,
                ),
              ),
            ),
          ),

          // Faixa amarela inferior
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(height: 54, color: yellow),
          ),
        ],
      ),
    );
  }
}