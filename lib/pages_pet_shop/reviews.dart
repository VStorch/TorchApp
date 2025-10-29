import 'package:flutter/material.dart';
import '../components/CustomDrawer.dart';
import '../models/menu_item.dart';
import '../pages/login_page.dart';
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final barHeight = screenHeight * 0.05; // mesma altura da faixa do Services

    return Scaffold(
      backgroundColor: corFundo,
      drawer: CustomDrawer(
        menuItems: [
          MenuItem(title: "Início", icon: Icons.home, destinationPage: const HomePagePetShop()),
          MenuItem(title: "Perfil", icon: Icons.person, destinationPage: const Profile()),
          MenuItem(title: "Serviços", icon: Icons.build, destinationPage: const Services()),
          MenuItem(title: "Avaliações", icon: Icons.star, destinationPage: const Reviews()),
          MenuItem(title: "Promoções", icon: Icons.local_offer, destinationPage: const Promotions()),
          MenuItem(title: "Forma de pagamento", icon: Icons.credit_card, destinationPage: const PaymentMethod()),
          MenuItem(title: "Configurações", icon: Icons.settings, destinationPage: const Settings()),
          MenuItem(title: "Sair", icon: Icons.logout, destinationPage: const LoginPage()),
        ],
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(barHeight),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          decoration: BoxDecoration(
            color: corPrimaria,
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Ícone da pata responsivo
                Positioned(
                  left: -10,
                  top: -6,
                  bottom: 0,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.pets, size: barHeight * 0.8, color: Colors.black),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
                // Título centralizado
                Center(
                  child: Text(
                    "Avaliações",
                    style: TextStyle(
                      fontSize: barHeight * 0.6, // mesmo tamanho responsivo do Services
                      fontWeight: FontWeight.bold,
                      color: corTexto,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: _avaliacoes.isEmpty
            ? Center(
          child: Text(
            'Nenhuma avaliação ainda 🐾',
            style: TextStyle(color: corTexto.withOpacity(0.6), fontSize: screenHeight * 0.02),
            textAlign: TextAlign.center,
          ),
        )
            : ListView.builder(
          itemCount: _avaliacoes.length,
          itemBuilder: (context, index) {
            final review = _avaliacoes[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              margin: EdgeInsets.only(bottom: screenHeight * 0.015),
              color: Colors.white,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.012),
                title: Text(
                  review['cliente'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: corTexto,
                    fontSize: screenHeight * 0.022, // mesmo tamanho do nome do serviço
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
                          size: screenHeight * 0.018,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      review['comentario'],
                      style: TextStyle(color: corTexto.withOpacity(0.7), fontSize: screenHeight * 0.018),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      'Data: ${review['data']}',
                      style: TextStyle(color: corTexto.withOpacity(0.6), fontSize: screenHeight * 0.015),
                    ),
                  ],
                ),
                isThreeLine: true,
              ),
            );
          },
        ),
      ),
    );
  }
}
