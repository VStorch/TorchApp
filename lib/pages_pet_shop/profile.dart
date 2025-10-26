import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../components/CustomDrawer.dart';
import '../models/menu_item.dart';
import '../pages/login_page.dart';
import 'petshop_info_section.dart';
import 'contact_section.dart';
import 'location_section.dart';
import 'social_media_section.dart';
import 'services_section.dart';
import 'horario_box.dart';
import 'user_tab.dart';
import 'home_page_pet_shop.dart';
import 'services.dart';
import 'reviews.dart';
import 'promotions.dart';
import 'payment_method.dart';
import 'settings.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isPetShopActive = true;
  final Color yellow = const Color(0xFFF4E04D);

  // --- Controladores do usuário ---
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

  // --- Controladores de localização ---
  final TextEditingController cepController =
  TextEditingController(text: "89200-000");
  final TextEditingController estadoController =
  TextEditingController(text: "SC");
  final TextEditingController cidadeController =
  TextEditingController(text: "Joinville");
  final TextEditingController bairroController =
  TextEditingController(text: "Centro");
  final TextEditingController enderecoController =
  TextEditingController(text: "Rua dos Pets");
  final TextEditingController numeroController =
  TextEditingController(text: "123");
  final TextEditingController complementoController =
  TextEditingController(text: "Próximo ao mercado");

  // --- Controladores de PetShop ---
  final TextEditingController petNameController = TextEditingController();
  final TextEditingController petDescriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _petLogo;

  Map<String, Map<String, String>>? _horarios;
  final List<String> _serviceOptions = ["Banho", "Tosa", "Hotel/creche", "Outro"];
  final List<String> _selectedServices = [];
  final TextEditingController _otherServiceController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _siteController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();

  Future<void> _pickLogo() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) setState(() => _petLogo = File(pickedImage.path));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final barHeight = screenHeight * 0.05;
    final bottomBarHeight = barHeight;

    return Scaffold(
      drawer: CustomDrawer(menuItems: [
        MenuItem(title: "Início", icon: Icons.home, destinationPage: const HomePagePetShop()),
        MenuItem(title: "Perfil", icon: Icons.person, destinationPage: const Profile()),
        MenuItem(title: "Serviços", icon: Icons.build, destinationPage: const Services()),
        MenuItem(title: "Avaliações", icon: Icons.star, destinationPage: const Reviews()),
        MenuItem(title: "Promoções", icon: Icons.local_offer, destinationPage: const Promotions()),
        MenuItem(title: "Forma de pagamento", icon: Icons.credit_card, destinationPage: const PaymentMethod()),
        MenuItem(title: "Configurações", icon: Icons.settings, destinationPage: const Settings()),
        MenuItem(title: "Sair", icon: Icons.logout, destinationPage: const LoginPage()),
      ]),
      backgroundColor: const Color(0xFFFBF8E1),

      // --- AppBar ---
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(barHeight),
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
                      icon: Icon(Icons.pets, size: barHeight * 0.8, color: Colors.black),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Perfil",
                    style: TextStyle(
                      fontSize: barHeight * 0.6,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          // --- Toggle PetShop / Usuário ---
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isPetShopActive = true),
                  child: Container(
                    alignment: Alignment.center,
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: isPetShopActive ? const Color(0xFFFFF59D) : const Color(0xFFFBF8E1),
                      border: const Border(
                        right: BorderSide(color: Colors.black, width: 1),
                        bottom: BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                    child: Text(
                      "Pet Shop",
                      style: TextStyle(
                        fontSize: barHeight * 0.45,
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
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: isPetShopActive ? const Color(0xFFFBF8E1) : const Color(0xFFFFF59D),
                      border: const Border(bottom: BorderSide(color: Colors.black, width: 1)),
                    ),
                    child: Text(
                      "Usuário",
                      style: TextStyle(
                        fontSize: barHeight * 0.45,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // --- Conteúdo ---
          Expanded(
            child: Stack(
              children: [
                // Aba PetShop → scrollável
                if (isPetShopActive)
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: bottomBarHeight),
                    child: Column(
                      children: [
                        PetShopInfoSection(
                          nameController: petNameController,
                          descriptionController: petDescriptionController,
                          petLogo: _petLogo,
                          pickLogo: _pickLogo,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        HorarioBox(
                          horarios: _horarios,
                          onEdit: (result) {
                            if (result != null && mounted) {
                              setState(() {
                                _horarios = Map<String, Map<String, String>>.from(result as Map);
                              });
                            }
                          },
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        ServicesSection(
                          serviceOptions: _serviceOptions,
                          selectedServices: _selectedServices,
                          otherServiceController: _otherServiceController,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        SocialMediaSection(
                          instagramController: _instagramController,
                          facebookController: _facebookController,
                          siteController: _siteController,
                          whatsappController: _whatsappController,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        const ContactSection(),
                        SizedBox(height: screenHeight * 0.03),
                        LocationSection(
                          cepController: cepController,
                          estadoController: estadoController,
                          cidadeController: cidadeController,
                          bairroController: bairroController,
                          enderecoController: enderecoController,
                          numeroController: numeroController,
                          complementoController: complementoController,
                        ),
                        SizedBox(height: screenHeight * 0.03),

                        // --- BOTÃO DE SALVAR ALTERAÇÕES ---
                        SizedBox(
                          width: screenWidth * 0.9,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: yellow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: Colors.black, width: 1),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Alterações salvas com sucesso!")),
                              );
                            },
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
                        SizedBox(height: screenHeight * 0.03),
                      ],
                    ),
                  ),

                // Aba Usuário → fixa, sem scroll
                if (!isPetShopActive)
                  UserTab(
                    nameController: nameController,
                    phoneController: phoneController,
                    birthController: birthController,
                    emailController: emailController,
                    passwordController: passwordController,
                  ),

                // Faixa inferior igual AppBar
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: bottomBarHeight,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBDD6C),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
