import 'package:flutter/material.dart';
import 'custom_widgets.dart';

class LocationSection extends StatelessWidget {
  final TextEditingController cepController;
  final TextEditingController stateController;
  final TextEditingController cityController;
  final TextEditingController neighborhoodController;
  final TextEditingController streetController;
  final TextEditingController numberController;
  final TextEditingController addressComplementController;

  const LocationSection({
    super.key,
    required this.cepController,
    required this.stateController,
    required this.cityController,
    required this.neighborhoodController,
    required this.streetController,
    required this.numberController,
    required this.addressComplementController,
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
            CustomTextField(controller: stateController),
            const LabelText("Cidade:"),
            CustomTextField(controller: cityController),
            const LabelText("Bairro:"),
            CustomTextField(controller: neighborhoodController),
            const LabelText("Rua:"),
            CustomTextField(controller: streetController),
            const LabelText("Número:"),
            CustomTextField(controller: numberController),
            const LabelText("Complemento:"),
            CustomTextField(controller: addressComplementController),
          ],
        ),
      ),
    );
  }
}
