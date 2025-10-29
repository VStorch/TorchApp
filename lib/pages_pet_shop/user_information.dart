import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:torch_app/pages_pet_shop/pet_shop_information.dart';
import 'dart:convert';

class UserInformationPage extends StatefulWidget {
  const UserInformationPage({super.key});

  @override
  State<UserInformationPage> createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  static const Color bgColor = Color(0xFFFBF8E1);
  static const Color yellow = Color(0xFFF7E34D);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

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
            Align(alignment: Alignment.topCenter, child: Container(height: 54, color: yellow)),
            Align(alignment: Alignment.bottomCenter, child: Container(height: 54, color: yellow)),

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
                        "Informações do Usuário",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 6),

                    Container(
                      width: formWidth,
                      child: const Text(
                        "As informações abaixo serão utilizadas para dar continuidade ao cadastramento do seu Pet Shop.",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      width: formWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Nome:"),
                          const SizedBox(height: 6),
                          _buildTextField(controller: _nameController, hint: "Digite seu nome"),

                          const SizedBox(height: 12),
                          const Text("Sobrenome:"),
                          const SizedBox(height: 6),
                          _buildTextField(controller: _surnameController, hint: "Digite seu sobrenome"),

                          const SizedBox(height: 12),
                          const Text("Celular:"),
                          const SizedBox(height: 6),
                          _buildTextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            hint: "(11) 9 1234-5678",
                          ),

                          const SizedBox(height: 12),
                          const Text("E-mail:"),
                          const SizedBox(height: 6),
                          _buildTextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            hint: "seu@email.com",
                          ),

                          const SizedBox(height: 12),
                          const Text("Senha:"),
                          const SizedBox(height: 6),
                          _buildTextField(
                            controller: _passwordController,
                            obscure: true,
                            hint: "Mínimo 8 caracteres",
                          ),

                          const SizedBox(height: 18),

                          Center(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: yellow,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                              )
                                  : const Text(
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
                  height: 55,
                  child: Lottie.asset('lib/assets/images/CuteDog.json', fit: BoxFit.contain),
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

  Future<void> _submitForm() async {
    final name = _nameController.text.trim();
    final surname = _surnameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validação básica
    if (name.isEmpty || surname.isEmpty || phone.isEmpty || email.isEmpty || password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos corretamente.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final url = Uri.parse('http://10.0.2.2:8080/users/petshop-owner'); // Emulador Android usa 10.0.2.2
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "surname": surname,
          "phone": phone,
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro realizado com sucesso!')),
        );

        // Navega para PetShopInformationPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PetShopInformationPage()),
        );
      } else {
        print("Erro: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar: ${response.body}')),
        );
      }
    } catch (e) {
      print("Erro de rede: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro de conexão com o servidor.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
