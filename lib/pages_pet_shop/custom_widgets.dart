import 'package:flutter/material.dart';

/// Label estilizada
class LabelText extends StatelessWidget {
  final String text;

  const LabelText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(
        top: screenWidth * 0.03, // 3% da largura da tela
        bottom: screenWidth * 0.012,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: screenWidth * 0.038, // fonte proporcional à tela
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}

/// TextField padronizado
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
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: double.infinity, // Ocupa toda a largura disponível do pai
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint ?? "",
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            vertical: screenWidth * 0.025, // padding proporcional
            horizontal: screenWidth * 0.03,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.015),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
        ),
      ),
    );
  }
}
