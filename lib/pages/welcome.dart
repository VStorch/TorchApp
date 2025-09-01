// Pacote de interface visual
import 'package:flutter/material.dart';

// Stateful widget (alterável)
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
      backgroundColor: Color(0xFFFBF8E1),
      appBar: AppBar(
        toolbarHeight: 90,
        title: Container(
          height : 50,
          child: TextField(
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
              hintText: 'Busque um PetShop',
              prefixIcon: Icon(Icons.search),
              filled: true,
              fillColor: Color(0xFFFBF8E1),
              contentPadding: EdgeInsets.symmetric(vertical : 0, horizontal : 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,


              )


            )
          ),
        ),
        backgroundColor: Color(0xFFEBDD6C),
      ),









    );
  }
}
