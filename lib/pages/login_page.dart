import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/diagonal_clipper.dart';
import '../pages_pet_shop/registration_page_pet_shop.dart';
import '../pages_pet_shop/home_page_pet_shop.dart';
import 'password_page.dart';
import 'registration_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

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

  // Salvar dados do usuário localmente
  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('user_id', userData['id']);
    await prefs.setString('user_name', userData['name'] ?? '');
    await prefs.setString('user_surname', userData['surname'] ?? '');
    await prefs.setString('user_email', userData['email'] ?? '');

    (" Dados salvos: ${userData['name']} ${userData['surname']}");
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showDialog('Erro', 'Preencha email e senha');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Fazer login
      final loginUrl = Uri.parse('http://10.0.2.2:8080/users/login');

      final loginResponse = await http.post(
        loginUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      print("===== LOGIN =====");
      print("Status: ${loginResponse.statusCode}");
      print("Body: ${loginResponse.body}");

      if (loginResponse.statusCode != 200) {
        _showDialog('Erro', 'Email ou senha incorretos');
        return;
      }

      final userData = jsonDecode(loginResponse.body);
      final userId = userData['id'];

      await _saveUserData(userData);

      // Verificar se o usuário tem Pet Shop
      final petShopUrl = Uri.parse('http://10.0.2.2:8080/users/owner/$userId');

      print("===== VERIFICANDO PET SHOP =====");
      print("URL: $petShopUrl");

      final petShopResponse = await http.get(petShopUrl);

      print("Status Pet Shop: ${petShopResponse.statusCode}");
      print("Body Pet Shop: ${petShopResponse.body}");

      bool isPetShopOwner = petShopResponse.statusCode == 200;

      (isPetShopOwner ? " Usuário é DONO de Pet Shop" : " Usuário é CLIENTE");

      // Navegar para a tela correta
      if (mounted) {
        if (isPetShopOwner) {
          final petShopData = jsonDecode(petShopResponse.body);
          final petShopId = petShopData['id']; // ID do PetShop

          print("PetShop ID: $petShopId");
          print("User ID: $userId");

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePagePetShop(
                petShopId: petShopId,
                userId: userId,
              ),
            ),
          );
        } else {
          // Não tem Pet Shop - vai para interface do Cliente
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(userId: userId),
            ),
          );
        }
      }

      _emailController.clear();
      _passwordController.clear();

    } catch (e) {
      print("Erro de conexão: $e");
      _showDialog('Erro', 'Erro de conexão com o servidor');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showAccountTypeDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          "Você possui um pet shop?",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: const Text(
          "Escolha o tipo de conta que deseja criar.",
          style: TextStyle(fontSize: 16),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEBDD6C),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegistrationPagePetShop(),
                ),
              );
              _emailController.clear();
              _passwordController.clear();
            },
            child: const Text("Sim"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEBDD6C),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegistrationPage(),
                ),
              );
              _emailController.clear();
              _passwordController.clear();
            },
            child: const Text("Não"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
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
              ClipPath(
                clipper: DiagonalClipper(),
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
                      enabled: !_isLoading,
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
                      enabled: !_isLoading,
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
                      onPressed: _isLoading ? null : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PasswordPage()),
                        );
                      },
                      child: const Text("Esqueceu a senha?"),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEBDD6C),
                        foregroundColor: Colors.black,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                          : const Text('Entrar'),
                    ),
                    const SizedBox(height: 2),
                    TextButton(
                      onPressed: _isLoading ? null : _showAccountTypeDialog,
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