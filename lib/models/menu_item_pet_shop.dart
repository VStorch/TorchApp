import 'package:flutter/material.dart';
import 'package:torch_app/pages/login_page.dart';
import '../pages_pet_shop/pet_shop_appointments_page.dart';
import 'page_type_pet_shop.dart';
import '../pages_pet_shop/home_page_pet_shop.dart';
import '../pages_pet_shop/profile.dart';
import '../pages_pet_shop/services.dart';
import '../pages_pet_shop/reviews.dart';
import '../pages_pet_shop/promotions.dart';
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

  factory MenuItemPetShop.fromType(PageTypePetShop type,
      {required int petShopId, required int userId}) {
    switch (type) {
      case PageTypePetShop.home:
        return MenuItemPetShop(
          title: 'Início',
          icon: Icons.home,
          destinationPage: HomePagePetShop(
            petShopId: petShopId, userId: userId,),
        );
      case PageTypePetShop.profile:
        return MenuItemPetShop(
          title: 'Perfil',
          icon: Icons.person,
          destinationPage: Profile(petShopId: petShopId, userId: userId,),
        );
      case PageTypePetShop.services:
        return MenuItemPetShop(
          title: 'Serviços',
          icon: Icons.build,
          destinationPage: Services(petShopId: petShopId, userId: userId,),
        );
      case PageTypePetShop.reviews:
        return MenuItemPetShop(
          title: 'Avaliações',
          icon: Icons.star,
          destinationPage: Reviews(petShopId: petShopId, userId: userId,),
        );
      case PageTypePetShop.promotions:
        return MenuItemPetShop(
          title: 'Promoções',
          icon: Icons.local_offer,
          destinationPage: Promotions(petShopId: petShopId, userId: userId,),
        );
      case PageTypePetShop.appointments: // ADICIONE ESTE CASE
        return MenuItemPetShop(
          title: 'Agendamentos',
          icon: Icons.event_note,
          destinationPage: PetShopAppointmentsPage(
            petShopId: petShopId, userId: userId,),
        );
      case PageTypePetShop.settings:
        return MenuItemPetShop(
          title: 'Configurações',
          icon: Icons.settings,
          destinationPage: Settings(petShopId: petShopId, userId: userId,),
        );
      case PageTypePetShop.logout:
        return MenuItemPetShop(
          title: 'Sair',
          icon: Icons.logout,
          destinationPage: const LoginPage(),
        );
    }
  }
}