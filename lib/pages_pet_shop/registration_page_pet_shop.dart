import 'package:flutter/material.dart';
import '../data/user/verification_pet_shop/verification_services.dart';
import 'verification_page.dart';

class RegistrationPagePetShop extends StatefulWidget {
  const RegistrationPagePetShop({super.key});

  @override
  State<RegistrationPagePetShop> createState() => _RegistrationPagePetShopState();
}

class _RegistrationPagePetShopState extends State<RegistrationPagePetShop> {
  final _emailController = TextEditingController();

  void _goToVerification() async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um e-mail válido.')),
      );
      return;
    }

    try {
      await VerificationService.sendVerificationCode(email);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Código de verificação enviado!')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationPage(email: email),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF5F3E2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEBDD6C),
        toolbarHeight: 90,
        title: const Text(
          'Cadastro',
          style: TextStyle(
            fontFamily: 'InknutAntiqua',
            fontWeight: FontWeight.w600,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset(
                  'lib/assets/images/cachorroneve.jpg',
                  width: 220,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email...',
                  prefixIcon: Icon(Icons.email_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _goToVerification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEBDD6C),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Continuar', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
