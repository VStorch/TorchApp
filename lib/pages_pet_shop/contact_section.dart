import 'package:flutter/material.dart';
import 'custom_widgets.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cnpjController = TextEditingController(text: "73.233.352/0001-16");
    final telefoneController = TextEditingController(text: "(47)99745-6464");
    final emailController = TextEditingController(text: "leonardo@gmail.com");

    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.9; // 90% da largura da tela

    return Center(
      child: Container(
        width: containerWidth > 380 ? 380 : containerWidth, // máximo 380, mas se a tela for menor, ajusta
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDE7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Contato",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: screenWidth * 0.05), // altura proporcional à tela
            const LabelText("CNPJ:"),
            CustomTextField(controller: cnpjController),
            const LabelText("Telefone comercial:"),
            CustomTextField(controller: telefoneController),
            const LabelText("Email comercial:"),
            CustomTextField(controller: emailController),
          ],
        ),
      ),
    );
  }
}
