import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torch_app/models/dtos/pet_shop_dto.dart';
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';

import 'package:torch_app/pages_pet_shop/registration_supplements.dart';

class PetShopInformationPage extends StatefulWidget {
  final int ownerId;

  const PetShopInformationPage({super.key, required this.ownerId});

  @override
  State<PetShopInformationPage> createState() => _PetShopInformationPageState();
}

class _PetShopInformationPageState extends State<PetShopInformationPage> {
  static const Color bgColor = Color(0xFFFBF8E1);
  static const Color yellow = Color(0xFFF7E34D);

  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ufController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _complementController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cepController.addListener(() {
      String cep = _cepController.text.replaceAll(RegExp(r'[^0-9]'), '');
      if (cep.length == 8) {
        _fetchAddress(cep);
      }
    });
  }

  Future<void> _fetchAddress(String cep) async {
    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['erro'] == true) {
          _showError('CEP não encontrado.');
          return;
        }
        setState(() {
          _ufController.text = data['uf'] ?? '';
          _cityController.text = data['localidade'] ?? '';
          _neighborhoodController.text = data['bairro'] ?? '';
          _addressController.text = data['logradouro'] ?? '';
        });
      } else {
        _showError('Erro ao buscar o CEP.');
      }
    } catch (e) {
      _showError('Erro na requisição: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _saveAddressData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('petshop_cep', _cepController.text.trim());
    await prefs.setString('petshop_state', _ufController.text.trim());
    await prefs.setString('petshop_city', _cityController.text.trim());
    await prefs.setString('petshop_neighborhood', _neighborhoodController.text.trim());
    await prefs.setString('petshop_street', _addressController.text.trim());
    await prefs.setString('petshop_number', _numberController.text.trim());
    await prefs.setString('petshop_complement', _complementController.text.trim());
  }

  // Função para geocodificar o endereço usando Nominatim (OpenStreetMap)
  Future<LatLng?> _getCoordinatesFromAddress() async {
    try {
      final fullAddress = '${_addressController.text}, ${_numberController.text}, ${_neighborhoodController.text}, ${_cityController.text}, ${_ufController.text}, Brasil';

      // Usando Nominatim API (OpenStreetMap)
      final encodedAddress = Uri.encodeComponent(fullAddress);
      final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$encodedAddress&format=json&limit=1');

      final response = await http.get(
        url,
        headers: {'User-Agent': 'TorchPetShopApp/1.0'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          return LatLng(lat, lon);
        }
      }
    } catch (e) {
      print('Erro ao geocodificar: $e');
      _showError('Não foi possível encontrar a localização exata.');
    }
    return null;
  }

  // Função para mostrar o mapa em um modal
  Future<void> _showMapModal(LatLng coordinates) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Localização do Pet Shop',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
                child: fm.FlutterMap(
                  options: fm.MapOptions(
                    initialCenter: coordinates,
                    initialZoom: 16.0,
                    minZoom: 5.0,
                    maxZoom: 18.0,
                  ),
                  children: [
                    fm.TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.torch.app',
                      maxNativeZoom: 19,
                    ),
                    fm.MarkerLayer(
                      markers: [
                        fm.Marker(
                          point: coordinates,
                          width: 80,
                          height: 80,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  'Pet Shop',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${_addressController.text}, ${_numberController.text} - ${_neighborhoodController.text}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _navigateToNextPage();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: yellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Confirmar e Continuar",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
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

  void _navigateToNextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrationSupplements(
          petShop: PetShopDto(
            cep: _cepController.text,
            state: _ufController.text,
            city: _cityController.text,
            neighborhood: _neighborhoodController.text,
            street: _addressController.text,
            number: _numberController.text,
            complement: _complementController.text,
            cnpj: "00.000.000/0000-00",
            ownerId: widget.ownerId,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cepController.dispose();
    _ufController.dispose();
    _cityController.dispose();
    _neighborhoodController.dispose();
    _addressController.dispose();
    _numberController.dispose();
    _complementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    double formWidth = screenWidth * 0.9;
    if (formWidth > 360) formWidth = 360;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(height: 54, color: yellow),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(height: 54, color: yellow),
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(height: 1, color: Colors.black),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: formWidth,
                      child: const Text(
                        "Cadastrar Pet Shop",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: formWidth,
                      child: const Text(
                        "Informe o CEP e complete as informações.",
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: formWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("CEP:"),
                          const SizedBox(height: 6),
                          _buildTextField(controller: _cepController, hint: "Digite o CEP", keyboardType: TextInputType.number),

                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Estado"),
                                    const SizedBox(height: 6),
                                    _buildTextField(controller: _ufController, hint: "UF"),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Cidade"),
                                    const SizedBox(height: 6),
                                    _buildTextField(controller: _cityController, hint: "Cidade"),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),
                          const Text("Bairro:"),
                          const SizedBox(height: 6),
                          _buildTextField(controller: _neighborhoodController, hint: "Bairro"),

                          const SizedBox(height: 12),
                          const Text("Endereço:"),
                          const SizedBox(height: 6),
                          _buildTextField(controller: _addressController, hint: "Rua, avenida..."),

                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Número:"),
                                    const SizedBox(height: 6),
                                    _buildTextField(controller: _numberController, hint: "Nº", keyboardType: TextInputType.number),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Complemento:"),
                                    const SizedBox(height: 6),
                                    _buildTextField(controller: _complementController, hint: "Opcional"),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                final cep = _cepController.text.trim();
                                final state = _ufController.text.trim();
                                final city = _cityController.text.trim();
                                final neighborhood = _neighborhoodController.text.trim();
                                final street = _addressController.text.trim();
                                final number = _numberController.text.trim();

                                if (cep.isEmpty || state.isEmpty || city.isEmpty || neighborhood.isEmpty || street.isEmpty || number.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Preencha todos os campos obrigatórios.')),
                                  );
                                  return;
                                }

                                // Salvar dados
                                await _saveAddressData();

                                // Mostrar loading
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );

                                // Buscar coordenadas
                                final coordinates = await _getCoordinatesFromAddress();

                                // Fechar loading
                                Navigator.pop(context);

                                if (coordinates != null) {
                                  // Mostrar mapa
                                  await _showMapModal(coordinates);
                                } else {
                                  // Se não conseguir geocodificar, navega direto
                                  _navigateToNextPage();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: yellow,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                              ),
                              child: const Text(
                                "Continuar",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(height: 1, color: Colors.black),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: SizedBox(
                  height: 70,
                  child: Lottie.asset(
                    'lib/assets/images/Catk.json',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    TextEditingController? controller,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    String hint = '',
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 1.2),
        ),
      ),
    );
  }
}