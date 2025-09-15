// Pacote de interface visual
import 'package:flutter/material.dart';

// Stateful widget (alterável)
class PetShopPage extends StatefulWidget {
  const PetShopPage({super.key});

  @override
  State<PetShopPage> createState() => _PetShopPageState();
}

class _PetShopPageState extends State<PetShopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Cor de fundo padrão
      backgroundColor: const Color(0xFFFBF8E1),

      // Barra superior
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: const Color(0xFFEBDD6C),

        // Ícone do menu (pata de cachorro)
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

        // Barra de pesquisa
        title: SizedBox(
          height: 50,
          child: TextField(
            style: const TextStyle(fontSize: 20),
            decoration: InputDecoration(
              hintText: 'Busque um PetShop',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFFBF8E1),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
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
    );
  }
}
