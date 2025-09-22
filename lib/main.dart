import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:torch_app/pages/favorite_petshops_page.dart';
import 'package:torch_app/pages/loading_page.dart';
import 'package:torch_app/pages/my_pets_page.dart';
import 'package:torch_app/pages/my_profile_page.dart';
import 'package:torch_app/pages/pet_shops_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,

      // Configurações de localização
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('pt', 'BR'), // português do Brasil
      ],

      home: MyProfilePage(),
    );
  }
}
