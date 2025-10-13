import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/CustomDrawer.dart';
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

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    try {
      final pets = await PetService.getPets();
      setState(() {
        _pets = pets;
      });
    } catch (e) {
      debugPrint('Erro ao carregar pets: $e');
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
      body: SingleChildScrollView(
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
            Text("Raça: ${pet.breed}"),
            Text("Espécie: ${pet.species}"),
            Text("Peso: ${pet.weight} kg"),
            Text("Nascimento: ${DateFormat('dd/MM/yyyy').format(pet.birthDate)}"),
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
                    if (pet.id != null) {
                      final success = await PetService.deletePet(pet.id!);
                      if (success) _loadPets();
                    }
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

  void _showAddPetDialog(BuildContext context) {
    final nameController = TextEditingController();
    final breedController = TextEditingController();
    final speciesController = TextEditingController();
    final weightController = TextEditingController();
    DateTime birthDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => Dialog(
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
                      color: Colors.black),
                ),
                const SizedBox(height: 20),
                _buildInputField("Nome", nameController),
                const SizedBox(height: 12),
                _buildInputField("Raça", breedController),
                const SizedBox(height: 12),
                _buildInputField("Espécie", speciesController),
                const SizedBox(height: 12),
                _buildInputField("Peso (kg)", weightController,
                    keyboard: TextInputType.number),
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
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFFEBDD6C),
                              onPrimary: Colors.black,
                              surface: Color(0xFFF6F0D1),
                              onSurface: Colors.black,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      birthDate = picked;
                    }
                  },
                  icon: const Icon(Icons.calendar_month),
                  label: const Text("Selecionar Data de Nascimento"),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancelar"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEBDD6C),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        final pet = Pet(
                          nameController.text,
                          breedController.text,
                          speciesController.text,
                          double.tryParse(weightController.text) ?? 0.0,
                          birthDate,
                        );
                        final success = await PetService.addPet(pet);
                        if (success) _loadPets();
                        Navigator.pop(context);
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
    );
  }

  void _showEditPetDialog(BuildContext context, Pet pet) {
    final nameController = TextEditingController(text: pet.name);
    final breedController = TextEditingController(text: pet.breed);
    final speciesController = TextEditingController(text: pet.species);
    final weightController =
    TextEditingController(text: pet.weight.toString());
    DateTime birthDate = pet.birthDate;

    showDialog(
      context: context,
      builder: (context) => Dialog(
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
                      color: Colors.black),
                ),
                const SizedBox(height: 20),
                _buildInputField("Nome", nameController),
                const SizedBox(height: 12),
                _buildInputField("Raça", breedController),
                const SizedBox(height: 12),
                _buildInputField("Espécie", speciesController),
                const SizedBox(height: 12),
                _buildInputField("Peso (kg)", weightController,
                    keyboard: TextInputType.number),
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
                    );
                    if (picked != null) {
                      birthDate = picked;
                    }
                  },
                  icon: const Icon(Icons.calendar_month),
                  label: const Text("Selecionar Data de Nascimento"),
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
                        final petAtualizado = Pet(
                          nameController.text,
                          breedController.text,
                          speciesController.text,
                          double.tryParse(weightController.text) ?? 0.0,
                          birthDate,
                          id: pet.id, // <-- id nomeado
                        );
                        final success =
                        await PetService.updatePet(petAtualizado);
                        if (success) _loadPets();
                        Navigator.pop(context);
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
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text}) {
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
      ),
    );
  }
}
