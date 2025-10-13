import 'package:flutter/material.dart';
import 'package:torch_app/pages/login_page.dart';
import '../components/CustomDrawer.dart';
import '../models/menu_item.dart';
import 'home_page_pet_shop.dart';
import 'profile.dart';
import 'services.dart';
import 'reviews.dart';
import 'promotions.dart';
import 'payment_method.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // cores do profile
  final Color yellow = const Color(0xFFF4E04D);
  final Color strongYellow = const Color(0xFFFFF59D);
  final Color lightYellow = const Color(0xFFFFF9C4);
  final Color background = const Color(0xFFFBF8E1);
  final Color blackText = Colors.black87;

  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          height: 90,
          color: yellow,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: const Offset(-20, -15), // sobe o ícone 6 pixels (use valores negativos para subir)
                  child: Builder(
                    builder: (context) {
                      return IconButton(
                        icon: const Icon(Icons.pets, size: 38, color: Colors.black),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 40),
                const Text(
                  "Configurações",
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            icon: Icons.notifications_active,
            title: "Notificações",
            subtitle: "Ative ou desative notificações do app",
            trailing: Switch(
              value: notifications,
              activeColor: Colors.black,
              inactiveThumbColor: Colors.black,
              inactiveTrackColor: Colors.grey[400],
              onChanged: (val) => setState(() => notifications = val),
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            icon: Icons.lock_outline,
            title: "Alterar senha",
            subtitle: "Atualize sua senha de acesso",
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _buildCard(
            icon: Icons.language,
            title: "Idioma",
            subtitle: "Escolha o idioma do aplicativo",
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _buildCard(
            icon: Icons.info_outline,
            title: "Sobre o app",
            subtitle: "Versão 1.0.0",
            onTap: () => showAboutDialog(
              context: context,
              applicationName: "PetShop App",
              applicationVersion: "1.0.0",
              applicationIcon: const Icon(Icons.pets, size: 50, color: Colors.black),
              children: const [
                Text(
                  "Este app ajuda você a gerenciar seu pet shop com facilidade e rapidez.",
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            icon: Icons.logout,
            title: "Sair",
            subtitle: "Voltar para a tela de login",
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: strongYellow,
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      shadowColor: Colors.black26,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: lightYellow,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(icon, size: 28, color: Colors.black),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: blackText,
                        )),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: blackText.withOpacity(0.6),
                        ),
                      ),
                  ],
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }
}
