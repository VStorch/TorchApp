import 'package:flutter/material.dart';

// ================= LABEL E TEXTFIELD =================

class LabelText extends StatelessWidget {
  final String text;
  final double? fontSize; // parâmetro opcional para responsividade

  const LabelText(this.text, {super.key, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 5),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? 15,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hint;
  final bool readOnly;
  final bool obscure;

  const CustomTextField({
    super.key,
    required this.controller,
    this.hint,
    this.readOnly = false,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint ?? "",
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.black, width: 1),
        ),
      ),
    );
  }
}

// ================= USER TAB =================

class UserTab extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController birthController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const UserTab({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.birthController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // --- Dimensões proporcionais ---
    final containerPadding = screenWidth * 0.05;
    final fieldSpacing = screenHeight * 0.015;
    final titleFontSize = screenWidth * 0.05;
    final labelFontSize = screenWidth * 0.038;
    final buttonFontSize = screenWidth * 0.042;
    final buttonPaddingH = screenWidth * 0.12;
    final buttonPaddingV = screenHeight * 0.018;
    final borderRadius = screenWidth * 0.04;
    final barHeight = screenHeight * 0.08;

    return SingleChildScrollView(
      padding: EdgeInsets.all(containerPadding),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(containerPadding),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDE7),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Informações do Usuário",
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: fieldSpacing * 1.2),

            LabelText("Nome completo:", fontSize: labelFontSize),
            CustomTextField(controller: nameController),
            SizedBox(height: fieldSpacing),

            LabelText("Telefone:", fontSize: labelFontSize),
            CustomTextField(controller: phoneController),
            SizedBox(height: fieldSpacing),

            LabelText("Data de nascimento:", fontSize: labelFontSize),
            CustomTextField(controller: birthController, readOnly: true),
            SizedBox(height: fieldSpacing),

            LabelText("E-mail:", fontSize: labelFontSize),
            CustomTextField(controller: emailController),
            SizedBox(height: fieldSpacing),

            LabelText("Senha:", fontSize: labelFontSize),
            CustomTextField(controller: passwordController, obscure: true, readOnly: true),
            SizedBox(height: fieldSpacing / 2),
            GestureDetector(
              onTap: () {},
              child: Text(
                "Alterar senha?",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: labelFontSize * 0.9,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            SizedBox(height: fieldSpacing * 2),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Informações salvas com sucesso!"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF4E04D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: buttonPaddingH, vertical: buttonPaddingV),
                ),
                child: Text(
                  "Salvar Alterações",
                  style: TextStyle(
                    fontSize: buttonFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            SizedBox(height: barHeight),
          ],
        ),
      ),
    );
  }
}
