import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torch_app/pages/pet_shops_page.dart';

import '../components/custom_drawer.dart';
import '../models/menu_item.dart';
import '../models/page_type.dart';
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
  String _userName = "Carregando..."; // Valor inicial

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

  final Color yellow = const Color(0xFFF4E04D);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Carrega os dados salvos localmente
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name') ?? '';
    final surname = prefs.getString('user_surname') ?? '';

    setState(() {
      _userName = name.isNotEmpty && surname.isNotEmpty
          ? "$name $surname"
          : "Usuário";
    });
  }

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
              const Text(
                "Escolher Foto do Perfil",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: yellow,
                  foregroundColor: Colors.black,
                ),
                onPressed: _pickFromGallery,
                icon: const Icon(Icons.photo),
                label: const Text("Galeria"),
              ),
              const SizedBox(height: 12),
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
            title: const Text(
              "Sair da conta",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text("Tem certeza que deseja sair?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancelar"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: yellow,
                  foregroundColor: Colors.black,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Sair"),
              ),
            ],
          ),
        );

        if (confirm == true) {
          // Limpa os dados salvos ao sair
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$title clicado!")),
        );
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
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                        backgroundColor: yellow,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final avatarRadius = (screenWidth * 0.2).clamp(50.0, 80.0);
    final titleFontSize = (screenWidth * 0.06).clamp(18.0, 28.0);
    final optionFontSize = (screenWidth * 0.045).clamp(14.0, 20.0);
    final spacing = screenHeight * 0.03;

    final menuItems = PageType.values
        .map((type) => MenuItem.fromType(type))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8E1),
      drawer: CustomDrawer(menuItems: menuItems),

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.08),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          decoration: BoxDecoration(
            color: yellow,
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  left: -10,
                  top: -6,
                  bottom: 0,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.pets,
                          size: screenHeight * 0.04, color: Colors.black),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Meu Perfil",
                    style: TextStyle(
                        fontSize: screenHeight * 0.03,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: spacing),
              GestureDetector(
                onTap: () => _showImageOptions(context),
                child: CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                    radius: avatarRadius - 3,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : _selectedAssetImage != null
                        ? AssetImage(_selectedAssetImage!) as ImageProvider
                        : const AssetImage(
                        "lib/assets/images/american.jpg"),
                  ),
                ),
              ),
              SizedBox(height: spacing),
              Text(
                _userName,
                style: TextStyle(
                    fontSize: titleFontSize, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: spacing),
              const Divider(thickness: 1),
              _buildProfileOption(
                  Icons.pets, "Meus PetShops Favoritos", optionFontSize),
              const Divider(thickness: 1),
              _buildProfileOption(
                  Icons.receipt_long, "Meus Pedidos", optionFontSize),
              const Divider(thickness: 1),
              _buildProfileOption(
                  Icons.credit_card, "Formas De Pagamento", optionFontSize),
              const Divider(thickness: 1),
              _buildProfileOption(
                  Icons.notifications, "Notificações", optionFontSize),
              const Divider(thickness: 1),
              _buildProfileOption(Icons.lock, "Alterar Senha", optionFontSize),
              const Divider(thickness: 1),
              _buildProfileOption(Icons.logout, "Sair Da Conta", optionFontSize),
              const Divider(thickness: 1),
              SizedBox(height: spacing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, double fontSize) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500)),
      onTap: () => _handleOptionTap(title),
    );
  }
}