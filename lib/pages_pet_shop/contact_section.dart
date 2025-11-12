import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_widgets.dart';

class ContactSection extends StatefulWidget {
  final TextEditingController? phoneController;
  final TextEditingController? emailController;

  const ContactSection({
    super.key,
    this.phoneController,
    this.emailController,
  });

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final TextEditingController cnpjController = TextEditingController();
  late TextEditingController phoneController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();

    // Usar controllers passados ou criar novos
    phoneController = widget.phoneController ?? TextEditingController();
    emailController = widget.emailController ?? TextEditingController();

    _loadContactData();
  }

  Future<void> _loadContactData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      // Carrega apenas o CNPJ do SharedPreferences
      cnpjController.text = prefs.getString('petshop_cnpj') ?? '';

      // Telefone e email só são resetados se não foram passados controllers
      if (widget.phoneController == null) {
        phoneController.text = '';
      }
      if (widget.emailController == null) {
        emailController.text = '';
      }
    });
  }

  @override
  void dispose() {
    cnpjController.dispose();

    // Só dispose dos controllers criados internamente
    if (widget.phoneController == null) {
      phoneController.dispose();
    }
    if (widget.emailController == null) {
      emailController.dispose();
    }

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
              controller: phoneController,
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