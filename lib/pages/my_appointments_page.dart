import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/custom_drawer.dart';
import '../data/pet_shop/pet_shop_information_service.dart';
import '../models/appointment_service.dart';
import '../models/page_type.dart';
import '../models/menu_item.dart';

class MyAppointmentsPage extends StatefulWidget {
  const MyAppointmentsPage({super.key});

  @override
  State<MyAppointmentsPage> createState() => _MyAppointmentsPageState();
}

class _MyAppointmentsPageState extends State<MyAppointmentsPage> {
  final Color yellow = const Color(0xFFF4E04D);
  final Color bgColor = const Color(0xFFFBF8E1);

  List<Map<String, dynamic>> appointments = [];
  bool isLoading = true;
  int? userId;

  final PetShopInformationService _petShopService = PetShopInformationService();

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');
    if (userId != null) {
      _loadAppointments();
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadAppointments() async {
    setState(() => isLoading = true);
    try {
      final data = await AppointmentService.getUserAppointments(userId!);

      // Filtra apenas agendamentos pendentes e concluídos (remove cancelados)
      final filteredData = data.where((apt) {
        final status = apt['status']?.toString().toUpperCase() ?? '';
        return status != 'CANCELLED';
      }).toList();

      filteredData.sort((a, b) {
        final dateA = DateTime.parse(a['date']);
        final dateB = DateTime.parse(b['date']);
        return dateB.compareTo(dateA);
      });
      setState(() {
        appointments = filteredData;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showSnackBar('Erro ao carregar agendamentos', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red[600] : Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showDetailsDialog(Map<String, dynamic> apt) {
    showDialog(
      context: context,
      builder: (ctx) => _PetShopDetailsDialog(
        appointment: apt,
        petShopService: _petShopService,
        bgColor: bgColor,
        yellow: yellow,
      ),
    );
  }

  Future<void> _cancelAppointment(int appointmentId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: Colors.orange[700], size: 28),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Cancelar Agendamento', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
        content: const Text(
          'Tem certeza que deseja cancelar este agendamento?',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Não', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sim, Cancelar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await AppointmentService.cancelAppointment(appointmentId);
        _showSnackBar('Agendamento cancelado!');
        _loadAppointments();
      } catch (e) {
        _showSnackBar('Erro ao cancelar', isError: true);
      }
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      const months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
      return '${date.day} ${months[date.month - 1]}';
    } catch (e) {
      return dateStr;
    }
  }

  String _getWeekDay(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      const days = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
      return days[date.weekday % 7];
    } catch (e) {
      return '';
    }
  }

  String _getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Agendado';
      case 'COMPLETED':
        return 'Concluído';
      case 'CANCELLED':
        return 'Cancelado';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return yellow;
      case 'COMPLETED':
        return Colors.green[500]!;
      case 'CANCELLED':
        return Colors.red[400]!;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final menuItems = PageType.values.map((type) => MenuItem.fromType(type)).toList();

    return Scaffold(
      backgroundColor: bgColor,
      drawer: CustomDrawer(menuItems: menuItems),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.08),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          decoration: BoxDecoration(
            color: yellow,
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
                      icon: Icon(Icons.pets, size: screenHeight * 0.04, color: Colors.black),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Meus Agendamentos",
                    style: TextStyle(
                      fontSize: (screenWidth * 0.06).clamp(18.0, 28.0),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Positioned(
                  right: -10,
                  top: -6,
                  bottom: 0,
                  child: IconButton(
                    icon: Icon(Icons.refresh, size: screenHeight * 0.035, color: Colors.black),
                    onPressed: _loadAppointments,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadAppointments,
        child: appointments.isEmpty
            ? _buildEmptyState(screenHeight)
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            return _buildAppointmentCard(appointments[index], screenHeight);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(double screenHeight) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: yellow.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.event_busy, size: 80, color: Colors.black38),
          ),
          SizedBox(height: screenHeight * 0.03),
          const Text(
            "Nenhum agendamento",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Text(
            "Seus agendamentos aparecerão aqui",
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> apt, double screenHeight) {
    final status = apt['status'] ?? 'PENDING';
    final isPending = status.toUpperCase() == 'PENDING';
    final statusColor = _getStatusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.pets, size: 24, color: Colors.black87),
                const SizedBox(width: 8),
                Text(
                  _getStatusText(status),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Data e Hora
                Row(
                  children: [
                    // Data
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _getWeekDay(apt['date'] ?? ''),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatDate(apt['date'] ?? ''),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Hora
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.black, width: 1.5),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.access_time, color: Colors.white, size: 20),
                          const SizedBox(height: 4),
                          Text(
                            apt['time'] ?? '--:--',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Serviço
                _buildInfoTile(
                  icon: Icons.spa_rounded,
                  label: 'Serviço',
                  value: apt['serviceName'] ?? 'Não informado',
                  color: yellow,
                ),

                const SizedBox(height: 10),

                // Pet
                _buildInfoTile(
                  icon: Icons.pets_rounded,
                  label: 'Pet',
                  value: apt['petName'] ?? 'Não informado',
                  color: Colors.brown[400]!,
                ),

                const SizedBox(height: 16),

                // Botões
                Row(
                  children: [
                    // Botão Ver Detalhes
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showDetailsDialog(apt),
                        icon: const Icon(Icons.info_outline, size: 18),
                        label: const Text(
                          'Ver Detalhes',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black87,
                          side: const BorderSide(color: Colors.black, width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    // Botão Cancelar (se pending)
                    if (isPending) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _cancelAppointment(apt['id']),
                          icon: const Icon(Icons.close_rounded, size: 18),
                          label: const Text(
                            'Cancelar',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[50],
                            foregroundColor: Colors.red[700],
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(color: Colors.red[300]!, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: Colors.black87),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Dialog separado para buscar e mostrar detalhes do pet shop
class _PetShopDetailsDialog extends StatefulWidget {
  final Map<String, dynamic> appointment;
  final PetShopInformationService petShopService;
  final Color bgColor;
  final Color yellow;

  const _PetShopDetailsDialog({
    required this.appointment,
    required this.petShopService,
    required this.bgColor,
    required this.yellow,
  });

  @override
  State<_PetShopDetailsDialog> createState() => _PetShopDetailsDialogState();
}

class _PetShopDetailsDialogState extends State<_PetShopDetailsDialog> {
  bool isLoading = true;
  Map<String, dynamic>? petShopData;
  String? cep, estado, cidade, bairro, endereco, numero, complemento;

  @override
  void initState() {
    super.initState();
    _loadPetShopData();
    _loadAddressFromPrefs();
  }

  Future<void> _loadAddressFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cep = prefs.getString('petshop_cep');
      estado = prefs.getString('petshop_state');
      cidade = prefs.getString('petshop_city');
      bairro = prefs.getString('petshop_neighborhood');
      endereco = prefs.getString('petshop_street');
      numero = prefs.getString('petshop_number');
      complemento = prefs.getString('petshop_complement');
    });
  }

  Future<void> _loadPetShopData() async {
    try {
      final petShopId = widget.appointment['petShopId'];
      if (petShopId == null) {
        setState(() => isLoading = false);
        return;
      }

      final response = await widget.petShopService.getPetShopInformationById(petShopId);

      Map<String, dynamic>? data;
      if (response is Map<String, dynamic>) {
        if (response.containsKey('data') && response['data'] != null) {
          data = response['data'] as Map<String, dynamic>;
        } else {
          data = response;
        }
      }

      if (mounted) {
        setState(() {
          petShopData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  bool _temValor(dynamic v) => v != null && v.toString().trim().isNotEmpty;

  bool _temContato() {
    if (petShopData == null) return false;
    return _temValor(petShopData!['commercialPhone']) ||
        _temValor(petShopData!['whatsapp']) ||
        _temValor(petShopData!['commercialEmail']);
  }

  bool _temRedes() {
    if (petShopData == null) return false;
    return _temValor(petShopData!['instagram']) ||
        _temValor(petShopData!['facebook']) ||
        _temValor(petShopData!['website']);
  }

  bool _temLocalizacao() {
    return (endereco != null && endereco!.trim().isNotEmpty) ||
        (cidade != null && cidade!.trim().isNotEmpty) ||
        (cep != null && cep!.trim().isNotEmpty);
  }

  String _getEnderecoCompleto() {
    List<String> partes = [];

    if (endereco != null && endereco!.trim().isNotEmpty) {
      String enderecoLinha = endereco!;
      if (numero != null && numero!.trim().isNotEmpty) {
        enderecoLinha += ', $numero';
      }
      if (complemento != null && complemento!.trim().isNotEmpty) {
        enderecoLinha += ' - $complemento';
      }
      partes.add(enderecoLinha);
    }

    if (bairro != null && bairro!.trim().isNotEmpty) {
      partes.add(bairro!);
    }

    if (cidade != null && cidade!.trim().isNotEmpty) {
      String cidadeEstado = cidade!;
      if (estado != null && estado!.trim().isNotEmpty) {
        cidadeEstado += ' - $estado';
      }
      partes.add(cidadeEstado);
    }

    if (cep != null && cep!.trim().isNotEmpty) {
      partes.add('CEP: $cep');
    }

    return partes.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.yellow,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.store, size: 28, color: Colors.black87),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Detalhes do Pet Shop',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Conteúdo
            Expanded(
              child: isLoading
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: widget.yellow),
                    const SizedBox(height: 16),
                    Text(
                      'Carregando informações...',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
                  : petShopData == null
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          size: 60, color: Colors.orange[400]),
                      const SizedBox(height: 16),
                      const Text(
                        'Informações não disponíveis',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nome do Pet Shop
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: widget.yellow.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: widget.yellow, width: 2),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.store,
                              size: 40, color: Colors.black87),
                          const SizedBox(height: 8),
                          Text(
                            petShopData!['name']?.toString() ??
                                'Pet Shop',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (_temValor(petShopData!['description']))
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                petShopData!['description'].toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color:
                                  Colors.black87.withOpacity(0.7),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Contato
                    if (_temContato()) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'Contato',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_temValor(petShopData!['commercialPhone']))
                        _buildInfo(
                          Icons.phone,
                          'Telefone',
                          petShopData!['commercialPhone'].toString(),
                          Colors.blue[400]!,
                        ),
                      if (_temValor(petShopData!['whatsapp']))
                        _buildInfo(
                          Icons.chat,
                          'WhatsApp',
                          petShopData!['whatsapp'].toString(),
                          Colors.green[500]!,
                        ),
                      if (_temValor(petShopData!['commercialEmail']))
                        _buildInfo(
                          Icons.email,
                          'E-mail',
                          petShopData!['commercialEmail'].toString(),
                          Colors.purple[400]!,
                        ),
                    ],

                    // Redes Sociais
                    if (_temRedes()) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'Redes Sociais',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_temValor(petShopData!['instagram']))
                        _buildInfo(
                          Icons.camera_alt,
                          'Instagram',
                          petShopData!['instagram'].toString(),
                          Colors.pink[400]!,
                        ),
                      if (_temValor(petShopData!['facebook']))
                        _buildInfo(
                          Icons.facebook,
                          'Facebook',
                          petShopData!['facebook'].toString(),
                          Colors.blue[600]!,
                        ),
                      if (_temValor(petShopData!['website']))
                        _buildInfo(
                          Icons.language,
                          'Site',
                          petShopData!['website'].toString(),
                          Colors.orange[400]!,
                        ),
                    ],

                    // Localização
                    if (_temLocalizacao()) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'Localização',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfo(
                        Icons.location_on,
                        'Endereço',
                        _getEnderecoCompleto(),
                        Colors.red[400]!,
                      ),
                    ],

                    const SizedBox(height: 20),

                    // Botão Fechar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.yellow,
                          foregroundColor: Colors.black87,
                          padding:
                          const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                                color: Colors.black, width: 2),
                          ),
                        ),
                        child: const Text(
                          'Fechar',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
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

  Widget _buildInfo(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}