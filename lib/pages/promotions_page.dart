import 'package:flutter/material.dart';
import '../components/custom_drawer.dart';
import '../models/page_type.dart';
import '../models/menu_item.dart';
import '../models/promotion.dart';
import '../services/promotion_service.dart';

class PromotionsPage extends StatefulWidget {
  const PromotionsPage({super.key});

  @override
  State<PromotionsPage> createState() => _PromotionsPageState();
}

class _PromotionsPageState extends State<PromotionsPage> {
  final PromotionService _promotionService = PromotionService();
  List<Promotion> _promotions = [];
  bool _isLoading = true;
  String? _errorMessage;

  final Color yellow = const Color(0xFFF4E04D);

  @override
  void initState() {
    super.initState();
    _carregarPromocoes();
  }

  Future<void> _carregarPromocoes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final promocoes = await _promotionService.getAllPromotions();
      setState(() {
        _promotions = promocoes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erro ao carregar promoções';
      });
      print('Erro ao carregar promoções: $e');
    }
  }

  // Converte formato ISO (YYYY-MM-DD) para DD/MM para exibição
  String converterDeISO(String dataISO) {
    try {
      if (dataISO.contains('-')) {
        final partes = dataISO.split('-');
        if (partes.length >= 3) {
          return '${partes[2]}/${partes[1]}'; // DD/MM
        }
      }
    } catch (e) {
      print('Erro ao converter de ISO: $e');
    }
    return dataISO;
  }

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

      // AppBar amarela com borda preta
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

      // Corpo responsivo com loading, erro e dados
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: screenHeight * 0.08,
                color: Colors.red),
            SizedBox(height: spacing),
            Text(
              _errorMessage!,
              style: TextStyle(
                fontSize: descFontSize,
                color: Colors.red,
              ),
            ),
            SizedBox(height: spacing * 2),
            ElevatedButton.icon(
              onPressed: _carregarPromocoes,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar Novamente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: yellow,
                foregroundColor: Colors.black87,
              ),
            ),
          ],
        ),
      )
          : _promotions.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_offer_outlined,
                size: screenHeight * 0.1,
                color: Colors.grey),
            SizedBox(height: spacing * 2),
            Text(
              'Nenhuma promoção disponível no momento 🏷️',
              style: TextStyle(
                fontSize: descFontSize,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing * 2),
            ElevatedButton.icon(
              onPressed: _carregarPromocoes,
              icon: const Icon(Icons.refresh),
              label: const Text('Atualizar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: yellow,
                foregroundColor: Colors.black87,
              ),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _carregarPromocoes,
        child: ListView.builder(
          padding: EdgeInsets.all(screenWidth * 0.04),
          itemCount: _promotions.length,
          itemBuilder: (context, index) {
            final promo = _promotions[index];
            final validadeExibicao = converterDeISO(promo.validity);

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
                        promo.name,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: spacing),
                      Text(
                        promo.description,
                        style: TextStyle(
                          fontSize: descFontSize,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: spacing * 1.2),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  size: dateFontSize,
                                  color: Colors.black87),
                              SizedBox(width: spacing * 0.5),
                              Text(
                                'Válido até $validadeExibicao',
                                style: TextStyle(
                                  fontSize: dateFontSize,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // TODO: Implementar navegação para agendamento
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Funcionalidade de agendamento em breve!'),
                                  backgroundColor: Colors.blue,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black87,
                              elevation: 5,
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.06,
                                vertical: screenHeight * 0.015,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(20),
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
      ),
    );
  }
}