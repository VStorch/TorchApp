import 'package:flutter/material.dart';
import '../components/custom_drawer.dart';
import '../models/page_type.dart';
import '../models/menu_item.dart';

class PromotionsPage extends StatefulWidget {
  const PromotionsPage({super.key});

  @override
  State<PromotionsPage> createState() => _PromotionsPageState();
}

class _PromotionsPageState extends State<PromotionsPage> {
  final List<Map<String, String>> promotions = [
    {
      "title": "PetShop Realeza",
      "description": "Banho + Tosa com 20% de desconto até 15/07!",
      "date": "15/07"
    },
    {
      "title": "Meu Melhor Amigo",
      "description": "Primeiro Tosa com 30% off! Promoção válida até 25/06",
      "date": "25/06"
    },
  ];

  final Color yellow = const Color(0xFFF4E04D);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Valores responsivos baseados no tamanho da tela
    final titleFontSize = (screenWidth * 0.06).clamp(18.0, 28.0);
    final descFontSize = (screenWidth * 0.045).clamp(14.0, 20.0);
    final dateFontSize = (screenWidth * 0.04).clamp(13.0, 18.0);
    final buttonFontSize = (screenWidth * 0.045).clamp(14.0, 18.0);
    final cardPadding = screenWidth * 0.05;
    final cardMargin = screenHeight * 0.015;
    final spacing = screenHeight * 0.015;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8E1),
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

      // AppBar amarela com borda preta (igual à MyProfilePage)
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.08),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          decoration: BoxDecoration(
            color: yellow,
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  left: -10,
                  top: -6,
                  bottom: 0,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.pets,
                          size: screenHeight * 0.04, color: Colors.black),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Promoções",
                    style: TextStyle(
                      fontSize: screenHeight * 0.03,
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

      // Corpo responsivo
      body: ListView.builder(
        padding: EdgeInsets.all(screenWidth * 0.04),
        itemCount: promotions.length,
        itemBuilder: (context, index) {
          final promo = promotions[index];
          return Container(
            margin: EdgeInsets.symmetric(vertical: cardMargin),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(
                colors: [Color(0xFFEBDD6C), Color(0xFFF9E29A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Padding(
                padding: EdgeInsets.all(cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      promo["title"]!,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: spacing),
                    Text(
                      promo["description"]!,
                      style: TextStyle(
                        fontSize: descFontSize,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: spacing * 1.2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          promo["date"]!,
                          style: TextStyle(
                            fontSize: dateFontSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black87,
                            elevation: 5,
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.06,
                              vertical: screenHeight * 0.015,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                color: Color(0xFFEBDD6C),
                                width: 2,
                              ),
                            ),
                          ),
                          child: Text(
                            'Agendar',
                            style: TextStyle(
                              fontSize: buttonFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
