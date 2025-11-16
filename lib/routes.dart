import 'package:flutter/material.dart';
import 'package:torch_app/pages/login_page.dart';
import 'package:torch_app/pages/loading_page.dart';
import 'package:torch_app/pages/my_pets_page.dart';
import 'package:torch_app/pages/my_profile_page.dart';
import 'package:torch_app/pages/pet_shops_page.dart';
import 'package:torch_app/pages/promotions_page.dart';
import 'package:torch_app/pages_pet_shop/registration_page_pet_shop.dart';
import 'package:torch_app/pages_pet_shop/user_information.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const LoginPage(),
  '/loading': (context) => const LoadingPage(),
  '/meus-pets': (context) => const MyPetsPage(),
  '/perfil': (context) => const MyProfilePage(),
  '/petshops': (context) => const PetShopPage(),
  '/promocoes': (context) => const PromotionsPage(),
  '/cadastro-petshop': (context) => const RegistrationPagePetShop(),
  '/usuario-petshop': (context) => const UserInformationPage(),
};
