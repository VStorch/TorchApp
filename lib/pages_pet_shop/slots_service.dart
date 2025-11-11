import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/time_slot.dart';

void main() {
  runApp(const SlotsService());
}

class SlotsService extends StatelessWidget {
  const SlotsService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciar Horários',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFFF4E04D),
        scaffoldBackgroundColor: const Color(0xFFFBF8E1),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFF4E04D),
          secondary: Color(0xFFF4E04D),
        ),
      ),
      home: const ServiceSelectionPage(),
    );
  }
}

// Tela de seleção de serviço
class ServiceSelectionPage extends StatefulWidget {
  const ServiceSelectionPage({Key? key}) : super(key: key);

  @override
  State<ServiceSelectionPage> createState() => _ServiceSelectionPageState();
}

class _ServiceSelectionPageState extends State<ServiceSelectionPage> {
  final TextEditingController _serviceIdController = TextEditingController(text: '1');
  final Color corFundo = const Color(0xFFFBF8E1);
  final Color corPrimaria = const Color(0xFFF4E04D);
  final Color corTexto = Colors.black87;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: corPrimaria,
        title: Text(
          'Selecionar Serviço',
          style: TextStyle(color: corTexto, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pets, size: 100, color: corPrimaria),
              const SizedBox(height: 32),
              Text(
                'ID do Serviço',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: corTexto,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                constraints: const BoxConstraints(maxWidth: 300),
                child: TextField(
                  controller: _serviceIdController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, color: corTexto),
                  decoration: InputDecoration(
                    hintText: 'Digite o ID do serviço',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: corPrimaria, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: corPrimaria, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: corPrimaria, width: 3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: corPrimaria,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                onPressed: () {
                  final serviceId = int.tryParse(_serviceIdController.text);
                  if (serviceId != null && serviceId > 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScheduleManagerPage(serviceId: serviceId),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Por favor, insira um ID válido'),
                        backgroundColor: Colors.red[700],
                      ),
                    );
                  }
                },
                child: const Text(
                  'Continuar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tela principal de gerenciamento
class ScheduleManagerPage extends StatefulWidget {
  final int serviceId;

  const ScheduleManagerPage({Key? key, required this.serviceId}) : super(key: key);

  @override
  State<ScheduleManagerPage> createState() => _ScheduleManagerPageState();
}

class _ScheduleManagerPageState extends State<ScheduleManagerPage>
    with SingleTickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  List<TimeSlot> timeSlots = [];
  bool isLoading = false;
  late AnimationController _animationController;

  final Color corFundo = const Color(0xFFFBF8E1);
  final Color corPrimaria = const Color(0xFFF4E04D);
  final Color corTexto = Colors.black87;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadSlotsForDate();
  }

  Future<void> _loadSlotsForDate() async {
    setState(() => isLoading = true);
    try {
      final slots = await ApiService.getAvailableSlots(
        serviceId: widget.serviceId,
        date: _formatDate(selectedDate),
      );
      setState(() {
        timeSlots = slots;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showErrorSnackBar('Erro ao carregar horários: $e');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _changeDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
      _animationController.forward(from: 0);
    });
    _loadSlotsForDate();
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: corPrimaria,
              onPrimary: Colors.black,
              surface: Colors.white,
              onSurface: corTexto,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
      _loadSlotsForDate();
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];
    return months[month - 1];
  }

  String _getWeekdayName(int weekday) {
    const weekdays = [
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado',
      'Domingo'
    ];
    return weekdays[weekday - 1];
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _removeTimeSlot(int slotId) async {
    try {
      await ApiService.deleteSlot(slotId);
      _loadSlotsForDate();
      HapticFeedback.lightImpact();
      _showSuccessSnackBar('Horário removido com sucesso!');
    } catch (e) {
      _showErrorSnackBar('Erro ao remover horário: $e');
    }
  }

  void _showAddTimeDialog() {
    TimeOfDay selectedTime = TimeOfDay.now();
    int duration = 30;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: corPrimaria, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: corPrimaria.withOpacity(0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: corPrimaria,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(28),
                          topRight: Radius.circular(28),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.add_alarm, color: corTexto, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Novo Horário',
                                  style: TextStyle(
                                    color: corTexto,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Selecione o horário desejado',
                                  style: TextStyle(
                                    color: corTexto.withOpacity(0.7),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: selectedTime,
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: corPrimaria,
                                        onPrimary: Colors.black,
                                        surface: Colors.white,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (time != null) {
                                setDialogState(() => selectedTime = time);
                              }
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 32, horizontal: 24),
                              decoration: BoxDecoration(
                                color: corPrimaria.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: corPrimaria, width: 2),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.access_time_rounded,
                                      color: corTexto, size: 48),
                                  const SizedBox(height: 16),
                                  Text(
                                    selectedTime.format(context),
                                    style: TextStyle(
                                      color: corTexto,
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: corPrimaria.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.touch_app,
                                            size: 14, color: corTexto),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Toque para alterar',
                                          style: TextStyle(
                                            color: corTexto,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<int>(
                            value: duration,
                            dropdownColor: Colors.white,
                            decoration: InputDecoration(
                              labelText: 'Duração',
                              labelStyle:
                              TextStyle(color: corTexto.withOpacity(0.7)),
                              prefixIcon: Icon(Icons.timer, color: corTexto),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: corPrimaria),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: corPrimaria, width: 2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: [15, 30, 45, 60, 90, 120].map((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text('$value minutos'),
                              );
                            }).toList(),
                            onChanged: (val) =>
                                setDialogState(() => duration = val!),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.grey,
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => Navigator.of(dialogContext).pop(),
                                  child: const Text(
                                    'Cancelar',
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: corPrimaria,
                                    foregroundColor: Colors.black,
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(Icons.check_circle_outline,
                                      size: 22),
                                  label: const Text(
                                    'Adicionar',
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () async {
                                    Navigator.of(dialogContext).pop();

                                    try {
                                      final startTime =
                                          '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
                                      final endMinutes = selectedTime.hour * 60 +
                                          selectedTime.minute +
                                          duration;
                                      final endHour = endMinutes ~/ 60;
                                      final endMinute = endMinutes % 60;
                                      final endTime =
                                          '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';

                                      await ApiService.createSlot(
                                        serviceId: widget.serviceId,
                                        date: _formatDate(selectedDate),
                                        startTime: startTime,
                                        endTime: endTime,
                                      );

                                      _loadSlotsForDate();
                                      _showSuccessSnackBar(
                                          'Horário $startTime adicionado!');
                                    } catch (e) {
                                      _showErrorSnackBar(
                                          'Erro ao adicionar horário: $e');
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showGenerateDialog() {
    TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay endTime = const TimeOfDay(hour: 18, minute: 0);
    int duration = 30;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: corPrimaria, width: 2),
              ),
              title: Row(
                children: [
                  Icon(Icons.auto_awesome, color: corTexto),
                  const SizedBox(width: 10),
                  Text('Gerar Horários', style: TextStyle(color: corTexto)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: corPrimaria),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text('Início',
                          style: TextStyle(color: corTexto.withOpacity(0.7))),
                      trailing: Text(
                        startTime.format(context),
                        style: TextStyle(
                            color: corTexto,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: startTime,
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: corPrimaria,
                                  onPrimary: Colors.black,
                                  surface: Colors.white,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (time != null) {
                          setDialogState(() => startTime = time);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: corPrimaria),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text('Fim',
                          style: TextStyle(color: corTexto.withOpacity(0.7))),
                      trailing: Text(
                        endTime.format(context),
                        style: TextStyle(
                            color: corTexto,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: endTime,
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: corPrimaria,
                                  onPrimary: Colors.black,
                                  surface: Colors.white,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (time != null) {
                          setDialogState(() => endTime = time);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<int>(
                    value: duration,
                    dropdownColor: Colors.white,
                    style: TextStyle(color: corTexto),
                    decoration: InputDecoration(
                      labelText: 'Duração',
                      labelStyle: TextStyle(color: corTexto.withOpacity(0.7)),
                      prefixIcon: Icon(Icons.timer, color: corTexto),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: corPrimaria),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: corPrimaria, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: [15, 30, 45, 60, 90, 120].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value minutos'),
                      );
                    }).toList(),
                    onChanged: (val) => setDialogState(() => duration = val!),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancelar',
                      style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: corPrimaria,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(dialogContext).pop();

                    try {
                      final startTimeStr =
                          '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
                      final endTimeStr =
                          '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';

                      final slots = await ApiService.createSlotsBulk(
                        serviceId: widget.serviceId,
                        date: _formatDate(selectedDate),
                        startTime: startTimeStr,
                        endTime: endTimeStr,
                        intervalMinutes: duration,
                      );

                      _loadSlotsForDate();
                      _showSuccessSnackBar('${slots.length} horários gerados!');
                    } catch (e) {
                      _showErrorSnackBar('Erro ao gerar horários: $e');
                    }
                  },
                  child: const Text('Gerar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: corPrimaria,
        elevation: 0,
        title: Text(
          'Gerenciar Horários',
          style: TextStyle(color: corTexto, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSlotsForDate,
            tooltip: 'Atualizar',
            color: corTexto,
          ),
        ],
      ),
      body: Column(
        children: [
          // Date selector
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: corPrimaria.withOpacity(0.3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, color: corTexto, size: 32),
                  onPressed: () => _changeDate(-1),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: corPrimaria, width: 2),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Text(
                          selectedDate.day.toString(),
                          style: TextStyle(
                            color: corTexto,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _getMonthName(selectedDate.month),
                          style: TextStyle(color: corTexto, fontSize: 16),
                        ),
                        Text(
                          _getWeekdayName(selectedDate.weekday),
                          style: TextStyle(
                              color: corTexto.withOpacity(0.6), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.chevron_right, color: corTexto, size: 32),
                  onPressed: () => _changeDate(1),
                ),
              ],
            ),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: corPrimaria,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Gerar',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: _showGenerateDialog,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: corTexto,
                      side: BorderSide(color: corPrimaria, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Adicionar',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: _showAddTimeDialog,
                  ),
                ),
              ],
            ),
          ),

          // Time slots grid
          Expanded(
            child: isLoading
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: corPrimaria),
                  const SizedBox(height: 16),
                  Text(
                    'Carregando horários...',
                    style: TextStyle(color: corTexto.withOpacity(0.6)),
                  ),
                ],
              ),
            )
                : timeSlots.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: corPrimaria.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.access_time,
                        size: 80, color: corTexto.withOpacity(0.5)),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Nenhum horário cadastrado',
                    style: TextStyle(
                        color: corTexto.withOpacity(0.6), fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: _showGenerateDialog,
                    icon: const Icon(Icons.auto_awesome),
                    label:
                    const Text('Gerar horários automaticamente'),
                    style: TextButton.styleFrom(
                      foregroundColor: corTexto,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: timeSlots.length,
              itemBuilder: (context, index) {
                final slot = timeSlots[index];

                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: slot.isBooked
                            ? Colors.grey[400]
                            : corPrimaria,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: corTexto.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: corPrimaria.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              slot.startTime,
                              style: TextStyle(
                                color: corTexto,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (slot.isBooked)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red[700],
                                  borderRadius:
                                  BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'RESERVADO',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (!slot.isBooked && slot.id != null)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(20),
                                    side: BorderSide(
                                        color: corPrimaria, width: 2),
                                  ),
                                  title: Text(
                                    'Remover ${slot.startTime}?',
                                    style: TextStyle(color: corTexto),
                                  ),
                                  content: Text(
                                    'Esta ação não pode ser desfeita.',
                                    style: TextStyle(
                                        color:
                                        corTexto.withOpacity(0.7)),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx),
                                      child: const Text('Cancelar',
                                          style: TextStyle(
                                              color: Colors.grey)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _removeTimeSlot(slot.id!);
                                        Navigator.pop(ctx);
                                      },
                                      child: const Text('Remover',
                                          style: TextStyle(
                                              color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red[700],
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}