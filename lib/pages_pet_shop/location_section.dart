import 'package:flutter/material.dart';
import 'custom_widgets.dart';

class LocationSection extends StatelessWidget {
  final TextEditingController cepController;
  final TextEditingController estadoController;
  final TextEditingController cidadeController;
  final TextEditingController bairroController;
  final TextEditingController enderecoController;
  final TextEditingController numeroController;
  final TextEditingController complementoController;

  const LocationSection({
    super.key,
    required this.cepController,
    required this.estadoController,
    required this.cidadeController,
    required this.bairroController,
    required this.enderecoController,
    required this.numeroController,
    required this.complementoController,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.9; // 90% da tela
    final horizontalPadding = screenWidth * 0.06;
    final verticalPadding = screenWidth * 0.04;
    final spacing = screenWidth * 0.04;

    return Center(
      child: Container(
        width: containerWidth > 380 ? 380 : containerWidth, // máximo 380
        padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDE7),
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
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
            Center(
              child: Text(
                "Localização",
                style: TextStyle(
                    fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: spacing),
            const LabelText("CEP:"),
            CustomTextField(controller: cepController),
            const LabelText("Estado:"),
            CustomTextField(controller: estadoController),
            const LabelText("Cidade:"),
            CustomTextField(controller: cidadeController),
            const LabelText("Bairro:"),
            CustomTextField(controller: bairroController),
            const LabelText("Endereço:"),
            CustomTextField(controller: enderecoController),
            const LabelText("Número:"),
            CustomTextField(controller: numeroController),
            const LabelText("Complemento:"),
            CustomTextField(controller: complementoController),
          ],
        ),
      ),
    );
  }
}
