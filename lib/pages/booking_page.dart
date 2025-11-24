import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/pet_shop_services/petshop_service.dart';
import '../models/appointment_service.dart';
import '../models/promotion.dart';
import '../services/promotion_service.dart';
import '../models/time_slot.dart';
import '../models/notification_service.dart';

class BookingPage extends StatefulWidget {
  final PetShopService service;
  final int petShopId;
  final String? preFilledCouponCode;

  const BookingPage({
    super.key,
    required this.service,
    required this.petShopId,
    this.preFilledCouponCode,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final Color corFundo = const Color(0xFFFBF8E1);
  final Color corPrimaria = const Color(0xFFF4E04D);
  final Color corTexto = Colors.black87;

  final TextEditingController _couponController = TextEditingController();
  final PromotionService _promotionService = PromotionService();

  DateTime selectedDate = DateTime.now();
  TimeSlot? selectedSlot;
  int? selectedPetId;
  List<TimeSlot> availableSlots = [];
  List<Map<String, dynamic>> userPets = [];
  bool isLoadingSlots = false;
  bool isLoadingPets = false;
  bool isBooking = false;
  bool isValidatingCoupon = false;
  int? userId;

  Promotion? appliedCoupon;
  bool couponApplied = false;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _loadUserPets();
    _loadSlotsForDate();

    if (widget.preFilledCouponCode != null) {
      _couponController.text = widget.preFilledCouponCode!;
      Future.delayed(const Duration(milliseconds: 500), () {
        _validateCoupon();
      });
    }
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('user_id');
    });
  }

  Future<void> _loadUserPets() async {
    setState(() => isLoadingPets = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentUserId = prefs.getInt('user_id');

      if (currentUserId == null) {
        throw Exception('Usuário não identificado');
      }

      final pets = await AppointmentService.getUserPets(currentUserId);
      setState(() {
        userPets = pets;
        isLoadingPets = false;
        if (pets.isNotEmpty) {
          selectedPetId = pets.first['id'];
        }
      });
    } catch (e) {
      setState(() => isLoadingPets = false);
      _showErrorSnackBar('Erro ao carregar pets: $e');
    }
  }

  Future<void> _loadSlotsForDate() async {
    setState(() => isLoadingSlots = true);
    try {
      final slots = await ApiService.getAvailableSlots(
        serviceId: widget.service.id!,
        date: _formatDate(selectedDate),
      );

      setState(() {
        availableSlots = slots;
        isLoadingSlots = false;
        selectedSlot = null;
      });
    } catch (e) {
      setState(() => isLoadingSlots = false);
      _showErrorSnackBar('Erro ao carregar horários: $e');
    }
  }

  Future<void> _validateCoupon() async {
    final code = _couponController.text.trim().toUpperCase();

    if (code.isEmpty) {
      setState(() {
        appliedCoupon = null;
        couponApplied = false;
      });
      return;
    }

    setState(() => isValidatingCoupon = true);

    try {
      final promotions = await _promotionService.getAllPromotions();
      final promotion = promotions.firstWhere(
            (p) => p.couponCode?.toUpperCase() == code,
        orElse: () => throw Exception('Cupom não encontrado'),
      );

      if (!promotion.isValida()) {
        throw Exception('Este cupom expirou');
      }

      setState(() {
        appliedCoupon = promotion;
        couponApplied = true;
        isValidatingCoupon = false;
      });

      _showSuccessSnackBar('Cupom "${promotion.couponCode}" aplicado! ${promotion.getDescontoFormatado()}');
    } catch (e) {
      setState(() {
        appliedCoupon = null;
        couponApplied = false;
        isValidatingCoupon = false;
      });
      _showErrorSnackBar(e.toString().replaceAll('Exception: ', ''));
    }
  }

  void _removeCoupon() {
    setState(() {
      _couponController.clear();
      appliedCoupon = null;
      couponApplied = false;
    });
    _showSuccessSnackBar('Cupom removido');
  }

  double get finalPrice {
    if (appliedCoupon != null && couponApplied) {
      return appliedCoupon!.calcularValorComDesconto(widget.service.price);
    }
    return widget.service.price;
  }

  double get discountAmount {
    if (appliedCoupon != null && couponApplied) {
      return appliedCoupon!.calcularValorDesconto(widget.service.price);
    }
    return 0;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _changeDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
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
      setState(() => selectedDate = date);
      _loadSlotsForDate();
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return months[month - 1];
  }

  String _getWeekdayName(int weekday) {
    const weekdays = [
      'Segunda-feira', 'Terça-feira', 'Quarta-feira', 'Quinta-feira',
      'Sexta-feira', 'Sábado', 'Domingo'
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _confirmBooking() async {
    if (selectedSlot == null) {
      _showErrorSnackBar('Selecione um horário');
      return;
    }
    if (selectedPetId == null) {
      _showErrorSnackBar('Selecione um pet');
      return;
    }
    if (userId == null) {
      _showErrorSnackBar('Usuário não identificado');
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: corPrimaria, width: 2),
        ),
        title: Row(
          children: [
            Icon(Icons.check_circle_outline, color: corTexto),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Confirmar Agendamento',
                style: TextStyle(color: corTexto, fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Serviço: ${widget.service.name}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Data: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
            Text('Horário: ${selectedSlot!.startTime}'),
            const Divider(height: 20),

            if (couponApplied && appliedCoupon != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Valor original:'),
                  Text(
                    'R\$ ${widget.service.price.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Desconto (${appliedCoupon!.getDescontoFormatado()}):',
                    style: TextStyle(color: Colors.green[700]),
                  ),
                  Text(
                    '- R\$ ${discountAmount.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(height: 16),
            ],

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Valor final:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  'R\$ ${finalPrice.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: corPrimaria,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => isBooking = true);

      try {
        final updatedSlots = await ApiService.getAvailableSlots(
          serviceId: widget.service.id!,
          date: _formatDate(selectedDate),
        );

        final slotStillAvailable = updatedSlots.any(
                (slot) => slot.id == selectedSlot!.id && !slot.isBooked
        );

        if (!slotStillAvailable) {
          setState(() => isBooking = false);
          _showErrorSnackBar('Este horário já foi reservado. Por favor, escolha outro horário.');
          await _loadSlotsForDate();
          return;
        }

        // Criar o agendamento
        await AppointmentService.createAppointment(
          userId: userId!,
          petId: selectedPetId!,
          petShopId: widget.petShopId,
          serviceId: widget.service.id!,
          slotId: selectedSlot!.id!,
          couponCode: couponApplied ? appliedCoupon?.couponCode : null,
          discountPercent: couponApplied ? appliedCoupon?.discountPercent : null,
          finalPrice: finalPrice,
        );

        // 🔔 NOTIFICAÇÃO: Buscar informações do pet e usuário
        final prefs = await SharedPreferences.getInstance();
        final userName = prefs.getString('user_name') ?? 'Cliente';

        final selectedPet = userPets.firstWhere(
              (pet) => pet['id'] == selectedPetId,
          orElse: () => {'name': 'Pet'},
        );
        final petName = selectedPet['name'] ?? 'Pet';

        // 🔔 ENVIAR NOTIFICAÇÃO PARA O DONO DO PET SHOP
        await NotificationService.showNewAppointmentNotification(
          clientName: userName,
          petName: petName,
          serviceName: widget.service.name,
          date: '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
          time: selectedSlot!.startTime,
        );

        setState(() {
          final index = availableSlots.indexWhere((slot) => slot.id == selectedSlot!.id);
          if (index != -1) {
            availableSlots[index] = TimeSlot(
              id: availableSlots[index].id,
              startTime: availableSlots[index].startTime,
              endTime: availableSlots[index].endTime,
              isBooked: true,
            );
          }
          selectedSlot = null;
          isBooking = false;
        });

        _showSuccessSnackBar('Agendamento realizado com sucesso!');

        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        setState(() => isBooking = false);

        final errorMessage = e.toString().toLowerCase();
        if (errorMessage.contains('duplicate') ||
            errorMessage.contains('uk8y6yin1cflvk14414e91mdcwm') ||
            errorMessage.contains('já') && errorMessage.contains('reservado')) {
          _showErrorSnackBar('Este horário já foi reservado. Recarregando horários disponíveis...');
          await _loadSlotsForDate();
        } else {
          _showErrorSnackBar('Erro ao agendar: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        backgroundColor: corPrimaria,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Agendar Serviço',
          style: TextStyle(color: corTexto, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isBooking
          ? Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: corPrimaria),
              const SizedBox(height: 16),
              Text(
                'Realizando agendamento...',
                style: TextStyle(color: corTexto, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: corPrimaria,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(Icons.pets, size: 50, color: corTexto),
                  const SizedBox(height: 10),
                  Text(
                    widget.service.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: corTexto,
                    ),
                  ),
                  const SizedBox(height: 5),

                  if (couponApplied && appliedCoupon != null) ...[
                    Text(
                      widget.service.formattedPrice,
                      style: TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green[700]!, width: 2),
                      ),
                      child: Text(
                        appliedCoupon!.getDescontoFormatado(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'R\$ ${finalPrice.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ] else
                    Text(
                      widget.service.formattedPrice,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cupom de Desconto (Opcional)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: corTexto,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _couponController,
                          enabled: !couponApplied,
                          textCapitalization: TextCapitalization.characters,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                            LengthLimitingTextInputFormatter(20),
                          ],
                          decoration: InputDecoration(
                            hintText: 'Digite o código do cupom',
                            prefixIcon: Icon(
                              couponApplied ? Icons.check_circle : Icons.confirmation_number,
                              color: couponApplied ? Colors.green[700] : Colors.grey,
                            ),
                            suffixIcon: couponApplied
                                ? IconButton(
                              icon: Icon(Icons.close, color: Colors.red[700]),
                              onPressed: _removeCoupon,
                            )
                                : null,
                            filled: true,
                            fillColor: couponApplied ? Colors.green[50] : Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: couponApplied ? Colors.green[700]! : corPrimaria,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: couponApplied ? Colors.green[700]! : corPrimaria,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: corPrimaria, width: 2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (!couponApplied)
                        ElevatedButton(
                          onPressed: isValidatingCoupon ? null : _validateCoupon,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: corPrimaria,
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Colors.black, width: 2),
                            ),
                          ),
                          child: isValidatingCoupon
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black87,
                            ),
                          )
                              : const Text(
                            'Aplicar',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selecione o Pet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: corTexto,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (isLoadingPets)
                    const Center(child: CircularProgressIndicator())
                  else if (userPets.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange, width: 2),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Colors.orange[800]),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Você precisa cadastrar um pet antes de agendar',
                              style: TextStyle(color: Colors.orange[900]),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: corPrimaria, width: 2),
                      ),
                      child: DropdownButtonFormField<int>(
                        value: selectedPetId,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: InputBorder.none,
                        ),
                        dropdownColor: Colors.white,
                        items: userPets.map((pet) {
                          return DropdownMenuItem<int>(
                            value: pet['id'],
                            child: Row(
                              children: [
                                Icon(Icons.pets, color: corPrimaria, size: 20),
                                const SizedBox(width: 10),
                                Text(pet['name'] ?? 'Pet sem nome'),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => selectedPetId = value);
                        },
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

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
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                              color: corTexto.withOpacity(0.6),
                              fontSize: 14,
                            ),
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

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Horários Disponíveis',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: corTexto,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (isLoadingSlots)
                    const Center(child: CircularProgressIndicator())
                  else if (availableSlots.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.event_busy, size: 50, color: Colors.grey[600]),
                            const SizedBox(height: 10),
                            Text(
                              'Nenhum horário disponível para esta data',
                              style: TextStyle(color: Colors.grey[700]),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (availableSlots.every((slot) => slot.isBooked))
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red[300]!, width: 2),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.event_busy, size: 50, color: Colors.red[700]),
                              const SizedBox(height: 10),
                              Text(
                                'Todos os horários desta data já foram reservados',
                                style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 1.2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: availableSlots.length,
                        itemBuilder: (context, index) {
                          final slot = availableSlots[index];
                          final isSelected = selectedSlot?.id == slot.id;
                          final isBooked = slot.isBooked;

                          return GestureDetector(
                            onTap: isBooked ? null : () {
                              setState(() => selectedSlot = slot);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isBooked
                                    ? Colors.red[100]
                                    : isSelected
                                    ? corPrimaria
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isBooked
                                      ? Colors.red[700]!
                                      : isSelected
                                      ? Colors.black
                                      : corTexto.withOpacity(0.3),
                                  width: isSelected ? 3 : 2,
                                ),
                                boxShadow: isSelected
                                    ? [
                                  BoxShadow(
                                    color: corPrimaria.withOpacity(0.5),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                                    : null,
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      slot.startTime,
                                      style: TextStyle(
                                        color: isBooked
                                            ? Colors.red[700]
                                            : corTexto,
                                        fontSize: 16,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        decoration: isBooked ? TextDecoration.lineThrough : null,
                                      ),
                                    ),
                                    if (isBooked)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(
                                          'Reservado',
                                          style: TextStyle(
                                            color: Colors.red[700],
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: corPrimaria,
                    foregroundColor: corTexto,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  icon: const Icon(Icons.check_circle, size: 28),
                  label: const Text(
                    'Confirmar Agendamento',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: (selectedSlot != null && selectedPetId != null && userPets.isNotEmpty)
                      ? _confirmBooking
                      : null,
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }
}