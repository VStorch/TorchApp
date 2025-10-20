import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:torch_app/pages/loading_page.dart';
import 'package:torch_app/pages_pet_shop/user_information.dart';
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
      supportedLocales:  [
        Locale('pt', 'BR'),
      ],

      // Página inicial
      home: UserInformationPage(),
    );
  }
}
