import 'package:flutter/material.dart';
import 'package:torch_app/pages_pet_shop/pet_shop_information.dart';
import 'package:torch_app/pages/loading_page.dart';
import 'package:torch_app/pages/my_pets_page.dart';
import 'package:torch_app/pages/my_profile_page.dart';
import 'package:torch_app/pages/favorite_petshops_page.dart';
import 'package:torch_app/pages/pet_shops_page.dart';
import 'package:torch_app/pages/promotions_page.dart';
import 'package:torch_app/pages_pet_shop/registration_page_pet_shop.dart';
import 'package:torch_app/pages_pet_shop/user_information.dart';
import 'package:torch_app/pages_pet_shop/verification_page.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => PetShopInformationPage(),
  '/loading': (context) => LoadingPage(),
  '/meus-pets': (context) => MyPetsPage(),
  '/perfil': (context) => MyProfilePage(),
  '/favoritos': (context) => FavoritePetshopsPage(),
  '/petshops': (context) => PetShopPage(),
  '/promocoes': (context) => PromotionsPage(),
  '/cadastro-petshop': (context) => RegistrationPagePetShop(),
  '/usuario-petshop': (context) => UserInformationPage(),
  '/verificacao': (context) => VerificationPage(),
};
