import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  final String? prefilledCode; // Código opcional vindo do deep link

  const ResetPasswordPage({
    super.key,
    required this.email,
    this.prefilledCode,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;
  String? message;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  // Função para confirmar a redefinição de senha
  Future<void> confirmResetPassword() async {
    final code = codeController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (code.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() => message = "Por favor, preencha todos os campos.");
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() => message = "As senhas não coincidem.");
      return;
    }

    if (newPassword.length < 6) {
      setState(() => message = "A senha deve ter pelo menos 6 caracteres.");
      return;
    }

    setState(() {
      isLoading = true;
      message = null;
    });

    try {
      final response = await Dio().post(
        'http://10.0.2.2:8080/users/reset-password/confirm',
        data: {
          'email': widget.email,
          'code': code,
          'newPassword': newPassword,
        },
      );

      setState(() {
        message = "Senha redefinida com sucesso!";
      });

      // Aguarda 2 segundos e volta para a tela de login
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } on DioException catch (e) {
      setState(() {
        message = e.response?.data?.toString() ?? "Erro ao redefinir senha.";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBDD6C),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEBDD6C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Criar Nova Senha",
                  style: TextStyle(
                    fontFamily: 'InknutAntiqua',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Enviamos um código de segurança para ${widget.email}. Digite-o abaixo junto com sua nova senha.",
                  style: const TextStyle(
                    fontFamily: 'InclusiveSans',
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),

                // Campo do código
                const Text(
                  "Código de Segurança:",
                  style: TextStyle(
                    fontFamily: 'InknutAntiqua',
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.black),
                    hintText: "Digite o código recebido",
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

                // Campo nova senha
                const Text(
                  "Nova Senha:",
                  style: TextStyle(
                    fontFamily: 'InknutAntiqua',
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: newPasswordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Colors.black),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black54,
                      ),
                      onPressed: () => setState(() => obscurePassword = !obscurePassword),
                    ),
                    hintText: "Digite sua nova senha",
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

                // Campo confirmar senha
                const Text(
                  "Confirmar Nova Senha:",
                  style: TextStyle(
                    fontFamily: 'InknutAntiqua',
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirmPassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Colors.black),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black54,
                      ),
                      onPressed: () => setState(() => obscureConfirmPassword = !obscureConfirmPassword),
                    ),
                    hintText: "Confirme sua nova senha",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Botão confirmar
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : confirmResetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Redefinir Senha",
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

                // Mensagem de feedback
                if (message != null)
                  Center(
                    child: Text(
                      message!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: message!.contains("sucesso") ? Colors.green : Colors.red,
                        fontFamily: 'InclusiveSans',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
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

  @override
  void dispose() {
    codeController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}