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
      'ratings': <double>[],
    },
    {
      'name': 'Pet shop Realeza',
      'address': 'Rua Adriano Kormann',
      'ratings': <double>[],
    },
    {
      'name': 'Pet shop Realeza',
      'address': 'Rua Adriano Kormann',
      'ratings': <double>[],
    },
  ];

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
              contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
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
                  return IconButton(
                    icon: Icon(
                      Icons.star,
                      color: i < selectedRating ? Colors.amber : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedRating = i + 1.0;
                      });
                    },
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
