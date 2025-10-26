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
  final Color corFundo = const Color(0xFFFBF8E1);
  final Color corPrimaria = const Color(0xFFF4E04D);
  final Color corTexto = Colors.black87;
  final Color corCardFundo = const Color(0xFFFFF59D);
  final Color corCardIcon = const Color(0xFFFFF9C4);

  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final barHeight = screenHeight * 0.05;

    return Scaffold(
      backgroundColor: corFundo,
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
        preferredSize: Size.fromHeight(barHeight),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          decoration: BoxDecoration(
            color: corPrimaria,
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  left: -10,
                  top: -6,
                  bottom: 0,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.pets, size: barHeight * 0.8, color: Colors.black),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Configurações",
                    style: TextStyle(
                      fontSize: barHeight * 0.6,
                      fontWeight: FontWeight.bold,
                      color: corTexto,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: ListView(
          children: [
            _buildCard(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              icon: Icons.notifications_active,
              title: "Notificações",
              subtitle: "Ative ou desative notificações do app",
              trailing: Switch(
                value: notifications,
                activeColor: corPrimaria,
                onChanged: (val) => setState(() => notifications = val),
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            _buildCard(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              icon: Icons.lock_outline,
              title: "Alterar senha",
              subtitle: "Atualize sua senha de acesso",
              onTap: () {},
            ),
            SizedBox(height: screenHeight * 0.015),
            _buildCard(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              icon: Icons.language,
              title: "Idioma",
              subtitle: "Escolha o idioma do aplicativo",
              onTap: () {},
            ),
            SizedBox(height: screenHeight * 0.015),
            _buildCard(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              icon: Icons.info_outline,
              title: "Sobre o app",
              subtitle: "Versão 1.0.0",
              onTap: () => showAboutDialog(
                context: context,
                applicationName: "PetShop App",
                applicationVersion: "1.0.0",
                applicationIcon: Icon(Icons.pets, size: screenHeight * 0.06, color: Colors.black),
                children: [
                  Text(
                    "Este app ajuda você a gerenciar seu pet shop com facilidade e rapidez.",
                    style: TextStyle(fontSize: screenHeight * 0.02),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            _buildCard(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
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
      ),
    );
  }

  Widget _buildCard({
    required double screenHeight,
    required double screenWidth,
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: EdgeInsets.only(bottom: screenHeight * 0.015),
      color: corCardFundo,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.012,
        ),
        leading: Container(
          decoration: BoxDecoration(
            color: corCardIcon,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(screenHeight * 0.015),
          child: Icon(icon, size: screenHeight * 0.035, color: Colors.black),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: corTexto,
            fontSize: screenHeight * 0.022,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
          subtitle,
          style: TextStyle(
            color: corTexto.withOpacity(0.7),
            fontSize: screenHeight * 0.018,
          ),
        )
            : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
