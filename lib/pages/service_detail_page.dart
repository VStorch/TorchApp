import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/pet_shop_services/petshop_service.dart';
import '../data/pet_shop/pet_shop_information_service.dart';
import 'booking_page.dart';

class ServiceDetailPage extends StatefulWidget {
  final PetShopService service;

  const ServiceDetailPage({super.key, required this.service});

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  final Color corFundo = const Color(0xFFFBF8E1);
  final Color corPrimaria = const Color(0xFFF4E04D);
  final Color corTexto = Colors.black87;

  final PetShopInformationService _service = PetShopInformationService();

  Map<String, dynamic>? petShopData;
  bool isLoading = true;
  String? errorMessage;

  // Dados de localização do SharedPreferences
  String? cep;
  String? estado;
  String? cidade;
  String? bairro;
  String? endereco;
  String? numero;
  String? complemento;

  @override
  void initState() {
    super.initState();
    print('🟢 ServiceDetailPage - Serviço ID: ${widget.service.id}');
    print('🟢 ServiceDetailPage - Pet Shop ID: ${widget.service.petShopId}');
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

    print('📍 Endereço carregado: $endereco, $numero - $cidade/$estado');
  }

  Future<void> _loadPetShopData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      print('🔵 Buscando dados do Pet Shop ID: ${widget.service.petShopId}');

      // Busca informações do petshop pelo ID
      final response = await _service.getPetShopInformationById(widget.service.petShopId);

      print('✅ Dados recebidos: $response');

      // CORREÇÃO: Pegar os dados de dentro do objeto 'data'
      Map<String, dynamic>? data;

      if (response is Map<String, dynamic>) {
        // Se tem 'data' dentro, pega de lá
        if (response.containsKey('data') && response['data'] != null) {
          data = response['data'] as Map<String, dynamic>;
          print('📦 Dados extraídos de response[data]: $data');
        } else {
          // Se não, usa o response direto
          data = response;
          print('📦 Usando response direto: $data');
        }
      }

      if (mounted) {
        setState(() {
          petShopData = data;
          isLoading = false;
        });

        print('✅ Estado atualizado - petShopData: $petShopData');
      }
    } catch (e) {
      print('🔴 ERRO ao carregar dados do pet shop: $e');
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
          'Detalhes do Serviço',
          style: TextStyle(
            color: corTexto,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            color: Colors.black,
            height: 2.0,
          ),
        ),
      ),
      body: isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: corPrimaria),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Carregando informações...',
              style: TextStyle(
                color: corTexto.withOpacity(0.6),
                fontSize: screenHeight * 0.018,
              ),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(screenWidth * 0.06),
              decoration: BoxDecoration(
                color: corPrimaria,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
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
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.pets,
                      size: screenHeight * 0.08,
                      color: corPrimaria,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    widget.service.name,
                    style: TextStyle(
                      fontSize: screenHeight * 0.032,
                      fontWeight: FontWeight.bold,
                      color: corTexto,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: corTexto, width: 2),
                    ),
                    child: Text(
                      widget.service.formattedPrice,
                      style: TextStyle(
                        fontSize: screenHeight * 0.028,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.03),

            // Conteúdo
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Oferecido por',
                    style: TextStyle(
                      fontSize: screenHeight * 0.018,
                      color: corTexto.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),

                  if (petShopData != null) ...[
                    // Card do Pet Shop
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: corPrimaria.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Logo e Nome
                          Row(
                            children: [
                              // Logo
                              Container(
                                width: screenWidth * 0.18,
                                height: screenWidth * 0.18,
                                decoration: BoxDecoration(
                                  color: corPrimaria,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.black, width: 1),
                                ),
                                child: Icon(
                                  Icons.store,
                                  size: screenWidth * 0.10,
                                  color: corTexto,
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.04),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      petShopData!['name']?.toString() ?? 'Pet Shop',
                                      style: TextStyle(
                                        fontSize: screenHeight * 0.024,
                                        fontWeight: FontWeight.bold,
                                        color: corTexto,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (petShopData!['description'] != null &&
                                        petShopData!['description'].toString().trim().isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(top: screenHeight * 0.005),
                                        child: Text(
                                          petShopData!['description'].toString(),
                                          style: TextStyle(
                                            fontSize: screenHeight * 0.016,
                                            color: corTexto.withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // Contato
                          if (_temContato()) ...[
                            Divider(height: screenHeight * 0.04, color: corTexto.withOpacity(0.2)),
                            Text(
                              'Contato',
                              style: TextStyle(
                                fontSize: screenHeight * 0.020,
                                fontWeight: FontWeight.bold,
                                color: corTexto,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            if (_temValor(petShopData!['commercialPhone']))
                              _buildInfo(Icons.phone, 'Telefone',
                                  petShopData!['commercialPhone'].toString(), screenHeight),
                            if (_temValor(petShopData!['whatsapp']))
                              _buildInfo(Icons.chat, 'WhatsApp',
                                  petShopData!['whatsapp'].toString(), screenHeight),
                            if (_temValor(petShopData!['commercialEmail']))
                              _buildInfo(Icons.email, 'E-mail',
                                  petShopData!['commercialEmail'].toString(), screenHeight),
                          ],

                          // Redes Sociais
                          if (_temRedes()) ...[
                            Divider(height: screenHeight * 0.04, color: corTexto.withOpacity(0.2)),
                            Text(
                              'Redes Sociais',
                              style: TextStyle(
                                fontSize: screenHeight * 0.020,
                                fontWeight: FontWeight.bold,
                                color: corTexto,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            if (_temValor(petShopData!['instagram']))
                              _buildInfo(Icons.camera_alt, 'Instagram',
                                  petShopData!['instagram'].toString(), screenHeight),
                            if (_temValor(petShopData!['facebook']))
                              _buildInfo(Icons.facebook, 'Facebook',
                                  petShopData!['facebook'].toString(), screenHeight),
                            if (_temValor(petShopData!['website']))
                              _buildInfo(Icons.language, 'Site',
                                  petShopData!['website'].toString(), screenHeight),
                          ],

                          // Localização
                          if (_temLocalizacao()) ...[
                            Divider(height: screenHeight * 0.04, color: corTexto.withOpacity(0.2)),
                            Text(
                              'Localização',
                              style: TextStyle(
                                fontSize: screenHeight * 0.020,
                                fontWeight: FontWeight.bold,
                                color: corTexto,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            _buildInfo(
                              Icons.location_on,
                              'Endereço',
                              _getEnderecoCompleto(),
                              screenHeight,
                            ),
                          ],

                          // Serviços
                          if (_temServicos()) ...[
                            Divider(height: screenHeight * 0.04, color: corTexto.withOpacity(0.2)),
                            Text(
                              'Outros Serviços',
                              style: TextStyle(
                                fontSize: screenHeight * 0.020,
                                fontWeight: FontWeight.bold,
                                color: corTexto,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: (petShopData!['services'] as List)
                                  .map((s) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: corPrimaria.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: corPrimaria, width: 1),
                                ),
                                child: Text(
                                  s.toString(),
                                  style: TextStyle(
                                    fontSize: screenHeight * 0.016,
                                    color: corTexto,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ))
                                  .toList(),
                            ),
                          ],
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Botão Agendar
                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.07,
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
                        icon: Icon(Icons.calendar_today, size: screenHeight * 0.03),
                        label: Text(
                          'Agendar Serviço',
                          style: TextStyle(
                            fontSize: screenHeight * 0.022,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingPage(
                                service: widget.service,
                                petShopId: widget.service.petShopId,
                              ),
                            ),
                          ).then((success) {
                            // Se o agendamento foi bem sucedido
                            if (success == true && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.check_circle, color: Colors.white),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text('Agendamento realizado!'),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: Colors.green[700],
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                          });
                        },
                      ),
                    ),
                  ] else if (errorMessage != null)
                  // Erro
                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.red, width: 2),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red[800], size: 40),
                          const SizedBox(height: 10),
                          Text(
                            'Erro ao carregar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[900],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(errorMessage!, textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadPetShopData,
                            child: const Text('Tentar Novamente'),
                          ),
                        ],
                      ),
                    )
                  else
                  // Sem dados
                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.orange, width: 2),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: Colors.orange[800], size: 30),
                          const SizedBox(width: 15),
                          const Expanded(
                            child: Text(
                              'Informações não disponíveis',
                              style: TextStyle(color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  bool _temServicos() {
    if (petShopData == null) return false;
    return petShopData!['services'] is List &&
        (petShopData!['services'] as List).isNotEmpty;
  }

  bool _temLocalizacao() {
    // Verifica se tem dados de localização no SharedPreferences
    return (endereco != null && endereco!.trim().isNotEmpty) ||
        (cidade != null && cidade!.trim().isNotEmpty) ||
        (cep != null && cep!.trim().isNotEmpty);
  }

  String _getEnderecoCompleto() {
    List<String> partes = [];

    // Rua e número
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

    // Bairro
    if (bairro != null && bairro!.trim().isNotEmpty) {
      partes.add(bairro!);
    }

    // Cidade e Estado
    if (cidade != null && cidade!.trim().isNotEmpty) {
      String cidadeEstado = cidade!;
      if (estado != null && estado!.trim().isNotEmpty) {
        cidadeEstado += ' - $estado';
      }
      partes.add(cidadeEstado);
    }

    // CEP
    if (cep != null && cep!.trim().isNotEmpty) {
      partes.add('CEP: $cep');
    }

    return partes.join('\n');
  }

  Widget _buildInfo(IconData icon, String label, String value, double h) {
    return Padding(
      padding: EdgeInsets.only(bottom: h * 0.012),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: corPrimaria.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: corTexto),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                      fontSize: h * 0.014,
                      color: corTexto.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    )),
                Text(value,
                    style: TextStyle(
                      fontSize: h * 0.017,
                      color: corTexto,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}