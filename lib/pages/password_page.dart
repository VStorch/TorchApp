import 'package:flutter/material.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBDD6C),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Redefinir Sua Senha",
                style: TextStyle(
                  fontFamily: 'InknutAntiqua',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Insira o endereço de e-mail no TorchApp para receber um código de segurança no seu email.",
                style: TextStyle(
                  fontFamily: 'InclusiveSans',
                  fontSize: 17.5,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Endereço de e-mail:",
                style: TextStyle(
                  fontFamily: 'InknutAntiqua',
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.alternate_email, color: Colors.black),
                  hintText: "Digite seu e-mail",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),

                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Botão Continuar
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    print("Email digitado: ${emailController.text}");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Continuar",
                    style: TextStyle(
                      fontFamily: 'InknutAntiqua',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 70),

              Center(
                child: ClipOval(
                  child: Image.asset(
                    "lib/assets/images/dogP.png",
                    scale: 1,
                    width: 350,
                    height: 350,
                    fit: BoxFit.contain,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
