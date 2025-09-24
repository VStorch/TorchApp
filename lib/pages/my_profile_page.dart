import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8E1),

      // Barra superior
      appBar: AppBar(
        toolbarHeight: 90,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.pets),
              iconSize: 35,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Container(
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
        backgroundColor: const Color(0xFFEBDD6C),
      ),

      // Menu lateral
      drawer: Drawer(
        backgroundColor: const Color(0xFFEBDD6C),
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFFE8CA42)),
                child: Center(
                  child: Text(
                    "Menu",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(leading: Icon(Icons.home), title: Text("Tela Inicial")),
            ListTile(leading: Icon(Icons.pets), title: Text("Meus Pets")),
            ListTile(
                leading: Icon(Icons.business),
                title: Text("PetShops favoritos")),
            ListTile(
                leading: Icon(Icons.calendar_month),
                title: Text("Meus Agendamentos")),
            ListTile(
                leading: Icon(Icons.local_offer), title: Text("Promoções")),
            ListTile(leading: Icon(Icons.person), title: Text("Meu Perfil")),
            ListTile(leading: Icon(Icons.settings), title: Text("Configurações")),
            ListTile(leading: Icon(Icons.logout), title: Text("Sair")),
            ListTile(leading: Icon(Icons.info), title: Text("Sobre")),
          ],
        ),
      ),

      // Corpo da tela de perfil
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Dados do usuário
            const Text(
              "Leonardo Cortelim",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text("leo.gmail.com",
                style: TextStyle(fontSize: 16, color: Colors.black87)),
            const Text("(47)99678-8765",
                style: TextStyle(fontSize: 16, color: Colors.black87)),
            const Text("Rua Adriano Korman, nº 123 - SC",
                style: TextStyle(fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 20),

            // Lista de opções
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

            // Foto do pet alterável
            GestureDetector(
              onTap: () {
                _showImageOptions(context);
              },
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
