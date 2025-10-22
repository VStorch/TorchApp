import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/CustomDrawer.dart';
import '../data/pet/pet.dart';
import '../data/pet/pet_service.dart';
import '../models/menu_item.dart';
import '../models/page_type.dart';

class MyPetsPage extends StatefulWidget {
  final int currentUserId; // ID do usuário logado
  const MyPetsPage({super.key, required this.currentUserId});

  @override
  State<MyPetsPage> createState() => _MyPetsPageState();
}

class _MyPetsPageState extends State<MyPetsPage> {
  List<Pet> _pets = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    setState(() => _loading = true);
    try {
      final pets = await PetService.getPets();
      setState(() => _pets = pets.where((p) => p.userId == widget.currentUserId).toList());
    } catch (e) {
      debugPrint("Erro ao carregar pets: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8E1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEBDD6C),
        toolbarHeight: 90,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.pets),
            iconSize: 35,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: SizedBox(
          height: 50,
          child: TextField(
            style: const TextStyle(fontSize: 20),
            decoration: InputDecoration(
              hintText: 'Busque um PetShop',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFFBF8E1),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
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

  // Função para tema customizado do DatePicker
  ThemeData _datePickerTheme(BuildContext context) {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: const Color(0xFFFFF200), // amarelo forte para header e seleção
        onPrimary: Colors.black, // texto preto no header e botões OK/Cancelar
        onSurface: Colors.black, // texto preto no calendário
        surface: const Color(0xFFFFFDD2), // fundo do calendário
      ),
      dialogBackgroundColor: const Color(0xFFFFFDD2), // fundo do dialog
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.black, // texto preto para botões Cancelar e OK
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
                              widget.currentUserId,
                            );
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
                              widget.currentUserId,
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
