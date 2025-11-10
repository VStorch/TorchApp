import 'package:flutter/material.dart';
import '../components/custom_drawer.dart';
import '../models/page_type.dart';
import '../models/menu_item.dart';

class FavoritePetshopsPage extends StatefulWidget {
  const FavoritePetshopsPage({super.key});

  @override
  State<FavoritePetshopsPage> createState() => _FavoritePetshopsPageState();
}

class _FavoritePetshopsPageState extends State<FavoritePetshopsPage> {
  final List<Map<String, dynamic>> favoritePetshops = [
    {
      'name': 'Pet shop Realeza',
      'address': 'Rua Adriano Kormann',
      'ratings': <double>[4.5, 5.0, 4.2],
    },
    {
      'name': 'Pet shop Bicho Feliz',
      'address': 'Rua Adriano Kormann',
      'ratings': <double>[3.8, 4.0],
    },
    {
      'name': 'Pet shop Pata Amiga',
      'address': 'Rua Adriano Kormann',
      'ratings': <double>[5.0],
    },
  ];

  final Color yellow = const Color(0xFFF4E04D);

  double _calculateAverageRating(List<double> ratings) {
    if (ratings.isEmpty) return 0;
    double sum = ratings.reduce((a, b) => a + b);
    return sum / ratings.length;
  }

  double clampFont(double size, {double min = 12, double max = 20}) {
    return size.clamp(min, max);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final barHeight = screenHeight * 0.07; // AppBar um pouco menor
    final iconSize = barHeight * 0.6;

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
                  top: -6,
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
                    "PetShops Favoritos",
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

      body: ListView.builder(
        padding: EdgeInsets.all(screenWidth * 0.04),
        itemCount: favoritePetshops.length,
        itemBuilder: (context, index) {
          final petshop = favoritePetshops[index];
          final averageRating =
          _calculateAverageRating(petshop['ratings']).toStringAsFixed(1);

          return Container(
            margin: EdgeInsets.only(bottom: screenHeight * 0.015),
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              color: yellow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, size: clampFont(screenWidth * 0.05, min: 18, max: 24)),
                    SizedBox(width: screenWidth * 0.02),
                    Expanded(
                      child: Text(
                        petshop['name'],
                        style: TextStyle(
                          fontSize: clampFont(screenWidth * 0.045, min: 16, max: 22),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.star, size: clampFont(screenWidth * 0.07, min: 20, max: 30), color: Colors.black),
                      onPressed: () {
                        _showRatingDialog(index);
                      },
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.006),
                Text(
                  petshop['address'],
                  style: TextStyle(
                    fontSize: clampFont(screenWidth * 0.04, min: 14, max: 20),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: screenHeight * 0.012),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: clampFont(screenWidth * 0.045, min: 16, max: 22)),
                    SizedBox(width: screenWidth * 0.01),
                    Text(
                      averageRating,
                      style: TextStyle(
                        fontSize: clampFont(screenWidth * 0.04, min: 14, max: 20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                            vertical: screenHeight * 0.01),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                        textStyle: TextStyle(
                          fontSize: clampFont(screenWidth * 0.04, min: 14, max: 20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text("Repetir Serviço"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showRatingDialog(int index) {
    double selectedRating = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Avalie este PetShop'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AnimatedScale(
                      scale: i < selectedRating ? 1.2 : 1.0,
                      duration: const Duration(milliseconds: 150),
                      child: IconButton(
                        iconSize: 26,
                        icon: Icon(
                          Icons.star,
                          color: i < selectedRating ? Colors.amber : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedRating = i + 1.0;
                          });
                        },
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (selectedRating > 0) {
                  setState(() {
                    favoritePetshops[index]['ratings'].add(selectedRating);
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
  }
}
