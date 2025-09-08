import 'package:flutter/material.dart';

// Stateful widget (alterável)
class MyPetsPage extends StatefulWidget {
  const MyPetsPage({super.key});

  @override
  State<MyPetsPage> createState() => _MyPetsPageState();
}

class _MyPetsPageState extends State<MyPetsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8E1),

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
              hintText: 'Busque um PetShop',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFFFF9CD),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        backgroundColor: const Color(0xFFEBDD6C),
      ),

      drawer: Drawer(
        backgroundColor: const Color(0xFFEBDD6C),
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFFE8CA42),
                ),
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
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Tela Inicial"),
            ),
            ListTile(
              leading: Icon(Icons.pets),
              title: Text("Meus Pets"),
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text("PetShops favoritos"),
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text("Meus Agendamentos"),
            ),
            ListTile(
              leading: Icon(Icons.local_offer),
              title: Text("Promoções"),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Meu Perfil"),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Configurações"),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Sair"),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Sobre"),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // QUADRADO 1
            Container(
              width: double.infinity,
              height: 250,
              color: const Color(0xFFFFF9CD),
              child: Stack(
                children: const [
                  Center(
                    child: Text(
                      '',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 340,
                    child: Icon(
                      Icons.pets,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),

            // QUADRADO 2
            Container(
              width: double.infinity,
              height: 250,
              color: const Color(0xFFFFF9CD),
              child: Stack(
                children: const [
                  Center(
                    child: Text(
                      '',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 340,
                    child: Icon(
                      Icons.pets,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
