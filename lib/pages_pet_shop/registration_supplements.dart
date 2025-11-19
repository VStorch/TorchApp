import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart'; // ADICIONAR
import 'package:cpf_cnpj_validator/cnpj_validator.dart'; // ADICIONAR
import 'dart:convert';
import 'package:torch_app/models/dtos/pet_shop_dto.dart';

class RegistrationSupplements extends StatefulWidget {
  final PetShopDto petShop;

  const RegistrationSupplements({super.key, required this.petShop});

  @override
  State<RegistrationSupplements> createState() =>
      _RegistrationSupplementsState();
}

class _RegistrationSupplementsState extends State<RegistrationSupplements> {
  static const Color bgColor = Color(0xFFFBF8E1);
  static const Color yellow = Color(0xFFF7E34D);

  bool accepted = false;
  bool _isLoading = false;
  final TextEditingController cnpjController = TextEditingController();
  String? companyName; // Nome da empresa do CNPJ
  bool _isSearchingCNPJ = false;

  @override
  void dispose() {
    cnpjController.dispose();
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
            // Faixa amarela superior
            Align(
              alignment: Alignment.topCenter,
              child: Container(height: 54, color: yellow),
            ),

            // Faixa amarela inferior
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(height: 54, color: yellow),
            ),

            // Lottie acima da faixa inferior
            Positioned(
              bottom: -5,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 250,
                child: Lottie.asset(
                  'lib/assets/images/CatArroz.json',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Conteúdo central
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(height: 1, color: Colors.black),
                    const SizedBox(height: 10),

                    // Título
                    Container(
                      width: formWidth,
                      child: const Text(
                        "Cadastrar Pet Shop",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    Container(
                      width: formWidth,
                      child: const Text(
                        "Informações complementares.",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Formulário
                    Container(
                      width: formWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("CNPJ:"),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: cnpjController,
                                  hint: "00.000.000/0000-00",
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _isSearchingCNPJ ? null : _searchCNPJ,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: yellow,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                ),
                                child: _isSearchingCNPJ
                                    ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                )
                                    : const Text(
                                  "Buscar",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Exibir nome da empresa se encontrado
                          if (companyName != null) ...[
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Empresa encontrada:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    companyName!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 12),
                          CheckboxListTile(
                            value: accepted,
                            onChanged: _isLoading ? null : (value) {
                              setState(() {
                                accepted = value ?? false;
                              });
                            },
                            title: const Text(
                                "Aceito os termos e condições de uso"),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),

                          const SizedBox(height: 18),
                          Center(
                            child: ElevatedButton(
                              onPressed: (accepted && !_isLoading) ? _submitForm : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: yellow,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 36, vertical: 12),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                                  : const Text(
                                "Concluir",
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
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
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
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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

  Future<void> _searchCNPJ() async {
    final cnpj = cnpjController.text.trim();

    if (cnpj.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite o CNPJ.')),
      );
      return;
    }

    // Validação real de CNPJ
    if (!CNPJValidator.isValid(cnpj)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('CNPJ inválido!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSearchingCNPJ = true);

    try {
      // Remove formatação
      final cnpjNumbers = cnpj.replaceAll(RegExp(r'[^\d]'), '');

      // Consulta API da Receita Federal (via proxy público)
      final url = Uri.parse("https://publica.cnpj.ws/cnpj/$cnpjNumbers");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          companyName = data['razao_social'] ?? 'Nome não encontrado';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('CNPJ validado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível consultar o CNPJ.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      print("Erro ao consultar CNPJ: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao consultar CNPJ. Verifique sua conexão.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSearchingCNPJ = false);
      }
    }
  }

  Future<void> _submitForm() async {
    final cnpj = cnpjController.text.trim();

    if (cnpj.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite o CNPJ.')),
      );
      return;
    }

    // Verifica se o CNPJ foi validado (se o nome da empresa foi encontrado)
    if (companyName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Clique em "Buscar" para validar o CNPJ primeiro.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Remove formatação para enviar apenas números
    final cnpjNumbers = cnpj.replaceAll(RegExp(r'[^\d]'), '');

    final updatedPetShop = PetShopDto(
      cep: widget.petShop.cep,
      state: widget.petShop.state,
      city: widget.petShop.city,
      neighborhood: widget.petShop.neighborhood,
      street: widget.petShop.street,
      number: widget.petShop.number,
      complement: widget.petShop.complement,
      cnpj: cnpjNumbers, // Envia apenas números
      ownerId: widget.petShop.ownerId,
    );

    await _registerPetShop(updatedPetShop);
  }

  Future<void> _registerPetShop(PetShopDto petShop) async {
    final url = Uri.parse("http://10.0.2.2:8080/petshops");

    try {
      print("===== ENVIANDO PETSHOP =====");
      print("URL: $url");
      print("Body: ${jsonEncode(petShop.toJson())}");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(petShop.toJson()),
      );

      print("Status: ${response.statusCode}");
      print("Response: ${response.body}");
      print("============================");

      if (response.statusCode == 201) {
        // Salvar CNPJ no SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('petshop_cnpj', petShop.cnpj);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Pet Shop cadastrado com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );

        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/',
                (Route<dynamic> route) => false,
          );
        }
      } else {
        print("Erro no cadastro: ${response.body}");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Erro ao cadastrar: ${response.body}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print("Erro de rede: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erro de conexão com o servidor."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}