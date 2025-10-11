import 'package:flutter/material.dart';
import '../components/CustomDrawer.dart';
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

  double _calculateAverageRating(List<double> ratings) {
    if (ratings.isEmpty) return 0;
    double sum = ratings.reduce((a, b) => a + b);
    return sum / ratings.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8E1),
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: const Color(0xFFEBDD6C),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.pets),
              iconSize: 35,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
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
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favoritePetshops.length,
        itemBuilder: (context, index) {
          final petshop = favoritePetshops[index];
          final averageRating =
          _calculateAverageRating(petshop['ratings']).toStringAsFixed(1);

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEBDD6C),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      petshop['name'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.star, size: 34, color: Colors.black),
                      onPressed: () {
                        _showRatingDialog(index);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  petshop['address'],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      averageRating,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                        textStyle:
                        const TextStyle(fontWeight: FontWeight.bold),
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
                      scale: i < selectedRating ? 1.3 : 1.0, // aumenta levemente quando clicada
                      duration: const Duration(milliseconds: 150),
                      child: IconButton(
                        iconSize: 30, // ⭐ maior desde o início
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
