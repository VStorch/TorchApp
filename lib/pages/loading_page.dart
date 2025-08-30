import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'login_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with TickerProviderStateMixin {
  late AnimationController _fallController;
  late Animation<Offset> _fallingAnimation;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  int dotCount = 0;

  @override
  void initState() {
    super.initState();

    _fallController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fallingAnimation = Tween<Offset>(
      begin: const Offset(0, -2),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _fallController,
        curve: Curves.bounceOut,
      ),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.6,
      end: 1,
    ).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fallController.forward().whenComplete(() {
      _fadeController.repeat(reverse: true);
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return false;
      setState(() {
        dotCount = (dotCount + 1) % 4;
      });
      return true;
    });

    // Vai pra tela de login
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _fallController.dispose();
    _fadeController.dispose();
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
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    'TORCH',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                      letterSpacing: 4,
                    ),
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
              child: Text(
                'Carregando${"." * dotCount}',
                style: const TextStyle(
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
