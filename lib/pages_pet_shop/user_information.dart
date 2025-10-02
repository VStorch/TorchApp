import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class UserInformationPage extends StatefulWidget {
  const UserInformationPage({super.key});

  @override
  State<UserInformationPage> createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  static const Color bgColor = Color(0xFFFBF8E1);
  static const Color yellow = Color(0xFFF7E34D);

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

            // Conteúdo central
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Linha preta superior
                    Container(height: 1, color: Colors.black),
                    const SizedBox(height: 10),

                    Container(
                      width: formWidth,
                      child: const Text(
                        "Informações do Usuário",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    Container(
                      width: formWidth,
                      child: const Text(
                        "As informações abaixo serão utilizadas para dar continuidade ao cadastramento do seu Pet Shop.",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Formulário
                    Container(
                      width: formWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Nome Completo:"),
                          const SizedBox(height: 6),
                          _buildTextField(hint: "Digite seu nome"),

                          const SizedBox(height: 12),
                          const Text("Celular:"),
                          const SizedBox(height: 6),
                          _buildTextField(
                              keyboardType: TextInputType.phone,
                              hint: "(xx) xxxxx-xxxx"),

                          const SizedBox(height: 12),
                          const Text("E-mail:"),
                          const SizedBox(height: 6),
                          _buildTextField(
                              keyboardType: TextInputType.emailAddress,
                              hint: "seu@email.com"),

                          const SizedBox(height: 12),
                          const Text("Senha:"),
                          const SizedBox(height: 6),
                          _buildTextField(obscure: true, hint: "Senha"),

                          const SizedBox(height: 18),

                          Center(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: yellow,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 36, vertical: 12),
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

                    // Linha preta inferior
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
                  height: 100,
                  child: Lottie.asset(
                    'lib/assets/images/CuteDog.json',
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
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    String hint = '',
  }) {
    return TextField(
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
}
