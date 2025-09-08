import 'package:flutter/material.dart';

class MyPetsPage extends StatefulWidget {
  const MyPetsPage({super.key});

  @override
  State<MyPetsPage> createState() => _MyPetsPageState();
}

class _MyPetsPageState extends State<MyPetsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // <- chave do Scaffold
      backgroundColor: const Color(0xFFF6F0D1),

      appBar: AppBar(
        backgroundColor: const Color(0xFFEBDD6C),
        toolbarHeight: 90,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.pets, size: 35, color: Colors.black),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Busque um PetShop...',
                  filled: true,
                  fillColor: const Color(0xFFF6F0D1),
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {
                // ação de busca
              },
            ),
          ],
        ),
      ),

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
            ListTile(leading: Icon(Icons.business), title: Text("PetShops favoritos")),
            ListTile(leading: Icon(Icons.calendar_month), title: Text("Meus Agendamentos")),
            ListTile(leading: Icon(Icons.local_offer), title: Text("Promoções")),
            ListTile(leading: Icon(Icons.person), title: Text("Meu Perfil")),
            ListTile(leading: Icon(Icons.settings), title: Text("Configurações")),
            ListTile(leading: Icon(Icons.logout), title: Text("Sair")),
            ListTile(leading: Icon(Icons.info), title: Text("Sobre")),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Card do pet
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: const Color(0xFFFFF8C6),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.pets, size: 28),
                        SizedBox(width: 8),
                        Text(
                          "Thor",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text("Idade: 2 anos"),
                    const Text("Raça: Golden Retriever"),
                    const Text("Último agendamento: 10/06/2025"),
                    const Text("Serviços favoritos: Banho, Tosa"),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            // ação Editar
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text("Editar"),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            // ação Excluir
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text("Excluir"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Card vazio (sem pets)
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: const Color(0xFFFFF8C6),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.pets, size: 28),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            "Você ainda não tem nenhum pet cadastrado?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text("Toque no botão abaixo para adicionar um amigo!"),
                    const SizedBox(height: 16),
                    Center(
                      child: OutlinedButton(
                        onPressed: () {
                          // ação Cadastrar
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text("Cadastrar"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFEBDD6C),
        onPressed: () {
          // ação adicionar pet
        },
        child: const Icon(Icons.add, color: Colors.black, size: 32),
      ),
    );
  }
}
