import 'package:flutter/material.dart';
import 'page_type.dart';
import '../pages/home_page.dart';
import '../pages/my_pets_page.dart';
import '../pages/favorite_petshops_page.dart';
import '../pages/my_appointments_page.dart';
import '../pages/promotions_page.dart';
import '../pages/my_profile_page.dart';
import '../pages/settings_page.dart';
import '../pages/login_page.dart';
import '../pages/about_page.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final Widget destinationPage;

  MenuItem({
    required this.title,
    required this.icon,
    required this.destinationPage,
  });

  factory MenuItem.fromType(PageType type) {
    switch (type) {
      case PageType.home:
        return MenuItem(
          title: 'Tela Inicial',
          icon: Icons.home,
          destinationPage: const HomePage(),
        );
      case PageType.myPets:
        return MenuItem(
          title: 'Meus Pets',
          icon: Icons.pets,
          destinationPage: const MyPetsPage(),
        );
      case PageType.favorites:
        return MenuItem(
          title: 'Petshops Favoritos',
          icon: Icons.business,
          destinationPage: const FavoritePetshopsPage(),
        );
      case PageType.appointments:
        return MenuItem(
          title: 'Meus Agendamentos',
          icon: Icons.calendar_month,
          destinationPage: const MyAppointmentsPage(),
        );
      case PageType.promotions:
        return MenuItem(
          title: 'Promoções',
          icon: Icons.local_offer,
          destinationPage: const PromotionsPage(),
        );
      case PageType.profile:
        return MenuItem(
          title: 'Meu Perfil',
          icon: Icons.person,
          destinationPage: const MyProfilePage(),
        );
      case PageType.settings:
        return MenuItem(
          title: 'Configurações',
          icon: Icons.settings,
          destinationPage: const SettingsPage(),
        );
      case PageType.login:
        return MenuItem(
          title: 'Sair',
          icon: Icons.logout,
          destinationPage: const LoginPage(),
        );
      case PageType.about:
        return MenuItem(
          title: 'Sobre',
          icon: Icons.info,
          destinationPage: const AboutPage(),
        );
    }
  }
}