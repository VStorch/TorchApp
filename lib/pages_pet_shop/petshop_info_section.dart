import 'dart:io';
import 'package:flutter/material.dart';

class PetShopInfoSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final File? petLogo;
  final VoidCallback pickLogo;

  const PetShopInfoSection({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.petLogo,
    required this.pickLogo,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width.toDouble();

    final logoSize = (screenWidth * 0.35).toDouble(); // logo proporcional
    final containerWidth = (screenWidth * 0.9 > 380 ? 380 : screenWidth * 0.9).toDouble();
    final padding = (screenWidth * 0.05).toDouble();
    final spacing = (screenWidth * 0.04).toDouble();
    final fontSizeLabel = (screenWidth * 0.038).toDouble();
    final fontSizeTitle = (screenWidth * 0.045).toDouble();

    return Center(
      child: Column(
        children: [
          SizedBox(height: spacing),
          Column(
            children: [
              Container(
                width: logoSize,
                height: logoSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                  color: Colors.grey[200], // fundo neutro caso não tenha logo
                  image: petLogo != null
                      ? DecorationImage(
                    image: FileImage(petLogo!),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
              ),
              SizedBox(height: (spacing / 5).toDouble()),
              GestureDetector(
                onTap: pickLogo,
                child: Text(
                  "Alterar logo",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: fontSizeLabel,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing),
          Container(
            width: containerWidth,
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDE7),
              borderRadius: BorderRadius.circular(padding),
              border: Border.all(color: Colors.black, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
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
                    "Informações do Pet Shop",
                    style: TextStyle(
                      fontSize: fontSizeTitle,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: spacing),
                Text(
                  "Nome do Pet Shop:",
                  style: TextStyle(fontSize: fontSizeLabel, fontWeight: FontWeight.w600),
                ),
                TextField(controller: nameController),
                SizedBox(height: (spacing / 1.3).toDouble()),
                Text(
                  "Descrição:",
                  style: TextStyle(fontSize: fontSizeLabel, fontWeight: FontWeight.w600),
                ),
                TextField(controller: descriptionController, maxLines: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
