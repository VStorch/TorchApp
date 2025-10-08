import 'package:flutter/material.dart';
import '../components/CustomDrawer.dart';
import '../models/page_type.dart';
import '../models/menu_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Usa a fábrica para pegar dados como título, ícone e destino

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: const Color(0xFFEBDD6C),
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
      backgroundColor: const Color(0xFFFBF8E1),
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
    );
  }
}