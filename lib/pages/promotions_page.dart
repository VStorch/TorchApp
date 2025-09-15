// Pacote de interface visual
import 'package:flutter/material.dart';
import 'package:torch_app/pages/settings_page.dart';

import 'about_page.dart';
import 'favorite_petshops_page.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'my_appointments_page.dart';
import 'my_pets_page.dart';
import 'my_profile_page.dart';

// Stateful widget (alterável)
class PromotionsPage extends StatefulWidget {
  const PromotionsPage({super.key});

  @override
  State<PromotionsPage> createState() => _PromotionsPageState();
}


// Classe que define o comportamento e aparência do widget Welcome, precisa extender o "Welcome" para poder alterá-lo
class _PromotionsPageState extends State<PromotionsPage> {
  @override

  // Build responsável por construir a interface do usuário
  Widget build(BuildContext context) {

    // Scaffold: layout básico do flutter
    return Scaffold(

      // Registra a cor de fundo padrão
      backgroundColor: const Color(0xFFFBF8E1),
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
        backgroundColor: const Color(0xFFEBDD6C),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFFEBDD6C),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
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
    );
  }
}