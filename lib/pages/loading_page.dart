import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'login_page.dart'; // importa a tela de login

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _fallingAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _fallingAnimation = Tween<Offset>(
      begin: const Offset(0, -2),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.bounceOut,
      ),
    );

    _controller.forward();

    // Após 4 segundos, navega para LoginPage
    Future.delayed(const Duration(seconds: 8), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBDD6C),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SlideTransition(
                position: _fallingAnimation,
                child: const Text(
                  'Torch',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),

            // 1º Lottie
            Align(
              alignment: const Alignment(0.01, 0.9),
              child: Lottie.asset(
                'lib/assets/images/Moody.json',
                width: 200,
                height: 200,
              ),
            ),

            // 2º Lottie
            Align(
              alignment: const Alignment(-1.3, 1),
              child: Lottie.asset(
                'lib/assets/images/Patas.json',
                width: 200,
                height: 1000,
              ),
            ),

            // 3º Lottie
            Align(
              alignment: const Alignment(1.4, 0.9),
              child: Lottie.asset(
                'lib/assets/images/Patas.json',
                width: 200,
                height: 1000,
              ),
            ),

            Align(
              alignment: const Alignment(0.1, 1),
              child: const Text(
                'Carregando...',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
