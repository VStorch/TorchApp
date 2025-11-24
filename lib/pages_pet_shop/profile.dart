import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/custom_drawer.dart';
import '../data/pet_shop/pet_shop_information_service.dart';
import '../data/pet_shop/schedule_service.dart';
import '../models/menu_item.dart';
import '../pages/login_page.dart';
import 'package:torch_app/components/custom_drawer_pet_shop.dart';
import 'petshop_info_section.dart';
import 'contact_section.dart';
import 'location_section.dart';
import 'social_media_section.dart';
import 'services_section.dart';
import 'schedule_box.dart';
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
  bool isLoading = false;

  // Form keys para validação
  final GlobalKey<FormState> _petShopFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _userFormKey = GlobalKey<FormState>();

  // Services
  final PetShopInformationService _service = PetShopInformationService();
  final ScheduleService _scheduleService = ScheduleService();

  // --- Controladores do usuário ---
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController =
  TextEditingController(text: "*********");

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
  String? _currentLogoUrl;
  int? _actualPetShopId;

  Map<String, Map<String, String>>? _horarios;
  final List<String> _serviceOptions = [
    "Banho",
    "Tosa",
    "Hotel/creche",
    "Outro"
  ];
  final List<String> _selectedServices = [];
  final TextEditingController _otherServiceController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _siteController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _commercialPhoneController =
  TextEditingController();
  final TextEditingController _commercialEmailController =
  TextEditingController();

  bool _hasLoadedOnce = false;

  @override
  void initState() {
    super.initState();
    print('🟢 initState chamado');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoadedOnce) {
      _hasLoadedOnce = true;
      print('🟢 Carregando dados pela primeira vez');
      _loadAllData();
    }
  }

  // ========== VALIDAÇÕES ==========

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-mail é obrigatório';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'E-mail inválido';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Opcional
    }
    final phoneDigits = value.replaceAll(RegExp(r'[^\d]'), '');
    if (phoneDigits.length < 10 || phoneDigits.length > 11) {
      return 'Telefone inválido (min 10 dígitos)';
    }
    return null;
  }

  String? _validateCEP(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Opcional
    }
    final cepDigits = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cepDigits.length != 8) {
      return 'CEP deve ter 8 dígitos';
    }
    return null;
  }

  String? _validateURL(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null; // Opcional
    }
    try {
      final uri = Uri.parse(value.trim());
      if (!uri.hasScheme || (!uri.isScheme('http') && !uri.isScheme('https'))) {
        return '$fieldName deve começar com http:// ou https://';
      }
    } catch (e) {
      return '$fieldName inválida';
    }
    return null;
  }

  String? _validateInstagram(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Opcional
    }
    // Aceita @usuario ou instagram.com/usuario
    if (!value.startsWith('@') && !value.contains('instagram.com')) {
      return 'Use @usuario ou URL do Instagram';
    }
    return null;
  }

  String? _validateWhatsApp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Opcional
    }
    final digits = value.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length < 10 || digits.length > 13) {
      return 'WhatsApp inválido (com DDI + DDD)';
    }
    return null;
  }

  String? _validatePetShopName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome do Pet Shop é obrigatório';
    }
    if (value.trim().length < 3) {
      return 'Nome deve ter no mínimo 3 caracteres';
    }
    if (value.trim().length > 100) {
      return 'Nome deve ter no máximo 100 caracteres';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value != null && value.trim().length > 500) {
      return 'Descrição deve ter no máximo 500 caracteres';
    }
    return null;
  }

  bool _validateServices() {
    if (_selectedServices.isEmpty && _otherServiceController.text.trim().isEmpty) {
      _showSnackBar('Selecione pelo menos um serviço', Colors.orange);
      return false;
    }
    return true;
  }



  void _showSnackBar(String message, Color backgroundColor) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ✅ Método que carrega tudo
  Future<void> _loadAllData() async {
    print('🔵 _loadAllData iniciado');
    await _loadUserData();
    await _loadPetShopData();
    print('🔵 _loadAllData finalizado');
  }

  // ======= CARREGAR DADOS DO SHARED PREFERENCES =======
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    if (mounted) {
      setState(() {
        final name = prefs.getString('user_name') ?? '';
        final surname = prefs.getString('user_surname') ?? '';
        nameController.text = '$name $surname'.trim();

        phoneController.text = prefs.getString('user_phone') ?? '';
        emailController.text = prefs.getString('user_email') ?? '';
        birthController.text = prefs.getString('user_birth') ?? '';

        cepController.text = prefs.getString('petshop_cep') ?? '';
        estadoController.text = prefs.getString('petshop_state') ?? '';
        cidadeController.text = prefs.getString('petshop_city') ?? '';
        bairroController.text = prefs.getString('petshop_neighborhood') ?? '';
        enderecoController.text = prefs.getString('petshop_street') ?? '';
        numeroController.text = prefs.getString('petshop_number') ?? '';
        complementoController.text = prefs.getString('petshop_complement') ?? '';
      });
    }
  }

  // ======= CARREGAR DADOS DO PET SHOP DO BACKEND =======
  Future<void> _loadPetShopData() async {
    if (!mounted) return;

    setState(() => isLoading = true);

    try {
      final response =
      await _service.getPetShopInformationByUserId(widget.userId);

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];

        if (mounted) {
          setState(() {
            _actualPetShopId = data['id'];
            petNameController.text = data['name'] ?? '';
            petDescriptionController.text = data['description'] ?? '';
            _currentLogoUrl = data['logoUrl'];

            if (data['services'] != null) {
              _selectedServices.clear();
              _selectedServices.addAll(List<String>.from(data['services']));
            }

            _instagramController.text = data['instagram'] ?? '';
            _facebookController.text = data['facebook'] ?? '';
            _siteController.text = data['website'] ?? '';
            _whatsappController.text = data['whatsapp'] ?? '';

            _commercialPhoneController.text = data['commercialPhone'] ?? '';
            _commercialEmailController.text = data['commercialEmail'] ?? '';
          });
        }

        await _loadSchedules();
      }
    } catch (e) {
      print('Pet Shop não encontrado. Pronto para novo cadastro.');
      if (mounted) {
        setState(() {
          _actualPetShopId = null;
        });
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // ======= CARREGAR HORÁRIOS DO BANCO =======
  Future<void> _loadSchedules() async {
    print('🟡 _loadSchedules chamado. PetShopId: $_actualPetShopId');

    if (_actualPetShopId == null || !mounted) {
      print('🔴 _loadSchedules cancelado (petShopId null ou widget desmontado)');
      return;
    }

    try {
      print('🟡 Buscando horários do backend...');
      final response =
      await _scheduleService.getSchedulesByPetShop(_actualPetShopId!);

      print('🟡 Resposta recebida: ${response['success']}');
      print('🟡 Dados: ${response['data']}');

      if (response['success'] == true && response['data'] != null) {
        if (mounted) {
          final horariosCarregados = Map<String, Map<String, String>>.from(response['data']);
          print('✅ Horários carregados com sucesso: $horariosCarregados');

          setState(() {
            _horarios = horariosCarregados;
          });

          print('✅ setState executado. _horarios agora é: $_horarios');
        }
      } else {
        print('⚠️ Resposta sem sucesso ou sem dados');
      }
    } catch (e) {
      print('🔴 ERRO ao carregar horários: $e');
    }
  }

  // ======= SALVAR HORÁRIOS NO BANCO =======
  Future<void> _saveSchedules(
      Map<String, Map<String, String>> schedules) async {
    if (_actualPetShopId == null) {
      _showSnackBar('Salve as informações do Pet Shop primeiro!', Colors.orange);
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await _scheduleService.saveBulkSchedules(
        petShopId: _actualPetShopId!,
        schedules: schedules,
      );

      if (mounted) {
        if (response['success'] == true) {
          _showSnackBar('Horários salvos com sucesso!', Colors.green);

          setState(() {
            _horarios = schedules;
          });
        } else {
          _showSnackBar(
            response['message'] ?? 'Erro ao salvar horários',
            Colors.red,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Erro: ${e.toString()}', Colors.red);
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ======= SALVAR PETSHOP =======
  Future<void> _savePetShopInformation() async {
    // Valida o formulário
    if (!_petShopFormKey.currentState!.validate()) {
      _showSnackBar('Por favor, corrija os erros no formulário', Colors.orange);
      return;
    }

    // Valida serviços
    if (!_validateServices()) {
      return;
    }

    setState(() => isLoading = true);

    try {
      List<String> finalServices = List.from(_selectedServices);
      if (_otherServiceController.text.trim().isNotEmpty &&
          !finalServices.contains(_otherServiceController.text.trim())) {
        finalServices.add(_otherServiceController.text.trim());
      }

      final response = _actualPetShopId != null
          ? await _service.updatePetShopInformation(
        id: _actualPetShopId!,
        name: petNameController.text.trim(),
        description: petDescriptionController.text.trim(),
        services: finalServices,
        userId: widget.userId,
        instagram: _instagramController.text.trim().isEmpty
            ? null
            : _instagramController.text.trim(),
        facebook: _facebookController.text.trim().isEmpty
            ? null
            : _facebookController.text.trim(),
        website: _siteController.text.trim().isEmpty
            ? null
            : _siteController.text.trim(),
        whatsapp: _whatsappController.text.trim().isEmpty
            ? null
            : _whatsappController.text.trim(),
        commercialPhone: _commercialPhoneController.text.trim().isEmpty
            ? null
            : _commercialPhoneController.text.trim(),
        commercialEmail: _commercialEmailController.text.trim().isEmpty
            ? null
            : _commercialEmailController.text.trim(),
      )
          : await _service.createPetShopInformation(
        name: petNameController.text.trim(),
        description: petDescriptionController.text.trim(),
        services: finalServices,
        userId: widget.userId,
        instagram: _instagramController.text.trim().isEmpty
            ? null
            : _instagramController.text.trim(),
        facebook: _facebookController.text.trim().isEmpty
            ? null
            : _facebookController.text.trim(),
        website: _siteController.text.trim().isEmpty
            ? null
            : _siteController.text.trim(),
        whatsapp: _whatsappController.text.trim().isEmpty
            ? null
            : _whatsappController.text.trim(),
        commercialPhone: _commercialPhoneController.text.trim().isEmpty
            ? null
            : _commercialPhoneController.text.trim(),
        commercialEmail: _commercialEmailController.text.trim().isEmpty
            ? null
            : _commercialEmailController.text.trim(),
      );

      if (_petLogo != null && response['success'] == true) {
        final petShopId = response['data']['id'];
        final uploadResponse = await _service.uploadLogo(petShopId, _petLogo!);

        if (uploadResponse['success'] != true) {
          _showSnackBar('Informações salvas, mas erro ao fazer upload da logo', Colors.orange);
        }
      }

      if (mounted) {
        _showSnackBar(
          response['message'] ?? 'Alterações salvas com sucesso!',
          Colors.green,
        );

        await _loadPetShopData();
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Erro ao salvar: ${e.toString()}', Colors.red);
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _pickLogo() async {
    try {
      final pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedImage != null) {
        final file = File(pickedImage.path);
        final fileSize = await file.length();

        // Valida tamanho do arquivo (max 5MB)
        if (fileSize > 5 * 1024 * 1024) {
          _showSnackBar('Imagem muito grande. Máximo 5MB', Colors.orange);
          return;
        }

        setState(() => _petLogo = file);
      }
    } catch (e) {
      _showSnackBar('Erro ao selecionar imagem: ${e.toString()}', Colors.red);
    }
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
                      icon: Icon(Icons.pets,
                          size: barHeight * 0.8, color: Colors.black),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                      color: isPetShopActive
                          ? const Color(0xFFFFF59D)
                          : const Color(0xFFFBF8E1),
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
                      color: isPetShopActive
                          ? const Color(0xFFFBF8E1)
                          : const Color(0xFFFFF59D),
                      border: const Border(
                          bottom:
                          BorderSide(color: Colors.black, width: 1)),
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
                  Form(
                    key: _petShopFormKey,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: bottomBarHeight),
                      child: Column(
                        children: [
                          PetShopInfoSection(
                            nameController: petNameController,
                            descriptionController:
                            petDescriptionController,
                            petLogo: _petLogo,
                            pickLogo: _pickLogo,
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          ScheduleBox(
                            schedules: _horarios,
                            onEdit: (result) async {
                              if (result != null && mounted) {
                                final newSchedules =
                                Map<String, Map<String, String>>.from(
                                    result as Map);

                                final merged = {
                                  ...?_horarios,
                                  ...newSchedules
                                };

                                setState(() {
                                  _horarios = merged;
                                });

                                await _saveSchedules(merged);
                              }
                            },
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          ServicesSection(
                            serviceOptions: _serviceOptions,
                            selectedServices: _selectedServices,
                            otherServiceController:
                            _otherServiceController,
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          SocialMediaSection(
                            instagramController: _instagramController,
                            facebookController: _facebookController,
                            siteController: _siteController,
                            whatsappController: _whatsappController,
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          ContactSection(
                            phoneController: _commercialPhoneController,
                            emailController: _commercialEmailController,
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          LocationSection(
                            cepController: cepController,
                            stateController: estadoController,
                            cityController: cidadeController,
                            neighborhoodController: bairroController,
                            streetController: enderecoController,
                            numberController: numeroController,
                            addressComplementController:
                            complementoController,
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
                                  side: const BorderSide(
                                      color: Colors.black, width: 1),
                                ),
                              ),
                              onPressed:
                              isLoading ? null : _savePetShopInformation,
                              child: isLoading
                                  ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2),
                              )
                                  : const Text(
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
                  ),
                if (!isPetShopActive)
                  Form(
                    key: _userFormKey,
                    child: UserTab(
                      nameController: nameController,
                      phoneController: phoneController,
                      birthController: birthController,
                      emailController: emailController,
                      passwordController: passwordController,
                    ),
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

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    birthController.dispose();
    emailController.dispose();
    passwordController.dispose();
    cepController.dispose();
    estadoController.dispose();
    cidadeController.dispose();
    bairroController.dispose();
    enderecoController.dispose();
    numeroController.dispose();
    complementoController.dispose();
    petNameController.dispose();
    petDescriptionController.dispose();
    _otherServiceController.dispose();
    _instagramController.dispose();
    _facebookController.dispose();
    _siteController.dispose();
    _whatsappController.dispose();
    _commercialPhoneController.dispose();
    _commercialEmailController.dispose();
    super.dispose();
  }
}