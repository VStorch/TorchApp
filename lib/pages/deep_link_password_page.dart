import 'package:flutter/material.dart';

class DeepLinkPasswordPage extends StatefulWidget {
  const DeepLinkPasswordPage({super.key});

  @override
  State<DeepLinkPasswordPage> createState() => _DeepLinkPasswordPageState();
}

class _DeepLinkPasswordPageState extends State<DeepLinkPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8E1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Esqueceu a senha?',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Sua nova senha...',
                      prefixIcon: const Icon(Icons.pets_sharp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Confirme a senha...',
                      prefixIcon: const Icon(Icons.pets),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    onPressed: () {
                      // Implementar a lógica para salvar a nova senha
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEBDD6C),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Salvar'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
