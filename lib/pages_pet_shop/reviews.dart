import 'package:flutter/material.dart';
import 'package:torch_app/pages/login_page.dart';
import '../components/CustomDrawer.dart';
import '../models/menu_item.dart';
import 'home_page_pet_shop.dart';
import 'profile.dart';
import 'services.dart';
import 'promotions.dart';
import 'payment_method.dart';
import 'settings.dart';

class Reviews extends StatefulWidget {
  const Reviews({super.key});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  final List<Map<String, dynamic>> _avaliacoes = [
    {
      'cliente': 'Vinicius Storch',
      'nota': 5,
      'comentario': 'Excelente atendimento! Meu cachorro adorou.',
      'data': '10/10',
    },
    {
      'cliente': 'João Pedro',
      'nota': 4,
      'comentario': 'Bom serviço, mas demorou um pouco.',
      'data': '12/10',
    },
  ];

  final Color corFundo = const Color(0xFFFBF8E1);
  final Color corPrimaria = const Color(0xFFF4E04D);
  final Color corTexto = Colors.black87;

  void _excluirAvaliacao(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Avaliação'),
        content: const Text('Tem certeza que deseja remover esta avaliação?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _avaliacoes.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corFundo,
      drawer: CustomDrawer(
        menuItems: [
          MenuItem(title: "Início", icon: Icons.home, destinationPage: const HomePagePetShop()),
          MenuItem(title: "Perfil", icon: Icons.person, destinationPage: const Profile()),
          MenuItem(title: "Serviços", icon: Icons.build, destinationPage: const Services()),
          MenuItem(title: "Avaliações", icon: Icons.local_offer, destinationPage: const Reviews()),
          MenuItem(title: "Promoções", icon: Icons.star, destinationPage: const Promotions()),
          MenuItem(title: "Forma de pagamento", icon: Icons.credit_card, destinationPage: const PaymentMethod()),
          MenuItem(title: "Configurações", icon: Icons.settings, destinationPage: const Settings()),
          MenuItem(title: "Sair", icon: Icons.logout, destinationPage: const LoginPage()),
        ],
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          height: 90,
          color: corPrimaria,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Builder(
                  builder: (context) {
                    return IconButton(
                      icon: const Icon(Icons.pets, size: 38, color: Colors.black),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    );
                  },
                ),
                const SizedBox(width: 15),
                const Text(
                  "Avaliações",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _avaliacoes.isEmpty
            ? Center(
          child: Text(
            'Nenhuma avaliação ainda 🐾',
            style: TextStyle(color: corTexto.withOpacity(0.6)),
          ),
        )
            : ListView.builder(
          itemCount: _avaliacoes.length,
          itemBuilder: (context, index) {
            final review = _avaliacoes[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 12),
              color: Colors.white,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                title: Text(
                  review['cliente'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: corTexto,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(
                        5,
                            (i) => Icon(
                          i < review['nota'] ? Icons.star : Icons.star_border,
                          size: 18,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      review['comentario'],
                      style: TextStyle(color: corTexto.withOpacity(0.7)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Data: ${review['data']}',
                      style: TextStyle(color: corTexto.withOpacity(0.6), fontSize: 13),
                    ),
                  ],
                ),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _excluirAvaliacao(index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
