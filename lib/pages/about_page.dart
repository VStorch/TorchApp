import 'package:flutter/material.dart';
import '../components/custom_drawer.dart';
import '../models/page_type.dart';
import '../models/menu_item.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {

    final menuItems = PageType.values
        .map((type) => MenuItem.fromType(type))
        .toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
          decoration: BoxDecoration(
            color: const Color(0xFFF4E04D),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  left: -10,
                  top: 5,
                  bottom: 0,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.pets,
                          size: MediaQuery.of(context).size.height * 0.04,
                          color: Colors.black),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Sobre",
                    style: TextStyle(
                      fontSize: (MediaQuery.of(context).size.width * 0.06).clamp(18.0, 28.0),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: CustomDrawer(menuItems: menuItems),
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