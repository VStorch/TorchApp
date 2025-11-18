import 'package:flutter/material.dart';
import '../models/appointment_service.dart';
import '../components/custom_drawer_pet_shop.dart';

class PetShopAppointmentsPage extends StatefulWidget {
  final int petShopId;
  final int userId;

  const PetShopAppointmentsPage({
    super.key,
    required this.petShopId,
    required this.userId,
  });

  @override
  State<PetShopAppointmentsPage> createState() => _PetShopAppointmentsPageState();
}

class _PetShopAppointmentsPageState extends State<PetShopAppointmentsPage> {
  final Color corFundo = const Color(0xFFFBF8E1);
  final Color corPrimaria = const Color(0xFFF4E04D);
  final Color corTexto = Colors.black87;

  List<Map<String, dynamic>> appointments = [];
  bool isLoading = false;
  String filterStatus = 'Todos';

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    setState(() => isLoading = true);

    try {
      final allAppointments = await AppointmentService.getAllAppointments();

      final filteredAppointments = allAppointments.where((appointment) {
        return appointment['petShopId'] == widget.petShopId;
      }).toList();

      filteredAppointments.sort((a, b) {
        try {
          final dateA = DateTime.parse(a['date']);
          final dateB = DateTime.parse(b['date']);
          return dateB.compareTo(dateA);
        } catch (e) {
          return 0;
        }
      });

      setState(() {
        appointments = filteredAppointments;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showErrorSnackBar('Erro ao carregar agendamentos: $e');
    }
  }

  List<Map<String, dynamic>> get filteredAppointments {
    if (filterStatus == 'Todos') return appointments;

    String statusBackend = '';
    switch (filterStatus) {
      case 'Pendente':
        statusBackend = 'PENDING';
        break;
      case 'Confirmado':
        statusBackend = 'CONFIRMED';
        break;
      case 'Cancelado':
        statusBackend = 'CANCELLED';
        break;
      case 'Concluído':
        statusBackend = 'COMPLETED';
        break;
    }

    return appointments.where((appointment) {
      final status = appointment['status']?.toString().toUpperCase() ?? '';
      return status == statusBackend;
    }).toList();
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'Data não informada';
    try {
      final date = DateTime.parse(dateStr);
      const months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  String _formatPrice(dynamic price) {
    if (price == null) return 'N/A';
    try {
      if (price is String) {
        final numPrice = double.tryParse(price);
        if (numPrice != null) {
          return 'R\$ ${numPrice.toStringAsFixed(2).replaceAll('.', ',')}';
        }
      } else if (price is num) {
        return 'R\$ ${price.toStringAsFixed(2).replaceAll('.', ',')}';
      }
    } catch (e) {
      return 'N/A';
    }
    return 'N/A';
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'CONFIRMED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      case 'COMPLETED':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    if (status == null) return Icons.help_outline;
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Icons.schedule;
      case 'CONFIRMED':
        return Icons.check_circle;
      case 'CANCELLED':
        return Icons.cancel;
      case 'COMPLETED':
        return Icons.done_all;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusText(String? status) {
    if (status == null) return 'Desconhecido';
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Pendente';
      case 'CONFIRMED':
        return 'Confirmado';
      case 'CANCELLED':
        return 'Cancelado';
      case 'COMPLETED':
        return 'Concluído';
      default:
        return status;
    }
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
      ),
    );
  }

  Future<void> _showAppointmentDetails(Map<String, dynamic> appointment) async {
    // Calcular valores com desconto
    final originalPrice = appointment['servicePrice'];
    final discountPercent = appointment['discountPercent'];
    final finalPrice = appointment['finalPrice'];
    final couponCode = appointment['couponCode'];

    final bool hasDiscount = discountPercent != null && discountPercent > 0;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          border: Border.all(color: corPrimaria, width: 3),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: corPrimaria,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.event_note, size: 30, color: corTexto),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Detalhes do Agendamento',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: corTexto,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: _getStatusColor(appointment['status']).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getStatusColor(appointment['status']),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getStatusIcon(appointment['status']),
                              color: _getStatusColor(appointment['status']),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _getStatusText(appointment['status']),
                              style: TextStyle(
                                color: _getStatusColor(appointment['status']),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    _buildSectionTitle('Cliente'),
                    _buildInfoCard([
                      _buildInfoRow(Icons.person, 'Nome', appointment['userName'] ?? 'N/A'),
                      _buildInfoRow(Icons.pets, 'Pet', appointment['petName'] ?? 'N/A'),
                    ]),
                    const SizedBox(height: 16),

                    _buildSectionTitle('Serviço'),
                    _buildInfoCard([
                      _buildInfoRow(Icons.medical_services, 'Serviço', appointment['serviceName'] ?? 'N/A'),

                      // Mostrar informações de preço e desconto
                      if (hasDiscount && couponCode != null) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green[300]!, width: 2),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.confirmation_number, color: Colors.green[700], size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Cupom aplicado: $couponCode',
                                        style: TextStyle(
                                          color: Colors.green[900],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Valor original:',
                                      style: TextStyle(color: Colors.grey[700], fontSize: 13),
                                    ),
                                    Text(
                                      _formatPrice(originalPrice),
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 13,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Desconto (${discountPercent.toStringAsFixed(0)}%):',
                                      style: TextStyle(color: Colors.green[700], fontSize: 13),
                                    ),
                                    Text(
                                      '- ${_formatPrice((originalPrice ?? 0) - (finalPrice ?? originalPrice ?? 0))}',
                                      style: TextStyle(
                                        color: Colors.green[700],
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Valor final:',
                                      style: TextStyle(
                                        color: Colors.green[900],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      _formatPrice(finalPrice ?? originalPrice),
                                      style: TextStyle(
                                        color: Colors.green[900],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ] else
                        _buildInfoRow(Icons.attach_money, 'Valor', _formatPrice(originalPrice)),
                    ]),
                    const SizedBox(height: 16),

                    _buildSectionTitle('Data e Horário'),
                    _buildInfoCard([
                      _buildInfoRow(Icons.calendar_today, 'Data', _formatDate(appointment['date'])),
                      _buildInfoRow(Icons.access_time, 'Horário',
                          '${appointment['slotStartTime'] ?? '-'} - ${appointment['slotEndTime'] ?? '-'}'),
                    ]),
                    const SizedBox(height: 24),

                    if (appointment['status']?.toString().toUpperCase() == 'PENDING')
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.check),
                              label: const Text('Confirmar Agendamento', style: TextStyle(fontSize: 16)),
                              onPressed: () {
                                Navigator.pop(context);
                                _confirmAppointment(appointment);
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.cancel),
                              label: const Text('Cancelar Agendamento', style: TextStyle(fontSize: 16)),
                              onPressed: () {
                                Navigator.pop(context);
                                _cancelAppointment(appointment);
                              },
                            ),
                          ),
                        ],
                      )
                    else if (appointment['status']?.toString().toUpperCase() == 'CONFIRMED')
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.done_all),
                          label: const Text('Marcar como Concluído', style: TextStyle(fontSize: 16)),
                          onPressed: () {
                            Navigator.pop(context);
                            _completeAppointment(appointment);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: corTexto,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: corFundo,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: corPrimaria, width: 2),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: corTexto.withOpacity(0.7)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: corTexto.withOpacity(0.6))),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: corTexto)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAppointment(Map<String, dynamic> appointment) async {
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
            Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            const Expanded(child: Text('Confirmar Agendamento')),
          ],
        ),
        content: const Text('Deseja confirmar este agendamento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await AppointmentService.confirmAppointment(appointment['id']);
        _showSuccessSnackBar('Agendamento confirmado com sucesso!');
        await _loadAppointments();
      } catch (e) {
        _showErrorSnackBar('Erro ao confirmar: $e');
      }
    }
  }

  Future<void> _completeAppointment(Map<String, dynamic> appointment) async {
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
            Icon(Icons.done_all, color: Colors.blue),
            const SizedBox(width: 8),
            const Expanded(child: Text('Concluir Agendamento')),
          ],
        ),
        content: const Text('Deseja marcar este agendamento como concluído?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Concluir'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await AppointmentService.completeAppointment(appointment['id']);
        _showSuccessSnackBar('Agendamento concluído!');
        await _loadAppointments();
      } catch (e) {
        _showErrorSnackBar('Erro ao concluir: $e');
      }
    }
  }

  Future<void> _cancelAppointment(Map<String, dynamic> appointment) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.red, width: 2),
        ),
        title: Row(
          children: [
            Icon(Icons.cancel, color: Colors.red),
            const SizedBox(width: 8),
            const Expanded(child: Text('Cancelar Agendamento')),
          ],
        ),
        content: const Text('Deseja realmente cancelar este agendamento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Não'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sim, Cancelar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await AppointmentService.cancelAppointment(appointment['id']);
        _showSuccessSnackBar('Agendamento cancelado com sucesso!');
        await _loadAppointments();
      } catch (e) {
        _showErrorSnackBar('Erro ao cancelar: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final barHeight = screenHeight * 0.05;

    return Scaffold(
      backgroundColor: corFundo,
      drawer: CustomDrawerPetShop(
        petShopId: widget.petShopId,
        userId: widget.userId,
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(barHeight),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          decoration: BoxDecoration(
            color: corPrimaria,
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  left: -10,
                  top: -6,
                  bottom: 0,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.pets, size: barHeight * 0.8, color: Colors.black),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Agendamentos",
                    style: TextStyle(
                      fontSize: barHeight * 0.6,
                      fontWeight: FontWeight.bold,
                      color: corTexto,
                    ),
                  ),
                ),
                Positioned(
                  right: -10,
                  top: -6,
                  bottom: 0,
                  child: IconButton(
                    icon: Icon(Icons.refresh, size: barHeight * 0.7, color: Colors.black87),
                    onPressed: _loadAppointments,
                    tooltip: 'Atualizar',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Todos'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Pendente'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Confirmado'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Cancelado'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Concluído'),
                ],
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator(color: corPrimaria))
                : filteredAppointments.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum agendamento encontrado',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    filterStatus == 'Todos'
                        ? 'Você ainda não possui agendamentos'
                        : 'Nenhum agendamento com status "$filterStatus"',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            )
                : RefreshIndicator(
              onRefresh: _loadAppointments,
              color: corPrimaria,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredAppointments.length,
                itemBuilder: (context, index) {
                  return _buildAppointmentCard(filteredAppointments[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = filterStatus == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => filterStatus = label);
      },
      selectedColor: corPrimaria,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected ? corTexto : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? corTexto : Colors.transparent,
        width: 2,
      ),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    final status = appointment['status'] ?? 'PENDING';
    final statusColor = _getStatusColor(status);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: statusColor, width: 2),
      ),
      elevation: 3,
      child: InkWell(
        onTap: () => _showAppointmentDetails(appointment),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(_getStatusIcon(status), color: statusColor, size: 24),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _getStatusText(status),
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: corPrimaria,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '#${appointment['id']}',
                      style: TextStyle(
                        color: corTexto,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Icon(Icons.person, color: corTexto.withOpacity(0.6), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      appointment['userName'] ?? 'Cliente não identificado',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: corTexto,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.pets, color: corTexto.withOpacity(0.6), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    appointment['petName'] ?? 'Pet não identificado',
                    style: TextStyle(color: corTexto, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.medical_services, color: corTexto.withOpacity(0.6), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      appointment['serviceName'] ?? 'Serviço não identificado',
                      style: TextStyle(color: corTexto, fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: corFundo,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: corPrimaria.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 18, color: corTexto.withOpacity(0.6)),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(appointment['date']),
                            style: TextStyle(
                              color: corTexto,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: corPrimaria,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: corTexto),
                          const SizedBox(width: 4),
                          Text(
                            appointment['slotStartTime'] ?? '-',
                            style: TextStyle(
                              color: corTexto,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}