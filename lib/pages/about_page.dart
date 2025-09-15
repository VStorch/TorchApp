// Pacote de interface visual
import 'package:flutter/material.dart';
import 'package:torch_app/pages/favorite_petshops_page.dart';
import 'package:torch_app/pages/home_page.dart';
import 'package:torch_app/pages/login_page.dart';
import 'package:torch_app/pages/my_appointments_page.dart';
import 'package:torch_app/pages/my_pets_page.dart';
import 'package:torch_app/pages/my_profile_page.dart';
import 'package:torch_app/pages/promotions_page.dart';
import 'package:torch_app/pages/settings_page.dart';

// Stateful widget (alterável)
class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}


// Classe que define o comportamento e aparência do widget Welcome, precisa extender o "Welcome" para poder alterá-lo
class _AboutPageState extends State<AboutPage> {
  @override

  // Build responsável por construir a interface do usuário
  Widget build(BuildContext context) {

    // Scaffold: layout básico do flutter
    return Scaffold(

        body: Padding(
          padding: const EdgeInsets.all(30.0), // Margem de 20 pixels ao redor do texto
          child: RichText(
            text: const TextSpan(
              style: TextStyle(
                fontFamily: 'InknutAntiqua',
                fontWeight: FontWeight.w600,
                fontSize: 13,
                height: 3.0,  // Ajuste do espaçamento entre as linhas
                color: Colors.black,  // Cor padrão do texto
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'O Torch App nasceu da ideia de três estudantes do '
                      'Instituto Federal de Santa Catarina, Câmpus '
                      'Gaspar, com o objetivo de facilitar o agendamento de '
                      'serviços em pet shops. Percebemos que muitos tutores enfrentam '
                      'dificuldades para marcar banhos, tosas e outros '
                      'cuidados para seus pets. Por isso, criamos um '
                      'aplicativo prático e intuitivo, que conecta você aos '
                      'pet shops da sua região de forma rápida, segura e '
                      'organizada. Quem somos:'
                      '\n',
                ),
                TextSpan(
                  text: '• João Pedro Pitz\n• Leonardo Cortelim dos Santos\n• Vinícius Storch',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,  // Nome dos integrantes em negrito
                    fontSize: 14,  // Tamanho de fonte maior para os nomes
                    color: Colors.black,  // Cor diferente para os nomes
                  ),
                ),
                TextSpan(
                  text: '\nEstamos comprometidos em oferecer uma '
                      'experiência eficiente tanto para os tutores quanto '
                      'para os pet shops. Esse é o nosso projeto, feito com carinho, '
                      'tecnologia e amor pelos animais! 🐶🐾',
                ),
              ],
            ),
          ),
        ),

      // Registra a cor de fundo padrão
      backgroundColor: const Color(0xFFFBF8E1),
      appBar: AppBar(
        toolbarHeight: 90,

        // Cria o ícone do menu, que neste contexto é a pata de cachorro
        leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.pets),
                iconSize: 35,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            }
        ),

        title: SizedBox(
          height : 50,
          child: TextField(
            style: const TextStyle(fontSize: 20),
            decoration: InputDecoration(
              hintText: 'Busque um PetShop',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFFBF8E1),
              contentPadding: const EdgeInsets.symmetric(vertical : 0, horizontal : 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        backgroundColor: const Color(0xFFEBDD6C),
      ),

      drawer: Drawer(
        backgroundColor: const Color(0xFFEBDD6C),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFFE8CA42),
                ),
                child: Center(
                  child: Text(
                    "Menu",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),

              title: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const HomePage()),
                    );

                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(

                      'Tela Inicial',

                      style: TextStyle(

                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),)

              ),
            ),
            ListTile(
              leading: const Icon(Icons.pets),
              title: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const MyPetsPage()),
                    );

                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(

                      'Meus Pets ',

                      style: TextStyle(

                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),)

              ),
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const FavoritePetshopsPage()),
                    );

                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(

                      'Petshops Favoritos ',

                      style: TextStyle(

                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),)

              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const MyAppointmentsPage()),
                    );

                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(

                      'Meus agendamentos ',

                      style: TextStyle(

                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),)

              ),
            ),
            ListTile(
              leading: const Icon(Icons.local_offer),
              title: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const PromotionsPage()),
                    );

                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(

                      'Promoções ',

                      style: TextStyle(

                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),)

              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const MyProfilePage()),
                    );

                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(

                      'Meu Perfil ',

                      style: TextStyle(

                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),)

              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const SettingsPage()),
                    );

                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(

                      'Configurações ',

                      style: TextStyle(

                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),)

              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const LoginPage()),
                    );

                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(

                      'Sair ',

                      style: TextStyle(

                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),)

              ),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const AboutPage()),
                    );

                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(

                      'Sobre ',

                      style: TextStyle(

                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),)

              ),
            ),
          ],
        ),
      ),
    );
  }
}