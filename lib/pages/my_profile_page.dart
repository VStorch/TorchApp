import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:torch_app/pages/pet_shops_page.dart';

import '../components/CustomDrawer.dart';
import '../models/menu_item.dart';
import '../models/page_type.dart';

// Substitua com os seus arquivos reais
import 'login_page.dart';
import 'password_page.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  File? _profileImage;
  String? _selectedAssetImage;

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

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _selectedAssetImage = null;
      });
    }
  }

  void _pickDefaultImage(String path) {
    setState(() {
      _selectedAssetImage = path;
      _profileImage = null;
    });
  }

  void _showImageOptions(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: const Color(0xFFFBF8E1),
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEBDD6C),
                  foregroundColor: Colors.black,
                ),
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

  void _handleOptionTap(String title) async {
    switch (title) {
      case "Alterar Senha":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PasswordPage()),
        );
        break;

      case "Sair Da Conta":
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFFFBF8E1),
            title: const Text("Sair da conta",
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: const Text("Tem certeza que deseja sair?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancelar"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEBDD6C),
                  foregroundColor: Colors.black,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Sair"),
              ),
            ],
          ),
        );

        if (confirm == true) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
          );
        }
        break;

      case "Notificações":
        _showNotificationDialog();
        break;

      case "Meus PetShops Favoritos":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PetShopPage()),
        );
        break;

      default:
        break;
    }
  }

  void _showNotificationDialog() {
    bool isEnabled = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: const Color(0xFFFBF8E1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.notifications_active,
                        size: 40, color: Colors.black87),
                    const SizedBox(height: 12),
                    const Text(
                      "Configurar Notificações",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Ativar notificações",
                            style: TextStyle(fontSize: 16)),
                        Switch(
                          activeColor: Colors.green,
                          value: isEnabled,
                          onChanged: (value) {
                            setState(() {
                              isEnabled = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEBDD6C),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Salvar"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8E1),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Leonardo Cortelim",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("leo.gmail.com",
                style: TextStyle(fontSize: 16, color: Colors.black87)),
            const Text("(47)99678-8765",
                style: TextStyle(fontSize: 16, color: Colors.black87)),
            const Text("Rua Adriano Korman, nº 123 - SC",
                style: TextStyle(fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 20),
            const Divider(),
            _buildProfileOption(Icons.pets, "Meus PetShops Favoritos"),
            const Divider(),
            _buildProfileOption(Icons.receipt_long, "Meus Pedidos"),
            const Divider(),
            _buildProfileOption(Icons.credit_card, "Formas De Pagamento"),
            const Divider(),
            _buildProfileOption(Icons.notifications, "Notificações"),
            const Divider(),
            _buildProfileOption(Icons.lock, "Alterar Senha"),
            const Divider(),
            _buildProfileOption(Icons.logout, "Sair Da Conta"),
            const Divider(),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () => _showImageOptions(context),
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : _selectedAssetImage != null
                    ? AssetImage(_selectedAssetImage!) as ImageProvider
                    : const AssetImage("lib/assets/images/american.jpg"),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      onTap: () => _handleOptionTap(title),
    );
  }
}
