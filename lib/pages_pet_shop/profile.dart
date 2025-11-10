import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ADICIONAR
import '../components/CustomDrawer.dart';
import '../models/menu_item.dart';
import '../pages/login_page.dart';
import 'package:torch_app/components/custom_drawer_pet_shop.dart';
import 'petshop_info_section.dart';
import 'contact_section.dart';
import 'location_section.dart';
import 'social_media_section.dart';
import 'services_section.dart';
import 'horario_box.dart';
import 'user_tab.dart';

class Profile extends StatefulWidget {
  final int petShopId;
  final int userId;

  const Profile({super.key, required this.petShopId, required this.userId});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isPetShopActive = true;
  final Color yellow = const Color(0xFFF4E04D);

  // --- Controladores do usuário ---
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController(text: "*********");

  // --- Controladores de localização ---
  final TextEditingController cepController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController complementoController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    _loadUserData(); // CARREGAR DADOS AO INICIAR
  }

  // ======= CARREGAR DADOS DO SHARED PREFERENCES =======
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      // Dados do usuário
      final name = prefs.getString('user_name') ?? '';
      final surname = prefs.getString('user_surname') ?? '';
      nameController.text = '$name $surname'.trim();

      phoneController.text = prefs.getString('user_phone') ?? '';
      emailController.text = prefs.getString('user_email') ?? '';
      birthController.text = prefs.getString('user_birth') ?? '';

      // Dados do endereço do Pet Shop
      cepController.text = prefs.getString('petshop_cep') ?? '';
      estadoController.text = prefs.getString('petshop_state') ?? '';
      cidadeController.text = prefs.getString('petshop_city') ?? '';
      bairroController.text = prefs.getString('petshop_neighborhood') ?? '';
      enderecoController.text = prefs.getString('petshop_street') ?? '';
      numeroController.text = prefs.getString('petshop_number') ?? '';
      complementoController.text = prefs.getString('petshop_complement') ?? '';

      // CNPJ será carregado automaticamente pelo ContactSection
    });
  }
  // ====================================================

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
      drawer: CustomDrawerPetShop(
          petShopId: widget.petShopId,
          userId: widget.userId,
      ),
      backgroundColor: const Color(0xFFFBF8E1),

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

          Expanded(
            child: Stack(
              children: [
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

                if (!isPetShopActive)
                  UserTab(
                    nameController: nameController,
                    phoneController: phoneController,
                    birthController: birthController,
                    emailController: emailController,
                    passwordController: passwordController,
                  ),

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