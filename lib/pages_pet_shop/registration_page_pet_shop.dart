import 'package:flutter/material.dart';
import '../data/user/user.dart';
import '../data/user/user_service.dart';

class RegistrationPagePetShop extends StatefulWidget {
  const RegistrationPagePetShop({super.key});

  @override
  State<RegistrationPagePetShop> createState() => _RegistrationPagePetShopState();
}

class _RegistrationPagePetShopState extends State<RegistrationPagePetShop> {
  static const IconData key = IconData(0xf052b, fontFamily: 'MaterialIcons');
  static const IconData email_rounded = IconData(0xf705, fontFamily: 'MaterialIcons');

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _registerUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showDialog('Erro', 'Preencha todos os campos');
      return;
    }

    if (!UserService.isValidEmail(email)) {
      _showDialog('Erro', 'Email inválido');
      return;
    }

    if (!UserService.isValidPassword(password)) {
      _showDialog('Erro', 'Senha com menos de 8 caracteres');
      return;
    }

    if (await UserService.emailExists(email)) {
      _showDialog('Erro', 'Email já cadastrado');
      return;
    }

    final newUser = User("", "", email, password);
    final success = await UserService.addUser(newUser);

    if (success) {
      _showDialog('Sucesso', 'Usuário cadastrado com sucesso');
      _emailController.clear();
      _passwordController.clear();
    } else {
      _showDialog('Erro', 'Falha ao cadastrar usuário');
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
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
            crossAxisAlignment: CrossAxisAlignment.center, // centraliza horizontalmente
            children: [
              ClipOval(
                child: Image.asset(
                  'lib/assets/images/cachorroneve.jpg',
                  width: 220,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20), // pequeno espaço entre imagem e campos

              // Email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email...',
                  prefixIcon: const Icon(email_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              const SizedBox(height: 20),

              // Botão de registro
              ElevatedButton(
                onPressed: _registerUser,
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
