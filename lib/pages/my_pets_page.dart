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

  Future<void> _loadUserAndPets() async {
    setState(() => _loading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId == null) {
        debugPrint("ERRO: Usuário não está logado!");
        return;
      }

      setState(() => _currentUserId = userId);
      debugPrint("UserId carregado: $userId");

      await _loadPets();

    } catch (e) {
      debugPrint("Erro ao carregar dados: $e");
      if (mounted) {
        _showSnackBar('Erro ao carregar dados', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _loadPets() async {
    if (_currentUserId == null) return;

    try {
      final pets = await PetService.getPets();
      debugPrint("=== DEBUG PETS ===");
      debugPrint("CurrentUserId: $_currentUserId");
      debugPrint("Total pets carregados: ${pets.length}");

      final filteredPets = pets.where((p) => p.userId == _currentUserId).toList();
      debugPrint("Pets filtrados para este usuário: ${filteredPets.length}");

      if (mounted) {
        setState(() => _pets = filteredPets);
      }
    } catch (e) {
      debugPrint("Erro ao carregar pets: $e");
      if (mounted) {
        _showSnackBar('Erro ao carregar pets', isError: true);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Calcula a idade do pet
  String _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    final difference = now.difference(birthDate);
    final years = (difference.inDays / 365).floor();
    final months = ((difference.inDays % 365) / 30).floor();

    if (years > 0) {
      return years == 1 ? '1 ano' : '$years anos';
    } else if (months > 0) {
      return months == 1 ? '1 mês' : '$months meses';
    } else {
      return '${difference.inDays} dias';
    }
  }

  @override
  Widget build(BuildContext context) {
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
          : RefreshIndicator(
        onRefresh: _loadPets,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: _pets.isEmpty
                ? [_buildEmptyCard()]
                : _pets.map((pet) => _buildPetCard(pet)).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFEBDD6C),
        onPressed: () => _showAddPetDialog(context),
        tooltip: 'Adicionar Pet',
        child: const Icon(Icons.add, color: Colors.black, size: 32),
      ),
    );
  }

  Widget _buildPetCard(Pet pet) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFFFFF8C6),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBDD6C),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.pets, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        _calculateAge(pet.birthDate),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow(Icons.category, "Espécie", pet.species),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.loyalty, "Raça", pet.breed),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.monitor_weight, "Peso", "${pet.weight} kg"),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.cake,
              "Nascimento",
              DateFormat('dd/MM/yyyy').format(pet.birthDate),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _showEditPetDialog(context, pet),
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text("Editar"),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => _confirmDeletePet(context, pet),
                  icon: const Icon(Icons.delete, size: 18),
                  label: const Text("Excluir"),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade700),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }

  // Diálogo de confirmação para exclusão
  void _confirmDeletePet(BuildContext context, Pet pet) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: const Color(0xFFF6F0D1),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            SizedBox(width: 8),
            Text("Confirmar Exclusão"),
          ],
        ),
        content: Text(
          "Tem certeza que deseja excluir ${pet.name}?\n\nEsta ação não pode ser desfeita.",
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context);
              await _deletePet(pet);
            },
            child: const Text("Excluir"),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePet(Pet pet) async {
    // Mostrar loading
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final success = await PetService.deletePet(pet.id!);

      if (!mounted) return;
      Navigator.pop(context); // Fecha o loading

      if (success) {
        _showSnackBar('${pet.name} foi excluído com sucesso');
        await _loadPets();
      } else {
        _showSnackBar('Erro ao excluir ${pet.name}', isError: true);
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      _showSnackBar('Erro ao excluir pet', isError: true);
    }
  }

  Widget _buildEmptyCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFFFFF8C6),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.pets_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              "Nenhum pet cadastrado",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Adicione seu primeiro amiguinho!",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEBDD6C),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () => _showAddPetDialog(context),
              icon: const Icon(Icons.add),
              label: const Text("Cadastrar Pet"),
            ),
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
                    label: Text(
                      birthDate == DateTime.now()
                          ? "Selecionar Data de Nascimento"
                          : DateFormat('dd/MM/yyyy').format(birthDate),
                    ),
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
                        onPressed: () => _savePet(
                          context,
                          setState,
                          nameController,
                          speciesController,
                          breedController,
                          weightController,
                          birthDate,
                              (errors) {
                            nameError = errors['name'];
                            speciesError = errors['species'];
                            breedError = errors['breed'];
                            weightError = errors['weight'];
                            birthDateError = errors['birthDate'];
                          },
                        ),
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

  Future<void> _savePet(
      BuildContext dialogContext,
      StateSetter setState,
      TextEditingController nameController,
      TextEditingController speciesController,
      TextEditingController breedController,
      TextEditingController weightController,
      DateTime birthDate,
      Function(Map<String, String?>) setErrors,
      ) async {
    final errors = <String, String?>{};

    if (nameController.text.trim().isEmpty) {
      errors['name'] = 'Nome é obrigatório';
    } else if (nameController.text.trim().length > 50) {
      errors['name'] = 'Nome muito longo (máx. 50 caracteres)';
    }

    if (speciesController.text.trim().isEmpty) {
      errors['species'] = 'Espécie é obrigatória';
    }

    if (breedController.text.trim().isEmpty) {
      errors['breed'] = 'Raça é obrigatória';
    }

    // Aceita vírgula como separador decimal
    final weightText = weightController.text.replaceAll(',', '.');
    final weight = double.tryParse(weightText);
    if (weight == null || weight <= 0) {
      errors['weight'] = 'Peso deve ser maior que zero';
    } else if (weight > 500) {
      errors['weight'] = 'Peso muito alto (máx. 500 kg)';
    }

    if (birthDate.isAfter(DateTime.now())) {
      errors['birthDate'] = 'Data não pode ser futura';
    }

    setState(() => setErrors(errors));

    if (errors.isEmpty) {
      // Mostrar loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      try {
        final pet = Pet(
          nameController.text.trim(),
          breedController.text.trim(),
          speciesController.text.trim(),
          weight!,
          birthDate,
          _currentUserId!,
        );

        final success = await PetService.addPet(pet);

        if (!mounted) return;
        Navigator.pop(context); // Fecha loading

        if (success) {
          Navigator.pop(dialogContext); // Fecha diálogo
          _showSnackBar('${pet.name} cadastrado com sucesso!');
          await _loadPets();
        } else {
          _showSnackBar('Erro ao cadastrar pet', isError: true);
        }
      } catch (e) {
        if (!mounted) return;
        Navigator.pop(context);
        _showSnackBar('Erro ao cadastrar pet', isError: true);
      }
    }
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
                    label: Text(DateFormat('dd/MM/yyyy').format(birthDate)),
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
                        onPressed: () => _updatePet(
                          context,
                          setState,
                          pet,
                          nameController,
                          speciesController,
                          breedController,
                          weightController,
                          birthDate,
                              (errors) {
                            nameError = errors['name'];
                            speciesError = errors['species'];
                            breedError = errors['breed'];
                            weightError = errors['weight'];
                            birthDateError = errors['birthDate'];
                          },
                        ),
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

  Future<void> _updatePet(
      BuildContext dialogContext,
      StateSetter setState,
      Pet originalPet,
      TextEditingController nameController,
      TextEditingController speciesController,
      TextEditingController breedController,
      TextEditingController weightController,
      DateTime birthDate,
      Function(Map<String, String?>) setErrors,
      ) async {
    final errors = <String, String?>{};

    if (nameController.text.trim().isEmpty) {
      errors['name'] = 'Nome é obrigatório';
    } else if (nameController.text.trim().length > 50) {
      errors['name'] = 'Nome muito longo (máx. 50 caracteres)';
    }

    if (speciesController.text.trim().isEmpty) {
      errors['species'] = 'Espécie é obrigatória';
    }

    if (breedController.text.trim().isEmpty) {
      errors['breed'] = 'Raça é obrigatória';
    }

    final weightText = weightController.text.replaceAll(',', '.');
    final weight = double.tryParse(weightText);
    if (weight == null || weight <= 0) {
      errors['weight'] = 'Peso deve ser maior que zero';
    } else if (weight > 500) {
      errors['weight'] = 'Peso muito alto (máx. 500 kg)';
    }

    if (birthDate.isAfter(DateTime.now())) {
      errors['birthDate'] = 'Data não pode ser futura';
    }

    setState(() => setErrors(errors));

    if (errors.isEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      try {
        final petAtualizado = Pet(
          nameController.text.trim(),
          breedController.text.trim(),
          speciesController.text.trim(),
          weight!,
          birthDate,
          _currentUserId!,
          id: originalPet.id,
        );

        final success = await PetService.updatePet(petAtualizado);

        if (!mounted) return;
        Navigator.pop(context); // Fecha loading

        if (success) {
          Navigator.pop(dialogContext); // Fecha diálogo
          _showSnackBar('${petAtualizado.name} atualizado com sucesso!');
          await _loadPets();
        } else {
          _showSnackBar('Erro ao atualizar pet', isError: true);
        }
      } catch (e) {
        if (!mounted) return;
        Navigator.pop(context);
        _showSnackBar('Erro ao atualizar pet', isError: true);
      }
    }
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
        errorMaxLines: 2,
      ),
    );
  }
}