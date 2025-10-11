import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:image_picker/image_picker.dart';
import 'package:torch_app/pages_pet_shop/schedulePage.dart';
import '../components/CustomDrawer.dart';
import '../models/menu_item.dart';
import 'home_page_pet_shop.dart';
import 'services.dart';
import 'reviews.dart';
import 'promotions.dart';
import 'payment_method.dart';
import 'settings.dart';
import 'leave.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isPetShopActive = true;

  final Color yellow = const Color(0xFFF4E04D);
  final Color lightYellow = const Color(0xFFFFF9C4);

  // controladores usuário
  final TextEditingController nameController =
  TextEditingController(text: "Leonardo Cortelim Dos Santos");
  final TextEditingController phoneController =
  TextEditingController(text: "(47)99745-6526");
  final TextEditingController birthController =
  TextEditingController(text: "18/06/2008");
  final TextEditingController emailController =
  TextEditingController(text: "leonardo@gmail.com");
  final TextEditingController passwordController =
  TextEditingController(text: "*********");

  // controladores Pet Shop
  final TextEditingController petNameController = TextEditingController();
  final TextEditingController petDescriptionController = TextEditingController();

  // imagem do pet shop
  File? _petLogo;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickLogo() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _petLogo = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        menuItems: [
          MenuItem(title: "Início", icon: Icons.home, destinationPage: const HomePagePetShop()),
          MenuItem(title: "Perfil", icon: Icons.person, destinationPage: const Profile()),
          MenuItem(title: "Serviços", icon: Icons.build, destinationPage: const Services()),
          MenuItem(title: "Avaliações", icon: Icons.star, destinationPage: const Reviews()),
          MenuItem(title: "Promoções", icon: Icons.local_offer, destinationPage: const Promotions()),
          MenuItem(title: "Forma de pagamento", icon: Icons.credit_card, destinationPage: const PaymentMethod()),
          MenuItem(title: "Configurações", icon: Icons.settings, destinationPage: const Settings()),
          MenuItem(title: "Sair", icon: Icons.logout, destinationPage: const Leave()),
        ],
      ),
      backgroundColor: const Color(0xFFFBF8E1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          height: 90,
          color: yellow,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Builder(
                  builder: (context) {
                    return Transform.translate(
                      offset: const Offset(-5, 0),
                      child: IconButton(
                        icon: const Icon(Icons.pets, size: 38, color: Colors.black),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
                const Text(
                  "Olá Leonardo!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // 🔹 Abas
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isPetShopActive = true),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isPetShopActive ? const Color(0xFFFFF59D) : const Color(0xFFFBF8E1),
                            border: const Border(
                              right: BorderSide(color: Colors.black, width: 1),
                              bottom: BorderSide(color: Colors.black, width: 1),
                            ),
                          ),
                          child: const Text(
                            "Pet Shop",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isPetShopActive = false),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isPetShopActive ? const Color(0xFFFBF8E1) : const Color(0xFFFFF59D),
                            border: const Border(
                              bottom: BorderSide(color: Colors.black, width: 1),
                            ),
                          ),
                          child: const Text(
                            "Usuário",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //  Conteúdo
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: isPetShopActive ? _buildPetShopTab(context) : _buildUserTab(context),
                ),
              ),
            ],
          ),
          // 🔹 Faixa amarela inferior
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(height: 54, color: yellow),
          ),
        ],
      ),
    );
  }

  // Aba PET SHOP
  Widget _buildPetShopTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Logo e botão alterar
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                      image: DecorationImage(
                        image: _petLogo != null
                            ? FileImage(_petLogo!) as ImageProvider
                            : const AssetImage('lib/assets/images/cat_logo.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _pickLogo,
                child: const Text(
                  "Alterar logo",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildWideLine(context),
          const SizedBox(height: 20),
          _buildLabel("Nome pet shop:"),
          _buildTextField(petNameController),
          _buildLabel("Descrição:"),
          _buildTextField(petDescriptionController),
          const SizedBox(height: 20),
          _buildWideLine(context),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "Horários",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SchedulePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF4E04D),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Cadastrar Horários",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildWideLine(context),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // 🔹 Aba USUÁRIO
  Widget _buildUserTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildLabel("Nome Completo:"),
          _buildTextField(nameController),
          _buildLabel("Celular:"),
          _buildTextField(phoneController),
          _buildLabel("Data de nascimento:"),
          _buildTextField(birthController, readOnly: true),
          _buildLabel("E-mail:"),
          _buildTextField(emailController),
          _buildLabel("Senha"),
          _buildTextField(passwordController, readOnly: true, obscure: true),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () {},
            child: const Text(
              "Alterar senha?",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 13,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: 25),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF4E04D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              onPressed: () {},
              child: const Text(
                "Salvar Alterações",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Center(
            child: Lottie.asset(
              'lib/assets/images/CatLove.json',
              width: 172,
              repeat: true,
              animate: true,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  //  Campo padrão
  Widget _buildTextField(TextEditingController controller,
      {bool obscure = false, bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        readOnly: readOnly,
        style: TextStyle(
          fontSize: 14,
          color: readOnly ? Colors.grey[800] : Colors.black,
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          filled: true,
          fillColor: readOnly ? lightYellow : Colors.white,
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  // 🔹 Label
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildWideLine(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 2,
        color: Colors.black,
      ),
    );
  }
}
