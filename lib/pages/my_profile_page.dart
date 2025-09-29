import 'dart:io';

import 'package:flutter/material.dart';
import 'package:torch_app/pages/promotions_page.dart';
import 'package:torch_app/pages/settings_page.dart';
import 'package:image_picker/image_picker.dart';
import '../models/page_type.dart';
import '../models/menu_item.dart';
import '../components/customdrawer.dart';

// Stateful widget (alterável)
class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  File? _profileImage; // imagem escolhida da galeria
  String? _selectedAssetImage; // imagem escolhida das padrões

  // lista de imagens padrão
  final List<String> _defaultImages = [
    "lib/assets/images_profile/dog1.jpg",
    "lib/assets/images_profile/dog2.jpg",
    "lib/assets/images_profile/dog3.jpg",
    "lib/assets/images_profile/dog4.jpg",
    "lib/assets/images_profile/cat1.jpg",
    "lib/assets/images_profile/cat2.jpg",
    "lib/assets/images_profile/cat3.jpg",
    "lib/assets/images_profile/cat4.jpg",
  ];

  // pegar imagem da galeria
  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _selectedAssetImage = null; // limpa escolha padrão
      });
    }
  }

  // escolher imagem padrão
  void _pickDefaultImage(String path) {
    setState(() {
      _selectedAssetImage = path;
      _profileImage = null; // limpa escolha da galeria
    });
  }

  // menu para escolher imagem
  void _showImageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: _pickFromGallery,
                icon: const Icon(Icons.photo),
                label: const Text("Escolher da Galeria"),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _defaultImages.map((path) {
                  return GestureDetector(
                    onTap: () {
                      _pickDefaultImage(path);
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(path),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    // Usa a fábrica para pegar dados como título, ícone e destino
    final menuItem = MenuItem.fromType(PageType.about);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: const Color(0xFFEBDD6C),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.pets),
              iconSize: 35,
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        title: SizedBox(
          height: 50,
          child: TextField(
            style: const TextStyle(fontSize: 20),
            decoration: InputDecoration(
              hintText: 'Busque um PetShop...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFFBF8E1),
              contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
      drawer: CustomDrawer(
        menuItems: [
          MenuItem.fromType(PageType.home),
          MenuItem.fromType(PageType.myPets),
          MenuItem.fromType(PageType.favorites),
          MenuItem.fromType(PageType.appointments),
          MenuItem.fromType(PageType.promotions),
          MenuItem.fromType(PageType.profile),
          MenuItem.fromType(PageType.settings),
          MenuItem.fromType(PageType.login),
          MenuItem.fromType(PageType.about),
        ],
      ),
      backgroundColor: const Color(0xFFFBF8E1),
    );
  }

  // Item da lista do perfil
  Widget _buildProfileOption(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      onTap: () {},
    );
  }
}