import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../components/custom_drawer.dart';
import '../models/page_type.dart';
import '../models/menu_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required userId});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    final barHeight = screenHeight * 0.06;

    return Scaffold(
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(barHeight),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          decoration: BoxDecoration(
            color: const Color(0xFFEBDD6C),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Builder(
                  builder: (context) {
                    return IconButton(
                      icon: Icon(Icons.pets, size: screenWidth * 0.08),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      padding: EdgeInsets.zero,
                    );
                  },
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: Container(
                    height: barHeight * 0.65,
                    alignment: Alignment.center,
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(fontSize: isTablet ? 22 : 16),
                      decoration: InputDecoration(
                        hintText: 'Busque um PetShop',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: const Color(0xFFFBF8E1),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
              ],
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Stack(
            children: [
              // Botão "Repetir o último serviço"
              Align(
                alignment: Alignment(0.0, -0.80),
                child: FractionallySizedBox(
                  widthFactor: 0.6,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEBDD6C),
                      foregroundColor: Colors.black,
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: Text(
                      'Repetir o último serviço',
                      style: TextStyle(fontSize: isTablet ? 20 : 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

              // Patinhas
              ..._paws(width, height),

              // Gato central
              Align(
                alignment: const Alignment(0, 0.0),
                child: FractionallySizedBox(
                  widthFactor: 0.4,
                  child: ClipOval(
                    child: Image.asset(
                      'lib/assets/images/Gato bugado.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Logo TorchApp
              Align(
                alignment: const Alignment(0.05, 0.4),
                child: FractionallySizedBox(
                  widthFactor: 0.35,
                  child: Image.asset(
                    'lib/assets/images/torchapp.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // --- Faixa inferior com borda ---
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBDD6C),
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static List<Widget> _paws(double width, double height) {
    final pawsData = [
      [0.12, 0.90, 55.0],
      [0.17, 0.74, 45.0],
      [0.25, 0.60, 50.0],
      [0.29, 0.38, 60.0],
      [0.33, 0.17, 50.0],
      [0.42, 0.12, 30.0],
      [0.52, 0.07, 0.0],
      [0.62, 0.15, -10.0],
      [0.71, 0.22, -40.0],
      [0.78, 0.355, -50.0],
      [0.82, 0.50, -55.0],
      [0.88, 0.62, -54.0],
    ];

    return pawsData.map((e) {
      double top = e[0] * height;
      double left = e[1] * width;
      double rotation = e[2];
      double size = width * 0.08;
      return Positioned(
        top: top,
        left: left,
        child: Transform.rotate(
          angle: rotation * (math.pi / 180),
          child: Image.asset(
            'lib/assets/images/pata de cachorro.png',
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),
      );
    }).toList();
  }
}
