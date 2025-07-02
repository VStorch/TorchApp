import 'package:flutter/material.dart';

import '../data/user.dart';
import '../data/user_db.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();

  void _registerUser() {
    final name = _nameController.text.trim();
    final surname = _surnameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || surname.isEmpty || email.isEmpty || password.isEmpty){
      _showDialog('Erro','Preencha todos os campos');
      return;
    }

    if (UserDb.emailExists(email)){
      _showDialog('Erro','Email já cadastrado');
      return;
    }

    final newUser = User(name, surname, email, password);
    UserDb.addUser(newUser);
    _showDialog('Sucesso','Usuário cadastrado com sucesso');

    _nameController.clear();
    _surnameController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFF5F3E2),
      appBar: AppBar(
        backgroundColor: Color(0xFFEBDD6C),
        title: Text(
            'Cadastro',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 70),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nome...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  TextField(
                    controller: _surnameController,
                    decoration: InputDecoration(
                      labelText: 'Sobrenome...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEBDD6C),
                      foregroundColor: Colors.black,
                    ),
                    child: Text('Cadastrar'),
                  ),
                ],
              ),
          ),
      ),
    );
  }
}
