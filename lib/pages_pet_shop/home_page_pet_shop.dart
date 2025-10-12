import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:torch_app/pages/login_page.dart';
import 'package:torch_app/pages_pet_shop/payment_method.dart';
import 'package:torch_app/pages_pet_shop/profile.dart';
import 'package:torch_app/pages_pet_shop/promotions.dart';
import 'package:torch_app/pages_pet_shop/reviews.dart';
import 'package:torch_app/pages_pet_shop/services.dart';
import 'package:torch_app/pages_pet_shop/settings.dart';
import '../components/CustomDrawer.dart';
import '../models/menu_item.dart';
import 'dart:math' as math;

class HomePagePetShop extends StatelessWidget {
  const HomePagePetShop({super.key});

  @override
  Widget build(BuildContext context) {
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
        preferredSize: const Size.fromHeight(90),
        child: Container(
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    return IconButton(
                      icon: const Icon(Icons.pets, size: 38, color: Colors.black),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    );
                  },
                ),
                const SizedBox(width: 15),
                const Text(
                  "Olá Leonardo!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // --- Lottie flutuando abaixo do AppBar ---
          Positioned(
            top: -16,
            left: 0,
            right: 0,
            height: 190,
            child: Lottie.asset(
              'lib/assets/images/catEscape.json',
              fit: BoxFit.contain,
            ),
          ),

          // --- Patinhas, gato e logo ---
          Positioned.fill(
            top: 0,
            child: Stack(
              children: [
                _pata(150, 320, 45),
                _pata(210, 240, 68),
                _pata(170, 165, 60),
                _pata(230, 80, 48),
                _pata(280, 0, 25),
                _pata(370, 0, 0),
                _pata(470, 20, -10),
                _pata(570, 40, -40),
                _pata(640, 95, -70),
                _pata(670, 200, -70),
                _pata(708, 300, -60),
                Positioned(
                  top: 300,
                  left: 85,
                  child: ClipOval(
                    child: Image.asset(
                      'lib/assets/images/Gato bugado.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 500,
                  left: 100,
                  child: Image.asset(
                    'lib/assets/images/torchapp.png',
                    width: 166,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),

          // --- Faixa amarela inferior fixa ---
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF4E04D),
                border: Border.all(color: Colors.black, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _pata(double top, double left, double rotacao) {
    return Positioned(
      top: top,
      left: left,
      child: Transform.rotate(
        angle: rotacao * (math.pi / 180),
        child: Image.asset(
          'lib/assets/images/pata de cachorro.png',
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
