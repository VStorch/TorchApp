import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:torch_app/pages_pet_shop/payment_method.dart';
import 'package:torch_app/pages_pet_shop/profile.dart';
import 'package:torch_app/pages_pet_shop/promotions.dart';
import 'package:torch_app/pages_pet_shop/reviews.dart';
import 'package:torch_app/pages_pet_shop/services.dart';
import 'package:torch_app/pages_pet_shop/settings.dart';

import '../components/CustomDrawer.dart';
import '../models/menu_item.dart';
import '../pages/login_page.dart';

class HomePagePetShop extends StatelessWidget {
  const HomePagePetShop({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    final barHeight = screenHeight * 0.05; // altura responsiva igual para cima e baixo

    return Scaffold(
      drawer: CustomDrawer(
        menuItems: [
          MenuItem(title: "Início", icon: Icons.home, destinationPage: const HomePagePetShop()),
          MenuItem(title: "Perfil", icon: Icons.person, destinationPage: const Profile()),
          MenuItem(title: "Serviços", icon: Icons.build, destinationPage: const Services()),
          MenuItem(title: "Avaliações", icon: Icons.star, destinationPage: const Reviews()),
          MenuItem(title: "Promoções", icon: Icons.local_offer, destinationPage: const Promotions()),
          MenuItem(title: "Forma de pagamento", icon: Icons.credit_card, destinationPage: const PaymentMethod()),
          MenuItem(title: "Configurações", icon: Icons.settings, destinationPage: const Settings()),
          MenuItem(title: "Sair", icon: Icons.logout, destinationPage: const LoginPage()),
        ],
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
                // --- Pata do menu reposicionada ---
                Builder(
                  builder: (context) {
                    return Transform.translate(
                      offset: Offset(-15, barHeight * -0.2), // Ajuste vertical
                      child: IconButton(
                        icon: Icon(
                          Icons.pets,
                          size: screenWidth * 0.1, // tamanho responsivo
                          color: Colors.black,
                        ),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    );
                  },
                ),
                SizedBox(width: screenWidth * 0.14), // espaçamento horizontal ajustável
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
              // --- Lottie totalmente responsivo ---
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

              // --- Patinhas ---
              ..._patinhas(width, height),

              // --- Gato central ---
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

              // --- Logo TorchApp ---
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

              // --- Faixa inferior (mesma altura que a AppBar) ---
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

  // Lista de patinhas responsivas
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
