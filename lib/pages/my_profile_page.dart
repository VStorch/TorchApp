// Pacote de interface visual
import 'package:flutter/material.dart';

// Stateful widget (alterável)
class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}


// Classe que define o comportamento e aparência do widget Welcome, precisa extender o "Welcome" para poder alterá-lo
class _MyProfilePageState extends State<MyProfilePage> {
  @override

  // Build responsável por construir a interface do usuário
  Widget build(BuildContext context) {

    // Scaffold: layout básico do flutter
    return Scaffold(

      // Registra a cor de fundo padrão
      backgroundColor: Color(0xFFFBF8E1),
      appBar: AppBar(
        toolbarHeight: 90,

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

        title: Container(
          height : 50,
          child: TextField(
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
              hintText: 'Busque um PetShop',
              prefixIcon: Icon(Icons.search),
              filled: true,
              fillColor: Color(0xFFFBF8E1),
              contentPadding: EdgeInsets.symmetric(vertical : 0, horizontal : 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xFFEBDD6C),
      ),
      drawer: Drawer(
        backgroundColor: Color(0xFFEBDD6C),
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFFE8CA42),
                ),
                child: Center(
                  child: Text(
                    "Menu",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),),
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