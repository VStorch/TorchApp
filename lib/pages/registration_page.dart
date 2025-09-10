  import 'package:flutter/material.dart';
import '../data/user.dart';
import '../data/user_service.dart';



class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  static const IconData key = IconData(0xf052b, fontFamily: 'MaterialIcons');
  static const IconData email_Rounded = IconData(0xf705, fontFamily: 'MaterialIcons');
  static const IconData account_circle = IconData(0xe043, fontFamily: 'MaterialIcons');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();

  void _registerUser() async {

    // Variáveis final = imutáveis .trim: remove espaços extras no início e no final do texto
    final name = _nameController.text.trim();
    final surname = _surnameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Verifica se todos os campos estão preenchidos
    if (name.isEmpty || surname.isEmpty || email.isEmpty || password.isEmpty){
      _showDialog('Erro','Preencha todos os campos');
      return;
    }
    // Verificando se o nome é válido
    if(!UserService.isValidName(name)){
      _showDialog('Erro', 'Nome com caracteres inválidos');
      return;
    }

    // Verificando se o sobrenome é válido
    if(!UserService.isValidSurname(surname)){
      _showDialog('Erro', 'Sobrenome com caracteres inválidos');
      return;
    }

    // Verificação se o email é válido
    if (!UserService.isValidEmail(email)) {
      _showDialog('Erro','Email inválido');
      return;
    }
    // Verificando se a senha é válida
    if(!UserService.isValidPassword(password)){
      _showDialog('Erro','Senha com menos de 8 caracteres');
      return;
    }

    // Verificação se o email já está cadastrado
    if (await UserService.emailExists(email)){
      _showDialog('Erro','Email já cadastrado');
      return;
    }

    // Adiciona um novo usuário e limpa os campos, além de definir o diálogo
    final newUser = User(name, surname, email, password);
    final success = await UserService.addUser(newUser);

    if (success) {
      _showDialog('Sucesso','Usuário cadastrado com sucesso');

      _nameController.clear();
      _surnameController.clear();
      _emailController.clear();
      _passwordController.clear();
    }
    else {
      _showDialog('Erro','Falha ao cadastrar usuário');
    }
  }

  // Mostra o diálogo e cria o botão ok
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
      return Scaffold(

        // Dá um resize para que a caixa de texto não fique ocultada pelo usuário
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

        // SafeArea: faz com que o conteúdo não possa ser ocultado
        body: SafeArea(

          // ScrollView: faz com que o conteúdo possa ser deslocado, no caso de nome ou senha muito grandes
            child: SingleChildScrollView(

              // Define o espaçamento do objeto com as margens
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Column(
                  children: [
                    ClipOval(
                      child: Image.asset(
                      'lib/assets/images/cachorroneve.jpg',
                      width: 200,
                      height : 200,

                      fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 25),


                    // Nome
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nome...',
                        prefixIcon: const Icon(Icons.pets),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Sobrenome
                    TextField(
                      controller: _surnameController,
                      decoration: InputDecoration(
                        labelText: 'Sobrenome...',
                        prefixIcon: const Icon(account_circle),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Email
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email...',
                        prefixIcon: const Icon(email_Rounded),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Senha
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Senha...',
                        prefixIcon: const Icon(key),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Botão de registro
                    ElevatedButton(
                      onPressed: _registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEBDD6C),
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Cadastrar'),
                    ),
                  ],
                ),
            ),
        ),
      );
    }
}
