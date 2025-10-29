import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  String? message;

  // Função para enviar o pedido de redefinição de senha
  Future<void> sendResetRequest() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      setState(() => message = "Por favor, insira seu e-mail.");
      return;
    }

    setState(() {
      isLoading = true;
      message = null;
    });

    try {
      // Substitua pelo IP correto ou localhost conforme o seu ambiente
      final response = await Dio().post(
        'http://10.0.2.2:8080/users/reset-password/request',
        data: {'email': email},
      );

      setState(() {
        message = response.data.toString();
      });
    } on DioException catch (e) {
      setState(() {
        message = e.response?.data?.toString() ?? "Erro ao enviar solicitação.";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBDD6C),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
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
                  keyboardType: TextInputType.emailAddress,
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
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : sendResetRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
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
                const SizedBox(height: 20),
                if (message != null)
                  Text(
                    message!,
                    style: TextStyle(
                      color: message!.contains("enviado") ? Colors.green : Colors.red,
                      fontFamily: 'InclusiveSans',
                      fontSize: 15,
                    ),
                  ),
                const SizedBox(height: 40),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
