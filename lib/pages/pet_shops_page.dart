import 'package:flutter/material.dart';
import 'package:torch_app/components/custom_drawer.dart';
import 'package:torch_app/models/menu_item.dart';
import 'package:torch_app/models/page_type.dart';
import '../data/pet_shop/pet_shop_service.dart';

class PetShopPage extends StatefulWidget {
  const PetShopPage({super.key});

  @override
  State<PetShopPage> createState() => _PetShopPageState();
}

class _PetShopPageState extends State<PetShopPage> {
  final PetShopService service = PetShopService();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final petShops = service
        .getPetShops()
        .where((shop) =>
        shop.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    final menuItems = PageType.values
        .map((type) => MenuItem.fromType(type))
        .toList();

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
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        title: SizedBox(
          height: 50,
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
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
      drawer: CustomDrawer(menuItems: menuItems),

      // Lista de PetShops
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: petShops.length,
        itemBuilder: (context, index) {
          final shop = petShops[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEBDD6C),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, color: Colors.black),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(shop.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(shop.fullAddress),
                      Text("📞 ${shop.phone}",
                          style: const TextStyle(fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: shop.isFavorite ? Colors.red : Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      service.toggleFavorite(shop);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
