import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:image_picker/image_picker.dart';
import 'package:torch_app/pages/login_page.dart';
import 'package:torch_app/pages_pet_shop/schedulePage.dart';
import '../components/CustomDrawer.dart';
import '../models/menu_item.dart';
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

  // horários do pet shop
  Map<String, Map<String, String>>? _horarios;

  // serviços oferecidos
  final List<String> _serviceOptions = [
    "Banho",
    "Tosa",
    "Hotel/creche",
    "Outro",
  ];
  final List<String> _selectedServices = [];
  final TextEditingController _otherServiceController = TextEditingController();

  // redes sociais
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _siteController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();

  Future<void> _pickLogo() async {
    final XFile? pickedImage =
    await _picker.pickImage(source: ImageSource.gallery);
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
          MenuItem(
              title: "Início",
              icon: Icons.home,
              destinationPage: const HomePagePetShop()),
          MenuItem(
              title: "Perfil",
              icon: Icons.person,
              destinationPage: const Profile()),
          MenuItem(
              title: "Serviços",
              icon: Icons.build,
              destinationPage: const Services()),
          MenuItem(
              title: "Avaliações",
              icon: Icons.star,
              destinationPage: const Reviews()),
          MenuItem(
              title: "Promoções",
              icon: Icons.local_offer,
              destinationPage: const Promotions()),
          MenuItem(
              title: "Forma de pagamento",
              icon: Icons.credit_card,
              destinationPage: const PaymentMethod()),
          MenuItem(
              title: "Configurações",
              icon: Icons.settings,
              destinationPage: const Settings()),
          MenuItem(
              title: "Sair",
              icon: Icons.logout,
              destinationPage: const LoginPage()),
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
                        icon: const Icon(Icons.pets,
                            size: 38, color: Colors.black),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 110),
                const Text(
                  "Pefil",
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
                            color: isPetShopActive
                                ? const Color(0xFFFFF59D)
                                : const Color(0xFFFBF8E1),
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
                            color: isPetShopActive
                                ? const Color(0xFFFBF8E1)
                                : const Color(0xFFFFF59D),
                            border: const Border(
                              bottom:
                              BorderSide(color: Colors.black, width: 1),
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
              Expanded(
                child: isPetShopActive
                    ? SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: _buildPetShopTab(context),
                )
                    : _buildUserTab(context),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(height: 54, color: yellow),
          ),
        ],
      ),
    );
  }

  // ------------------ ABA PET SHOP ------------------
  Widget _buildPetShopTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: GestureDetector(
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
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildPetShopInfo(),
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
            child: _horarios == null
                ? ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SchedulePage()),
                );
                if (result != null && mounted) {
                  setState(() {
                    _horarios = Map<String, Map<String, String>>.from(
                        result as Map);
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF4E04D),
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 16),
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
            )
                : _buildHorarioBox(),
          ),
          const SizedBox(height: 30),
          _buildWideLine(context),
          const SizedBox(height: 20),
          _buildServicesSection(),
          const SizedBox(height: 30),
          _buildWideLine(context),
          const SizedBox(height: 20),
          _buildSocialMediaSection(),
          const SizedBox(height: 30),
          _buildWideLine(context),
          const SizedBox(height: 20),
          _buildContactSection(),
          const SizedBox(height: 30),
          _buildWideLine(context),
          const SizedBox(height: 20),
          _buildLocationSection(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ------------------ WIDGET PET SHOP INFO COM BORDA ------------------
  Widget _buildPetShopInfo() {
    return Center(
      child: Container(
        width: 380, // alinhado com outras seções
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDE7), // fundo amarelo claro, igual outras seções
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.black, width: 1.2), // borda preta
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Informações do Pet Shop",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLabel("Nome do Pet Shop:"),
            TextField(
              controller: petNameController,
              decoration: InputDecoration(
                hintText: "Digite o nome do pet shop",
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),
            _buildLabel("Descrição:"),
            TextField(
              controller: petDescriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Escreva uma breve descrição",
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------ CONTATO ------------------
  Widget _buildContactSection() {
    final TextEditingController cnpjController =
    TextEditingController(text: "73.233.352/0001-16");
    final TextEditingController telefoneController =
    TextEditingController(text: "(47)99745-6464");
    final TextEditingController emailController =
    TextEditingController(text: "leonardo@gmail.com");

    return Center(
      child: Container(
        width: 380,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDE7),
          borderRadius: BorderRadius.circular(16),
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
            const Center(
              child: Text(
                "Contato",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLabel("Cnpj:"),
            _buildTextField(cnpjController),
            _buildLabel("Telefone comercial:"),
            _buildTextField(telefoneController),
            _buildLabel("Email comercial:"),
            _buildTextField(emailController),
          ],
        ),
      ),
    );
  }
  // ------------------ LOCALIZAÇÃO ------------------
  Widget _buildLocationSection() {
    final TextEditingController cepController =
    TextEditingController(text: "89110-890");
    final TextEditingController estadoController =
    TextEditingController(text: "SC");
    final TextEditingController cidadeController =
    TextEditingController(text: "Gaspar");
    final TextEditingController bairroController =
    TextEditingController(text: "Zimmermann");
    final TextEditingController enderecoController =
    TextEditingController(text: "Rua das Flores");
    final TextEditingController numeroController =
    TextEditingController(text: "54");
    final TextEditingController complementoController =
    TextEditingController(text: "Casa amarela");

    return Center(
      child: Container(
        width: 380,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDE7),
          borderRadius: BorderRadius.circular(16),
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
            const Center(
              child: Text(
                "Localização",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildLabel("CEP:"),
            _buildTextField(cepController),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Estado:"),
                      _buildTextField(estadoController),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Cidade:"),
                      _buildTextField(cidadeController),
                    ],
                  ),
                ),
              ],
            ),

            _buildLabel("Bairro:"),
            _buildTextField(bairroController),

            _buildLabel("Endereço:"),
            _buildTextField(enderecoController),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Número:"),
                      _buildTextField(numeroController),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Complemento:"),
                      _buildTextField(complementoController),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF4E04D),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
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
          ],
        ),
      ),
    );
  }
  // ------------------ REDES SOCIAIS ------------------
  Widget _buildSocialMediaSection() {
    return Center(
      child: Container(
        width: 380,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDE7),
          borderRadius: BorderRadius.circular(16),
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
            const Center(
              child: Text(
                "Redes sociais",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLabel("Instagram:"),
            _buildTextField(_instagramController, hint: "@seudopetshop"),
            _buildLabel("Facebook:"),
            _buildTextField(_facebookController,
                hint: "facebook.com/seupetshop"),
            _buildLabel("Site (opcional):"),
            _buildTextField(_siteController, hint: "www.seupetshop.com.br"),
            _buildLabel("WhatsApp comercial:"),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(_whatsappController,
                      hint: "+55 47 99999-9999"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF4E04D),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: const Text(
                    "Testar link",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ------------------ SEÇÃO DE SERVIÇOS ------------------
  Widget _buildServicesSection() {
    return Center(
      child: Container(
        width: 380,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDE7),
          borderRadius: BorderRadius.circular(16),
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
            const Center(
              child: Text(
                "Serviços oferecidos",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ..._serviceOptions.map((option) => _buildServiceCheckbox(option)),
            if (_selectedServices.contains("Outro")) ...[
              const SizedBox(height: 10),
              TextField(
                controller: _otherServiceController,
                decoration: InputDecoration(
                  hintText: "Digite o outro serviço...",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide:
                    const BorderSide(color: Colors.black, width: 1),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCheckbox(String option) {
    return CheckboxListTile(
      title: Text(option,
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.w500)),
      activeColor: const Color(0xFFF4E04D),
      value: _selectedServices.contains(option),
      onChanged: (bool? value) {
        setState(() {
          if (value == true) {
            _selectedServices.add(option);
          } else {
            _selectedServices.remove(option);
          }
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  // ------------------ HORÁRIOS ------------------
  Widget _buildHorarioBox() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9C4),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(color: Colors.black54, width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.access_time, color: Colors.black87, size: 24),
                  SizedBox(width: 8),
                  Text(
                    "Horários Cadastrados",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(thickness: 1, color: Colors.black26),
              const SizedBox(height: 4),
              ..._horarios!.entries.map((entry) {
                final dia = entry.key;
                final abre = entry.value['abre'] ?? '';
                final fecha = entry.value['fecha'] ?? '';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 18, color: Colors.black54),
                          const SizedBox(width: 8),
                          Text(
                            dia,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.schedule,
                              size: 18, color: Colors.black54),
                          const SizedBox(width: 6),
                          Text(
                            "$abre - $fecha",
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black87),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SchedulePage()),
            );
            if (result != null && mounted) {
              setState(() {
                _horarios = Map<String, Map<String, String>>.from(result as Map);
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF4E04D),
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 14),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 0,
          ),
          child: const Text(
            "Editar horários",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // ------------------ USUÁRIO ------------------
  Widget _buildUserTab(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16),
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
                    _buildTextField(passwordController,
                        readOnly: true, obscure: true),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
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
                    const SizedBox(height: 0),
                    Center(
                      child: Lottie.asset(
                        'lib/assets/images/CatLove.json',
                        width: 200,
                        repeat: true,
                        animate: true,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ------------------ WIDGETS AUXILIARES ------------------
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 5),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller,
      {String? hint, bool readOnly = false, bool obscure = false}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint ?? "",
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.black, width: 1),
        ),
      ),
    );
  }

  Widget _buildWideLine(BuildContext context) {
    return Container(
      height: 1.5,
      width: MediaQuery.of(context).size.width * 0.85,
      color: Colors.black,
      margin: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}
// Linha 1000