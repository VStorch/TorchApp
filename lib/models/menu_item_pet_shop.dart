import 'package:flutter/material.dart';
import 'package:torch_app/pages/login_page.dart';
import 'PageTypePetShop.dart';
import '../pages_pet_shop/home_page_pet_shop.dart';
import '../pages_pet_shop/profile.dart';
import '../pages_pet_shop/services.dart';
import '../pages_pet_shop/reviews.dart';
import '../pages_pet_shop/promotions.dart';
import '../pages_pet_shop/payment_method.dart';
import '../pages_pet_shop/settings.dart';

class MenuItemPetShop {
  final String title;
  final IconData icon;
  final Widget destinationPage;

  MenuItemPetShop({
    required this.title,
    required this.icon,
    required this.destinationPage,
  });

  factory MenuItemPetShop.fromType(PageTypePetShop type) {
    switch (type) {
      case PageTypePetShop.home:
        return MenuItemPetShop(
          title: 'Início',
          icon: Icons.home,
          destinationPage: const HomePagePetShop(),
        );
      case PageTypePetShop.profile:
        return MenuItemPetShop(
          title: 'Perfil',
          icon: Icons.person,
          destinationPage: const Profile(),
        );
      case PageTypePetShop.services:
        return MenuItemPetShop(
          title: 'Serviços',
          icon: Icons.build,
          destinationPage: Services(petShopId: widget.petShopId),
        );
      case PageTypePetShop.reviews:
        return MenuItemPetShop(
          title: 'Avaliações',
          icon: Icons.star,
          destinationPage: const Reviews(),
        );
      case PageTypePetShop.promotions:
        return MenuItemPetShop(
          title: 'Promoções',
          icon: Icons.local_offer,
          destinationPage: const Promotions(),
        );
      case PageTypePetShop.paymentMethod:
        return MenuItemPetShop(
          title: 'Forma de pagamento',
          icon: Icons.credit_card,
          destinationPage: const PaymentMethod(),
        );
      case PageTypePetShop.settings:
        return MenuItemPetShop(
          title: 'Configurações',
          icon: Icons.settings,
          destinationPage: const Settings(),
        );
      case PageTypePetShop.logout:
        return MenuItemPetShop(
          title: 'Sair',
          icon: Icons.logout,
          destinationPage: const LoginPage(), // Pode ser LoginPage se preferir
        );
    }
  }
}
