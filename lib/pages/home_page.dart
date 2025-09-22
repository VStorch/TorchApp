// Pacote de interface visual
import 'package:flutter/material.dart';
import 'package:torch_app/pages/about_page.dart';
import 'package:torch_app/pages/promotions_page.dart';
import 'package:torch_app/pages/settings_page.dart';

import 'favorite_petshops_page.dart';
import 'login_page.dart';
import 'my_appointments_page.dart';
import 'my_pets_page.dart';
import 'my_profile_page.dart';

// Stateful widget (alterável)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


// Classe que define o comportamento e aparência do widget Welcome, precisa extender o "Welcome" para poder alterá-lo
class _HomePageState extends State<HomePage> {
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: SizedBox(
              height: 750,

            child: Stack(
              children: [
                Positioned(
                  top: 100,
                  left: 55,
                  child: SizedBox(
                    width: 250,
                    height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEBDD6C),
                      foregroundColor: Colors.black,
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: const Text(
                        style: TextStyle(fontSize: 18),
                        'Repetir o último serviço'),
                  ),

                ),


                ),
                Positioned(
                  top: 150,
                  left: 320,
                    child: Transform.rotate(
                      angle: 45 * (3.14159 / 180),
                      child: Image.asset
                      (
                        'lib/assets/images/pata de cachorro.png',
                        width: 40,
                        height : 40,
                        fit: BoxFit.cover),
                    ),
                ),
                Positioned(
                  top: 210,
                  left: 240,
                  child: Transform.rotate(
                    angle: 68 * (3.14159 / 180),
                    child: Image.asset
                      (
                        'lib/assets/images/pata de cachorro.png',
                        width: 40,
                        height : 40,
                        fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 170,
                  left: 165,
                  child: Transform.rotate(
                    angle: 60 * (3.14159 / 180),
                    child: Image.asset
                      (
                        'lib/assets/images/pata de cachorro.png',
                        width: 40,
                        height : 40,
                        fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 230,
                  left: 80,
                  child: Transform.rotate(
                    angle: 48 * (3.14159 / 180),
                    child: Image.asset
                      (
                        'lib/assets/images/pata de cachorro.png',
                        width: 40,
                        height : 40,
                        fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 280,
                  left: 0,
                  child: Transform.rotate(
                    angle: 25 * (3.14159 / 180),
                    child: Image.asset
                      (
                        'lib/assets/images/pata de cachorro.png',
                        width: 40,
                        height : 40,
                        fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 370,
                  left: 0,
                  child: Transform.rotate(
                    angle: 0 * (3.14159 / 180),
                    child: Image.asset
                      (
                        'lib/assets/images/pata de cachorro.png',
                        width: 40,
                        height : 40,
                        fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 470,
                  left: 20,
                  child: Transform.rotate(
                    angle: -10 * (3.14159 / 180),
                    child: Image.asset
                      (
                        'lib/assets/images/pata de cachorro.png',
                        width: 40,
                        height : 40,
                        fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 570,
                  left: 40,
                  child: Transform.rotate(
                    angle: -40 * (3.14159 / 180),
                    child: Image.asset
                      (
                        'lib/assets/images/pata de cachorro.png',
                        width: 40,
                        height : 40,
                        fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 640,
                  left: 95,
                  child: Transform.rotate(
                    angle: -70 * (3.14159 / 180),
                    child: Image.asset
                      (
                        'lib/assets/images/pata de cachorro.png',
                        width: 40,
                        height : 40,
                        fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 670,
                  left: 200,
                  child: Transform.rotate(
                    angle: -70 * (3.14159 / 180),
                    child: Image.asset
                      (
                        'lib/assets/images/pata de cachorro.png',
                        width: 40,
                        height : 40,
                        fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 708,
                  left: 300,
                  child: Transform.rotate(
                    angle: -60 * (3.14159 / 180),
                    child: Image.asset
                      (
                        'lib/assets/images/pata de cachorro.png',
                        width: 40,
                        height : 40,
                        fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 520,
                  left: 100,


                    child: Image.asset
                      (
                        'lib/assets/images/torchapp.png',
                        width: 166.6666666666667,
                        height : 100,
                        fit: BoxFit.cover),

                ),

                Positioned(
                  top: 300,
                  left: 85,


                child: ClipOval(


                  child: Image.asset
                    (

                      'lib/assets/images/Gato bugado.png',
                      width: 200,
                      height : 200,


                      fit: BoxFit.cover),

                ),
                ),
              ],

            ),
        ),

        ),
        
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFFEBDD6C),
        child: ListView(
          padding: EdgeInsets.zero,

          children:  <Widget>[
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
