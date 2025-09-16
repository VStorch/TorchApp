import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/pet/pet.dart';
import '../data/pet/pet_service.dart';
import 'package:torch_app/pages/promotions_page.dart';
import 'package:torch_app/pages/settings_page.dart';

import 'about_page.dart';
import 'favorite_petshops_page.dart';
import 'home_page.dart';

import 'home_page.dart';
import 'login_page.dart';
import 'my_appointments_page.dart';
import 'my_profile_page.dart';

class MyPetsPage extends StatefulWidget {
  const MyPetsPage({super.key});

  @override
  State<MyPetsPage> createState() => _MyPetsPageState();
}

class _MyPetsPageState extends State<MyPetsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PetService _petService = PetService();

  @override
  Widget build(BuildContext context) {
    final pets = _petService.pets;

    return Scaffold(
      key: _scaffoldKey,

      // Registra a cor de fundo padrão
      backgroundColor: const Color(0xFFFBF8E1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEBDD6C),
        toolbarHeight: 90,
        automaticallyImplyLeading: false,

        // Cria o ícone do menu, que neste contexto é a pata de cachorro
        leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.pets),
                iconSize: 35,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            }
        ),

        // Campo de Busca
        title: SizedBox(
          height : 50,
          child: TextField(
            style: const TextStyle(fontSize: 20),
            decoration: InputDecoration(
              hintText: 'Busque um PetShop',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFFBF8E1),
              contentPadding: const EdgeInsets.symmetric(vertical : 0, horizontal : 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),

      // Menu
      drawer: Drawer(
        backgroundColor: const Color(0xFFEBDD6C),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFFE8CA42)),
                child: Center(
                  child: Text(
                    "Menu",
                    style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),

              title: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const HomePage()),
                    );

                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(

                      'Tela Inicial',

                      style: TextStyle(

                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),)

              ),
            ),
            ListTile(
              leading: const Icon(Icons.pets),
              title: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const MyPetsPage()),
                    );

                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(

                      'Meus Pets ',

                      style: TextStyle(

                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),)

              ),
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const FavoritePetshopsPage()),
                    );

                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(

                      'Petshops Favoritos ',

                      style: TextStyle(

                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),)

              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const MyAppointmentsPage()),
                    );

                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(

                      'Meus agendamentos ',

                      style: TextStyle(

                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),)

              ),
            ),
            ListTile(
              leading: const Icon(Icons.local_offer),
              title: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const PromotionsPage()),
                    );

                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(

                      'Promoções ',

                      style: TextStyle(

                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),)

              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const MyProfilePage()),
                    );

                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(

                      'Meu Perfil ',

                      style: TextStyle(

                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),)

              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const SettingsPage()),
                    );

                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(

                      'Configurações ',

                      style: TextStyle(

                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),)

              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const LoginPage()),
                    );

                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(

                      'Sair ',

                      style: TextStyle(

                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),)

              ),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const AboutPage()),
                    );

                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(

                      'Sobre ',

                      style: TextStyle(

                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),)

              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: pets.isEmpty
              ? [_buildEmptyCard()]
              : pets.map((pet) => _buildPetCard(pet)).toList(),
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
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 10),
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
                  onPressed: () {
                    _showEditPetDialog(context, pet);
                  },
                  child: const Text("Editar"),
                ),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _petService.removerPet(pet.id!);
                    });
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

  /// CARD QUANDO NÃO TEM PETS
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
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),

                _buildInputField("Nome", nameController),
                const SizedBox(height: 12),
                _buildInputField("Raça", breedController),
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
                      onPressed: () {
                        final pet = Pet(
                          null,
                          nameController.text,
                          breedController.text,
                          double.tryParse(weightController.text) ?? 0.0,
                          birthDate,
                        );
                        setState(() {
                          _petService.adicionarPet(pet);
                        });
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
    final weightController = TextEditingController(text: pet.weight.toString());
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
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),

                _buildInputField("Nome", nameController),
                const SizedBox(height: 12),
                _buildInputField("Raça", breedController),
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
                      onPressed: () {
                        final petAtualizado = Pet(
                          pet.id, // mantém ID
                          nameController.text,
                          breedController.text,
                          double.tryParse(weightController.text) ?? 0.0,
                          birthDate,
                        );
                        setState(() {
                          _petService.editarPet(petAtualizado);
                        });
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
