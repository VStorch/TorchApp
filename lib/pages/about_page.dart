import 'package:flutter/material.dart';
import '../models/page_type.dart';
import '../models/menu_item.dart';
import '../components/customdrawer.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Usa a fábrica para pegar dados como título, ícone e destino
    final menuItem = MenuItem.fromType(PageType.about);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: const Color(0xFFEBDD6C),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.pets),
              iconSize: 35,
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        title: SizedBox(
          height: 50,
          child: TextField(
            style: const TextStyle(fontSize: 20),
            decoration: InputDecoration(
              hintText: 'Busque um PetShop',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFFBF8E1),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
      drawer: CustomDrawer(
        menuItems: [
          MenuItem.fromType(PageType.home),
          MenuItem.fromType(PageType.myPets),
          MenuItem.fromType(PageType.favorites),
          MenuItem.fromType(PageType.appointments),
          MenuItem.fromType(PageType.promotions),
          MenuItem.fromType(PageType.profile),
          MenuItem.fromType(PageType.settings),
          MenuItem.fromType(PageType.login),
          MenuItem.fromType(PageType.about),
        ],
      ),
      backgroundColor: const Color(0xFFFBF8E1),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: RichText(
          text: const TextSpan(
            style: TextStyle(
              fontFamily: 'InknutAntiqua',
              fontWeight: FontWeight.w600,
              fontSize: 15,
              height: 3.0,
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'O Torch App nasceu da ideia de três estudantes...',
              ),
              TextSpan(
                text:
                '\n• João Pedro Pitz\n• Leonardo Cortelim dos Santos\n• Vinícius Storch',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
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
    );
  }
}