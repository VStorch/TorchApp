import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/custom_drawer.dart';
import '../data/pet/pet.dart';
import '../data/pet/pet_service.dart';
import '../models/menu_item.dart';
import '../models/page_type.dart';

class MyPetsPage extends StatefulWidget {
  const MyPetsPage({super.key});

  @override
  State<MyPetsPage> createState() => _MyPetsPageState();
}

class _MyPetsPageState extends State<MyPetsPage> {
  List<Pet> _pets = [];
  bool _loading = true;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserAndPets();
  }

  // Busca o userId do SharedPreferences
  Future<void> _loadUserAndPets() async {
    setState(() => _loading = true);

    try {
      // Buscar userId do SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId == null) {
        debugPrint("ERRO: Usuário não está logado!");
        return;
      }

      setState(() => _currentUserId = userId);
      debugPrint("UserId carregado: $userId");

      // Agora carregar os pets
      await _loadPets();

    } catch (e) {
      debugPrint("Erro ao carregar dados: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _loadPets() async {
    if (_currentUserId == null) return;

    try {
      final pets = await PetService.getPets();
      debugPrint("=== DEBUG PETS ===");
      debugPrint("CurrentUserId: $_currentUserId");
      debugPrint("Total pets carregados: ${pets.length}");
      for (var pet in pets) {
        debugPrint("Pet: ${pet.name}, UserId: ${pet.userId}");
      }
      final filteredPets = pets.where((p) => p.userId == _currentUserId).toList();
      debugPrint("Pets filtrados para este usuário: ${filteredPets.length}");
      setState(() => _pets = filteredPets);
    } catch (e) {
      debugPrint("Erro ao carregar pets: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Se ainda não carregou o userId, mostra loading
    if (_currentUserId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final menuItems = PageType.values
        .map((type) => MenuItem.fromType(type))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8E1),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
          decoration: BoxDecoration(
            color: const Color(0xFFF4E04D),
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
                          size: MediaQuery.of(context).size.height * 0.04,
                          color: Colors.black),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Meus Pets",
                    style: TextStyle(
                      fontSize: (MediaQuery.of(context).size.width * 0.06).clamp(18.0, 28.0),
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

      drawer: CustomDrawer(menuItems: menuItems),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: _pets.isEmpty
              ? [_buildEmptyCard()]
              : _pets.map((pet) => _buildPetCard(pet)).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFEBDD6C),
        onPressed: () => _showAddPetDialog(context),
        child: const Icon(Icons.add, color: Colors.black, size: 32),
      ),
    );
  }

  Widget _buildPetCard(Pet pet) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFFFFF8C6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.pets, size: 28),
                const SizedBox(width: 8),
                Text(pet.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 10),
            Text("Espécie: ${pet.species}"),
            Text("Raça: ${pet.breed}"),
            Text("Peso: ${pet.weight} kg"),
            Text(
              "Nascimento: ${DateFormat('dd/MM/yyyy').format(pet.birthDate)}",
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () => _showEditPetDialog(context, pet),
                  child: const Text("Editar"),
                ),
                OutlinedButton(
                  onPressed: () async {
                    final success = await PetService.deletePet(pet.id!);
                    if (success) _loadPets();
                  },
                  child: const Text("Excluir"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFFFFF8C6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.pets, size: 28),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    "Você ainda não tem nenhum pet cadastrado?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text("Toque no botão abaixo para adicionar um amigo!"),
            const SizedBox(height: 16),
            Center(
              child: OutlinedButton(
                onPressed: () => _showAddPetDialog(context),
                child: const Text("Cadastrar"),
              ),
            )
          ],
        ),
      ),
    );
  }

  ThemeData _datePickerTheme(BuildContext context) {
    return ThemeData(
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFFFF200),
        onPrimary: Colors.black,
        onSurface: Colors.black,
        surface: Color(0xFFFFFDD2),
      ),
      dialogBackgroundColor: const Color(0xFFFFFDD2),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
        ),
      ),
    );
  }

  void _showAddPetDialog(BuildContext context) {
    final nameController = TextEditingController();
    final breedController = TextEditingController();
    final speciesController = TextEditingController();
    final weightController = TextEditingController();
    DateTime birthDate = DateTime.now();

    String? nameError, breedError, speciesError, weightError, birthDateError;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color(0xFFF6F0D1),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Cadastrar Pet",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildInputField("Nome", nameController, errorText: nameError),
                  const SizedBox(height: 12),
                  _buildInputField("Espécie", speciesController, errorText: speciesError),
                  const SizedBox(height: 12),
                  _buildInputField("Raça", breedController, errorText: breedError),
                  const SizedBox(height: 12),
                  _buildInputField("Peso (kg)", weightController,
                      keyboard: TextInputType.number, errorText: weightError),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEBDD6C),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: birthDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: _datePickerTheme(context),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          birthDate = picked;
                          birthDateError = null;
                        });
                      }
                    },
                    icon: const Icon(Icons.calendar_month),
                    label: const Text("Selecionar Data de Nascimento"),
                  ),
                  if (birthDateError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 8),
                      child: Text(
                        birthDateError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancelar"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEBDD6C),
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () async {
                          setState(() {
                            nameError = nameController.text.isEmpty ? 'Nome é obrigatório' : null;
                            speciesError = speciesController.text.isEmpty ? 'Espécie é obrigatória' : null;
                            breedError = breedController.text.isEmpty ? 'Raça é obrigatória' : null;
                            final weight = double.tryParse(weightController.text);
                            weightError = (weight == null || weight <= 0) ? 'Peso deve ser maior que zero' : null;
                            birthDateError = birthDate.isAfter(DateTime.now()) ? 'Data inválida' : null;
                          });

                          if ([nameError, speciesError, breedError, weightError, birthDateError].every((e) => e == null)) {
                            final pet = Pet(
                              nameController.text,
                              breedController.text,
                              speciesController.text,
                              double.parse(weightController.text),
                              birthDate,
                              _currentUserId!,
                            );
                            debugPrint("=== CRIANDO PET ===");
                            debugPrint("UserId sendo enviado: $_currentUserId");
                            debugPrint("Pet: ${pet.toJson()}");
                            final success = await PetService.addPet(pet);
                            if (success) {
                              _loadPets();
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Erro ao cadastrar pet')),
                              );
                            }
                          }
                        },
                        child: const Text("Salvar"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditPetDialog(BuildContext context, Pet pet) {
    final nameController = TextEditingController(text: pet.name);
    final breedController = TextEditingController(text: pet.breed);
    final speciesController = TextEditingController(text: pet.species);
    final weightController = TextEditingController(text: pet.weight.toString());
    DateTime birthDate = pet.birthDate;

    String? nameError, breedError, speciesError, weightError, birthDateError;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color(0xFFF6F0D1),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Editar Pet",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildInputField("Nome", nameController, errorText: nameError),
                  const SizedBox(height: 12),
                  _buildInputField("Espécie", speciesController, errorText: speciesError),
                  const SizedBox(height: 12),
                  _buildInputField("Raça", breedController, errorText: breedError),
                  const SizedBox(height: 12),
                  _buildInputField("Peso (kg)", weightController,
                      keyboard: TextInputType.number, errorText: weightError),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEBDD6C),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: birthDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: _datePickerTheme(context),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          birthDate = picked;
                          birthDateError = null;
                        });
                      }
                    },
                    icon: const Icon(Icons.calendar_month),
                    label: const Text("Selecionar Data de Nascimento"),
                  ),
                  if (birthDateError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 8),
                      child: Text(
                        birthDateError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancelar"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEBDD6C),
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () async {
                          setState(() {
                            nameError = nameController.text.isEmpty ? 'Nome é obrigatório' : null;
                            speciesError = speciesController.text.isEmpty ? 'Espécie é obrigatória' : null;
                            breedError = breedController.text.isEmpty ? 'Raça é obrigatória' : null;
                            final weight = double.tryParse(weightController.text);
                            weightError = (weight == null || weight <= 0) ? 'Peso deve ser maior que zero' : null;
                            birthDateError = birthDate.isAfter(DateTime.now()) ? 'Data inválida' : null;
                          });

                          if ([nameError, speciesError, breedError, weightError, birthDateError].every((e) => e == null)) {
                            final petAtualizado = Pet(
                              nameController.text,
                              breedController.text,
                              speciesController.text,
                              double.parse(weightController.text),
                              birthDate,
                              _currentUserId!,
                              id: pet.id,
                            );
                            final success = await PetService.updatePet(petAtualizado);
                            if (success) {
                              _loadPets();
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Erro ao atualizar pet')),
                              );
                            }
                          }
                        },
                        child: const Text("Salvar"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text, String? errorText}) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFFFF8C6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        errorText: errorText,
      ),
    );
  }
}