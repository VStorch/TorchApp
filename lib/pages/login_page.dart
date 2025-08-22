import 'package:flutter/material.dart';
import 'package:torch_app/components/diagonal_clipper.dart';
import 'package:torch_app/pages/password_page.dart';
import 'package:torch_app/pages/registration_page.dart';
import 'package:flutter/services.dart';
import 'package:torch_app/pages/welcome.dart';
import '../data/user_db.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Verifica se o usuário existe
    if (UserDb.checkUser(email, password) == false){
      _showDialog('Erro','Usuário não encontrado');
      return;

    }
    // Joga o caboclo pro welcome
    else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Welcome()),
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
            child: Text('OK'),
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

                // Define a posição da imagem, seu tamanho etc.
                child: Transform.translate(
                  offset: Offset(0, 0),
                  child: Image.asset(
                    'lib/assets/images/dog.png',
                    height: 500,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    // Email
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Senha
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

                    // Esqueceu a senha
                    SizedBox(height: 7),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PasswordPage(),
                          ),
                        );
                      },
                      child: Text("Esqueceu a senha?"),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    // Botão entrar
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _login();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFEBDD6C),
                        foregroundColor: Colors.black,
                      ),
                      child: Text('Entrar'),
                    ),

                    // Botão não tem uma conta
                    SizedBox(height: 2),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistrationPage()),
                        );
                        _emailController.clear();
                        _passwordController.clear();
                      },
                      child: Text(
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
