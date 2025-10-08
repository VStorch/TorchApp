import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RegistrationSupplements extends StatefulWidget {
  const RegistrationSupplements({super.key});

  @override
  State<RegistrationSupplements> createState() =>
      _RegistrationSupplementsState();
}

class _RegistrationSupplementsState extends State<RegistrationSupplements> {
  static const Color bgColor = Color(0xFFFBF8E1);
  static const Color yellow = Color(0xFFF7E34D);

  String? personType;
  bool accepted = false;
  final TextEditingController cnpjController = TextEditingController();

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
              bottom: -5, // acima da faixa amarela inferior
              left: 0,
              right: 0,
              child: SizedBox(
                height: 250, // ajuste a altura da animação
                child: Lottie.asset(
                  'lib/assets/images/CatArroz.json', // substitua pelo caminho do seu Lottie
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
                          const Text("Tipo de pessoa:"),
                          RadioListTile<String>(
                            title: const Text("Pessoa Física"),
                            value: 'fisica',
                            groupValue: personType,
                            onChanged: (value) {
                              setState(() {
                                personType = value;
                              });
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text("Pessoa Jurídica"),
                            value: 'juridica',
                            groupValue: personType,
                            onChanged: (value) {
                              setState(() {
                                personType = value;
                              });
                            },
                          ),

                          if (personType == 'juridica') ...[
                            const SizedBox(height: 6),
                            const Text("CNPJ:"),
                            const SizedBox(height: 6),
                            _buildTextField(
                                controller: cnpjController,
                                hint: "Digite o CNPJ",
                                keyboardType: TextInputType.number),
                          ],

                          const SizedBox(height: 12),
                          CheckboxListTile(
                            value: accepted,
                            onChanged: (value) {
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
                              onPressed: accepted
                                  ? () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Registro enviado com sucesso!")),
                                );
                              }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: yellow,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 36, vertical: 12),
                              ),
                              child: const Text(
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
