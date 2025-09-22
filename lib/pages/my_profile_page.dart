// Pacote de interface visual
import 'package:flutter/material.dart';

// Stateful widget (alterável)
class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

// Classe que define o comportamento e aparência do widget
class _MyProfilePageState extends State<MyProfilePage> {
  @override
  Widget build(BuildContext context) {
    // Scaffold: layout básico do flutter
    return Scaffold(
      // Cor de fundo
      backgroundColor: const Color(0xFFFBF8E1),

      // Barra superior
      appBar: AppBar(
        toolbarHeight: 90,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.pets),
              iconSize: 35,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Container(
          height: 50,
          child: TextField(
            style: const TextStyle(fontSize: 20),
            decoration: InputDecoration(
              hintText: 'Busque um PetShop...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFFBF8E1),
              contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        backgroundColor: const Color(0xFFEBDD6C),
      ),

      // Menu lateral
      drawer: Drawer(
        backgroundColor: const Color(0xFFEBDD6C),
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFFE8CA42)),
                child: Center(
                  child: Text(
                    "Menu",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(leading: Icon(Icons.home), title: Text("Tela Inicial")),
            ListTile(leading: Icon(Icons.pets), title: Text("Meus Pets")),
            ListTile(
                leading: Icon(Icons.business),
                title: Text("PetShops favoritos")),
            ListTile(
                leading: Icon(Icons.calendar_month),
                title: Text("Meus Agendamentos")),
            ListTile(
                leading: Icon(Icons.local_offer), title: Text("Promoções")),
            ListTile(leading: Icon(Icons.person), title: Text("Meu Perfil")),
            ListTile(leading: Icon(Icons.settings), title: Text("Configurações")),
            ListTile(leading: Icon(Icons.logout), title: Text("Sair")),
            ListTile(leading: Icon(Icons.info), title: Text("Sobre")),
          ],
        ),
      ),

      // Corpo da tela de perfil
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Dados do usuário
            const Text(
              "Leonardo Cortelim",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text("leo.gmail.com",
                style: TextStyle(fontSize: 16, color: Colors.black87)),
            const Text("(47)99678-8765",
                style: TextStyle(fontSize: 16, color: Colors.black87)),
            const Text("Rua Adriano Korman, nº 123 - SC",
                style: TextStyle(fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 20),

            // Lista de opções
            const Divider(),
            _buildProfileOption(Icons.pets, "Meus PetShops Favoritos"),
            const Divider(),
            _buildProfileOption(Icons.receipt_long, "Meus Pedidos"),
            const Divider(),
            _buildProfileOption(Icons.credit_card, "Formas De Pagamento"),
            const Divider(),
            _buildProfileOption(Icons.notifications, "Notificações"),
            const Divider(),
            _buildProfileOption(Icons.lock, "Alterar Senha"),
            const Divider(),
            _buildProfileOption(Icons.logout, "Sair Da Conta"),
            const Divider(),

            const SizedBox(height: 30),

            // Foto do pet
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage("lib/assets/images/american.jpg"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Item da lista do perfil
  Widget _buildProfileOption(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      onTap: () {},
    );
  }
}
