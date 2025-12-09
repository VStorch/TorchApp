import 'package:flutter/material.dart';

class ServiceTimes extends StatefulWidget {
  final int petShopId;
  final int userId;
  final String serviceName;

  const ServiceTimes({
    super.key,
    this.petShopId = 0,
    this.userId = 0,
    this.serviceName = 'Serviço',
  });

  @override
  State<ServiceTimes> createState() => _ServiceTimesState();
}

class _ServiceTimesState extends State<ServiceTimes> {
  final Color corFundo = const Color(0xFFFBF8E1);
  final Color corPrimaria = const Color(0xFFF4E04D);
  final Color corTexto = Colors.black87;

  DateTime _dataSelecionada = DateTime.now();
  String? _horarioSelecionado;

  final List<String> _horariosDisponiveis = [
    '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
    '13:00', '13:30', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30',
    '17:00', '17:30', '18:00', '18:30', '19:00', '19:30',
  ];

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      locale: const Locale('pt', 'BR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: corPrimaria,
              onPrimary: corTexto,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _dataSelecionada) {
      setState(() {
        _dataSelecionada = picked;
        _horarioSelecionado = null;
      });
    }
  }

  void _confirmarAgendamento() {
    if (_horarioSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor, selecione um horário'),
          backgroundColor: Colors.red[700],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: corPrimaria,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 48,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Agendamento Confirmado!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: corTexto,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Seu horário foi reservado com sucesso',
                style: TextStyle(
                  fontSize: 14,
                  color: corTexto.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: corFundo,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    _buildDetalheRow(Icons.build, 'Serviço', widget.serviceName),
                    const SizedBox(height: 12),
                    _buildDetalheRow(
                      Icons.calendar_today,
                      'Data',
                      '${_dataSelecionada.day.toString().padLeft(2, '0')}/${_dataSelecionada.month.toString().padLeft(2, '0')}/${_dataSelecionada.year}',
                    ),
                    const SizedBox(height: 12),
                    _buildDetalheRow(Icons.access_time, 'Horário', _horarioSelecionado!),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: corPrimaria,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.black, width: 2),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Entendi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: corTexto,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetalheRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: corTexto.withOpacity(0.6), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: corTexto.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: corTexto,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final barHeight = screenHeight * 0.05;

    return Scaffold(
      backgroundColor: corFundo,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(barHeight),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          decoration: BoxDecoration(
            color: corPrimaria,
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: SafeArea(
            child: Center(
              child: Text(
                "Agendamento",
                style: TextStyle(
                  fontSize: barHeight * 0.6,
                  fontWeight: FontWeight.bold,
                  color: corTexto,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card do serviço
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Row(
                  children: [
                    Icon(Icons.spa, color: Colors.black, size: screenHeight * 0.04),
                    SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      child: Text(
                        widget.serviceName,
                        style: TextStyle(
                          fontSize: screenHeight * 0.024,
                          fontWeight: FontWeight.bold,
                          color: corTexto,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Seletor de data
            GestureDetector(
              onTap: () => _selecionarData(context),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.black, size: screenHeight * 0.04),
                      SizedBox(width: screenWidth * 0.03),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Data',
                              style: TextStyle(
                                fontSize: screenHeight * 0.018,
                                color: corTexto.withOpacity(0.6),
                              ),
                            ),
                            Text(
                              '${_dataSelecionada.day}/${_dataSelecionada.month}/${_dataSelecionada.year}',
                              style: TextStyle(
                                fontSize: screenHeight * 0.022,
                                fontWeight: FontWeight.bold,
                                color: corTexto,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: corTexto.withOpacity(0.3), size: screenHeight * 0.02),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            // Título
            Text(
              'Escolha o horário:',
              style: TextStyle(
                fontSize: screenHeight * 0.024,
                fontWeight: FontWeight.bold,
                color: corTexto,
              ),
            ),
            SizedBox(height: screenHeight * 0.015),

            // Lista VERTICAL de horários - LIMPO E SIMPLES
            Expanded(
              child: ListView.builder(
                itemCount: _horariosDisponiveis.length,
                itemBuilder: (context, index) {
                  final horario = _horariosDisponiveis[index];
                  final isSelected = _horarioSelecionado == horario;

                  return Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.012),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _horarioSelecionado = horario;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                          horizontal: screenWidth * 0.04,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? corPrimaria : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Colors.black : Colors.black.withOpacity(0.1),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.black,
                              size: screenHeight * 0.028,
                            ),
                            SizedBox(width: screenWidth * 0.04),
                            Text(
                              horario,
                              style: TextStyle(
                                fontSize: screenHeight * 0.022,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                color: corTexto,
                              ),
                            ),
                            const Spacer(),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: Colors.black,
                                size: screenHeight * 0.028,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Botão confirmar
            SizedBox(
              width: double.infinity,
              height: screenHeight * 0.06,
              child: ElevatedButton(
                onPressed: _confirmarAgendamento,
                style: ElevatedButton.styleFrom(
                  backgroundColor: corPrimaria,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.black, width: 2),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  'Confirmar Agendamento',
                  style: TextStyle(
                    fontSize: screenHeight * 0.024,
                    fontWeight: FontWeight.bold,
                    color: corTexto,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}