import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:torch_app/pages/favorite_petshops_page.dart';
import 'package:torch_app/pages/login_page.dart';
import 'package:torch_app/pages/my_appointments_page.dart';
import 'package:torch_app/pages/pet_shops_page.dart';
import 'package:torch_app/pages/promotions_page.dart';
import 'package:torch_app/pages_pet_shop/pet_shop_information.dart';
import 'package:torch_app/pages_pet_shop/user_information.dart';
import 'package:torch_app/pages_pet_shop/verification_page.dart'; // tela com o CEP autocomplete

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,

      // Suporte à localização (português Brasil)
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('pt', 'BR'),
      ],

      // Página inicial
      home: LoginPage(),
    );
  }
}
