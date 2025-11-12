import 'package:flutter/material.dart';
import 'package:torch_app/components/custom_drawer.dart';
import 'package:torch_app/models/menu_item.dart';
import 'package:torch_app/models/page_type.dart';
import '../data/pet_shop/pet_shop.dart';
import '../data/pet_shop/pet_shop_service.dart';

class PetShopPage extends StatefulWidget {
  const PetShopPage({super.key});

  @override
  State<PetShopPage> createState() => _PetShopPageState();
}

class _PetShopPageState extends State<PetShopPage> {
  final PetShopService service = PetShopService();
  String searchQuery = '';
  late Future<List<PetShop>> futurePetShops;

  @override
  void initState() {
    super.initState();
    futurePetShops = service.getPetShops();
  }

  @override
  Widget build(BuildContext context) {
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
        body: FutureBuilder<List<PetShop>>(
            future: futurePetShops,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Erro ao carregar PetShops: ${snapshot.error}'),
                );
              }

              final petShops = (snapshot.data ?? [])
                  .where((shop) => shop.name
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
                  .toList();

              if (petShops.isEmpty) {
                return const Center(child: Text('Nenhum PetShop encontrado.'));
              }

          return ListView.builder(
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
          );
              },
        ),
    );
  }
}
