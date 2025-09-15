import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/diagonal_clipper.dart';
import 'password_page.dart';
import 'registration_page.dart';
import 'home_page.dart';

import '../data/user/user_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFEBDD6C),
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final success = await UserService.loginUser(email, password);

    // Verifica se o usuário existe
    if (!success){
      _showDialog('Erro','Usuário não encontrado');
      return;
    }
    // Joga o caboclo pro welcome
    else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
    _emailController.clear();
    _passwordController.clear();
  }

  // Mostra o diálogo
  void _showDialog(String title, String message){
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
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xFFEBDD6C),
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // Recorta a imagem do cachorro
              ClipPath(
                clipper: DiagonalClipper(),
                
                // Define a posição da imagem do cachorro, seu tamanho etc.
                child: Image.asset(
                  'lib/assets/images/dog.png',
                  height: 500,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Senha...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PasswordPage(),
                          ),
                        );
                      },
                      child: const Text("Esqueceu a senha?"),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEBDD6C),
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Entrar'),
                    ),

                    // Botão não tem uma conta
                    const SizedBox(height: 2),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegistrationPage()),
                        );
                        _emailController.clear();
                        _passwordController.clear();
                      },
                      child: const Text(
                        'Não tem uma conta? Clique aqui!',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
