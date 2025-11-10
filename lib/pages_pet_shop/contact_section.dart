import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_widgets.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final TextEditingController cnpjController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContactData();
  }

  Future<void> _loadContactData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      // Carrega apenas o CNPJ do SharedPreferences
      cnpjController.text = prefs.getString('petshop_cnpj') ?? '';

      // Telefone e email ficam vazios (serão preenchidos depois pelo usuário)
      telefoneController.text = '';
      emailController.text = '';
    });
  }

  @override
  void dispose() {
    cnpjController.dispose();
    telefoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.9;

    return Center(
      child: Container(
        width: containerWidth > 380 ? 380 : containerWidth,
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
            SizedBox(height: screenWidth * 0.05),
            const LabelText("CNPJ:"),
            CustomTextField(controller: cnpjController),
            const LabelText("Telefone comercial:"),
            CustomTextField(
              controller: telefoneController,
              hint: "Digite o telefone comercial",
            ),
            const LabelText("Email comercial:"),
            CustomTextField(
              controller: emailController,
              hint: "Digite o email comercial",
            ),
          ],
        ),
      ),
    );
  }
}