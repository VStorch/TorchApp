import 'package:flutter/material.dart';
import 'package:torch_app/pages/home_page.dart';
import 'package:torch_app/pages/loading_page.dart';
import 'package:torch_app/pages/registration_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
