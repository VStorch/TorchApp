import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:torch_app/pages/loading_page.dart';
import 'package:torch_app/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp( // ← REMOVA O 'const' AQUI
      debugShowCheckedModeBanner: false,

      // Suporte à localização (português Brasil)
      localizationsDelegates: const [ // ← 'const' volta aqui
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [ // ← 'const' volta aqui
        Locale('pt', 'BR'),
      ],

      // ← ADICIONE ESTA LINHA
      onGenerateRoute: AppRoutes.generateRoute,

      // Página inicial
      home: const LoadingPage(), // ← 'const' volta aqui
    );
  }
}