import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../components/custom_drawer_pet_shop.dart';

class HomePagePetShop extends StatelessWidget {
  final int petShopId;
  final int userId;

  const HomePagePetShop({
    super.key,
    required this.petShopId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    final barHeight = screenHeight * 0.05;

    return Scaffold(
      // SIMPLIFICADO: apenas passa os IDs pro drawer
      drawer: CustomDrawerPetShop(
        petShopId: petShopId,
        userId: userId,
      ),
      backgroundColor: const Color(0xFFFBF8E1),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(barHeight),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          decoration: BoxDecoration(
            color: const Color(0xFFF4E04D),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Builder(
                  builder: (context) {
                    return Transform.translate(
                      offset: Offset(-15, barHeight * -0.1),
                      child: IconButton(
                        icon: Icon(
                          Icons.pets,
                          size: screenWidth * 0.08,
                          color: Colors.black,
                        ),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    );
                  },
                ),
                SizedBox(width: screenWidth * 0.14),
                Expanded(
                  child: Text(
                    "Olá Leonardo!",
                    style: TextStyle(
                      fontSize: isTablet ? 34 : 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final width = constraints.maxWidth;

          return Stack(
            children: [
              Align(
                alignment: const Alignment(0, -0.92),
                child: Transform.translate(
                  offset: Offset(0, -height * 0.05),
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    heightFactor: 0.2,
                    child: Lottie.asset(
                      'lib/assets/images/catEscape.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              ..._patinhas(width, height),
              Align(
                alignment: const Alignment(0, 0.1),
                child: FractionallySizedBox(
                  widthFactor: 0.45,
                  child: ClipOval(
                    child: Image.asset(
                      'lib/assets/images/Gato bugado.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0.03, 0.48),
                child: FractionallySizedBox(
                  widthFactor: 0.35,
                  child: Image.asset(
                    'lib/assets/images/torchapp.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4E04D),
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

  static List<Widget> _patinhas(double width, double height) {
    final patinhasData = [
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
      [0.89, 0.61, -55.0],
    ];

    return patinhasData.map((e) {
      double size = math.min(width * 0.06, 40);
      double top = (e[0] * height).clamp(0, height - size);
      double left = (e[1] * width).clamp(0, width - size);
      double rotation = e[2];

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