// Pacote de interface visual
import 'package:flutter/material.dart';

// Stateful widget(alterável)
class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}


// Classe que define o comportamento e aparência do widget Welcome, precisa extender o "Welcome" para poder alterá-lo
class _WelcomeState extends State<Welcome> {
  @override

  // Build responsável por construir a interface do usuário
  Widget build(BuildContext context) {

    // Scaffold: layout básico do flutter
    return Scaffold(

      // Registra a cor de fundo padrão
      backgroundColor: Colors.amber,

      // Centraliza o texto e dá a mensagem de bem-vindo
      body: Center(
        child: Text('Seja bem vindo!'),
      ),
    );
  }
}
