import 'package:flutter/material.dart';

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
        backgroundColor: const Color(0xFFEBDD6C),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFFEBDD6C),
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFFE8CA42),
                ),
                child: Center(
                  child: Text(
                    "Menu",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Tela Inicial"),
            ),
            ListTile(
              leading: Icon(Icons.pets),
              title: Text("Meus Pets"),
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text("PetShops favoritos"),
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text("Meus Agendamentos"),
            ),
            ListTile(
              leading: Icon(Icons.local_offer),
              title: Text("Promoções"),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Meu Perfil"),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Configurações"),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Sair"),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Sobre"),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favoritePetshops.length,
        itemBuilder: (context, index) {
          final petshop = favoritePetshops[index];
          final ratings = petshop['ratings'] as List<double>;
          final averageRating = ratings.isEmpty
              ? 0.0
              : ratings.reduce((a, b) => a + b) / ratings.length;

          return Card(
            color: const Color(0xFFEBDD6C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              petshop['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              petshop['address'],
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showRatingDialog(index);
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.black, size: 24),
                            const SizedBox(width: 4),
                            Text(
                              averageRating == 0
                                  ? '0'
                                  : averageRating.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // ação para repetir serviço
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Repetir Serviço'),
                      ),
                    ],
                  ),
                ],
              ),
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
