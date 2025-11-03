import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PetShopInformationPage extends StatefulWidget {
  final int ownerId;

  const PetShopInformationPage({super.key, required this.ownerId});

  @override
  State<PetShopInformationPage> createState() => _PetShopInformationPageState();
}

class _PetShopInformationPageState extends State<PetShopInformationPage> {
  static const Color bgColor = Color(0xFFFBF8E1);
  static const Color yellow = Color(0xFFF7E34D);

  // Controllers para todos os campos
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ufController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _complementController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Adiciona listener para buscar endereço automaticamente ao digitar CEP completo
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
          _districtController.text = data['bairro'] ?? '';
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

  @override
  void dispose() {
    // Dispose dos controllers
    _cepController.dispose();
    _ufController.dispose();
    _cityController.dispose();
    _districtController.dispose();
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
                    Container(
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
                    Container(
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
                    Container(
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
                          _buildTextField(controller: _districtController, hint: "Bairro"),

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
                              onPressed: _registerPetShop,
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

  Future<void> _registerPetShop() async {
    final cep = _cepController.text.trim();
    final state = _ufController.text.trim();
    final city = _cityController.text.trim();
    final neighborhood = _districtController.text.trim();
    final street = _addressController.text.trim();
    final number = _numberController.text.trim();
    final complement = _complementController.text.trim();

    final cnpj = "00000000000000"; // temporário até adicionar campo

    if (cep.isEmpty || state.isEmpty || city.isEmpty || neighborhood.isEmpty || street.isEmpty || number.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios.')),
      );
      return;
    }

    final url = Uri.parse("http://10.0.2.2:8080/petshops");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "cnpj": cnpj,
          "cep": cep,
          "state": state,
          "city": city,
          "neighborhood": neighborhood,
          "street": street,
          "number": number,
          "addressComplement": complement.isEmpty ? null : complement,
          "ownerId": widget.ownerId, // 👈 aqui o vínculo com o dono
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pet Shop cadastrado com sucesso!")),
        );
        // Navegar para próxima tela se houver
      } else {
        print("Erro: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao cadastrar Pet Shop: ${response.body}")),
        );
      }
    } catch (e) {
      print("Erro de rede: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro de conexão com o servidor.")),
      );
    }
  }

}
