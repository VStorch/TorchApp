import 'package:flutter/material.dart';
import 'package:torch_app/pages_pet_shop/leave.dart';
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
      // --- Drawer apenas com nomes e ícones ---
      drawer: CustomDrawer(
        menuItems: [
          MenuItem(title: "Início", icon: Icons.home, destinationPage: HomePagePetShop()),
          MenuItem(title: "Perfil", icon: Icons.person, destinationPage: Profile()),
          MenuItem(title: "Serviços", icon: Icons.build, destinationPage: Services()),
          MenuItem(title: "Avaliações", icon: Icons.star, destinationPage: Reviews()),
          MenuItem(title: "Promoções", icon: Icons.local_offer, destinationPage: Promotions()),
          MenuItem(title: "Forma de pagamento", icon: Icons.credit_card, destinationPage: PaymentMethod()),
          MenuItem(title: "Configurações", icon: Icons.settings, destinationPage: Settings()),
          MenuItem(title: "Sair", icon: Icons.logout, destinationPage: Leave()),
        ],
      ),

      backgroundColor: const Color(0xFFFBF8E1),

      // --- AppBar customizado ---
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          height: 90,
          color: const Color(0xFFF4E04D),
          padding: const EdgeInsets.symmetric(horizontal: 20),
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

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: SizedBox(
            height: 750,
            child: Stack(
              children: [
                // --- Patinhas espalhadas ---
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

                // --- Foto do gato Torch ---
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

                // --- Logo TorchApp ---
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
        ),
      ),
    );
  }

  // Helper das patinhas
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
