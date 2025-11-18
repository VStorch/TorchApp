import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final Color bgColor = const Color(0xFFFBF8E1);

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

  String converterDeISO(String dataISO) {
    try {
      if (dataISO.contains('-')) {
        final partes = dataISO.split('-');
        if (partes.length >= 3) {
          return '${partes[2]}/${partes[1]}';
        }
      }
    } catch (e) {
      print('Erro ao converter de ISO: $e');
    }
    return dataISO;
  }

  void _copiarCupom(String codigo) {
    Clipboard.setData(ClipboardData(text: codigo));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text('Cupom "$codigo" copiado!')),
          ],
        ),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navegarParaPetShop(Promotion promo) {
    if (promo.petShopId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              const Expanded(child: Text('Pet shop não identificado para esta promoção')),
            ],
          ),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/petshop_details',
      arguments: {
        'petShopId': promo.petShopId,
        'couponCode': promo.couponCode,
      },
    );
  }

  void _mostrarDetalhes(Promotion promo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            border: Border.all(color: yellow, width: 3),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: yellow,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.local_offer, size: 30, color: Colors.black87),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Detalhes da Promoção',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nome
                      Text(
                        promo.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Badge de desconto
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.green[400]!, Colors.green[600]!],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            '${promo.discountPercent?.toStringAsFixed(0) ?? '0'}% DE DESCONTO',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Descrição
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: yellow, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.description, size: 20, color: Colors.black54),
                                const SizedBox(width: 8),
                                const Text(
                                  'Descrição',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              promo.description,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Validade
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.orange[300]!, width: 2),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.orange[900], size: 24),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Válido até',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange[900]!.withOpacity(0.7),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  converterDeISO(promo.validity),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange[900],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Cupom
                      const Text(
                        'Código do Cupom',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.confirmation_number, color: Colors.black87, size: 28),
                                const SizedBox(width: 12),
                                Text(
                                  promo.couponCode ?? 'N/A',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    letterSpacing: 3,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _copiarCupom(promo.couponCode ?? '');
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.copy),
                                label: const Text(
                                  'Copiar Código',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: yellow,
                                  foregroundColor: Colors.black87,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(color: Colors.black, width: 2),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Botão Agendar com Cupom
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _navegarParaPetShop(promo);
                                },
                                icon: const Icon(Icons.calendar_today),
                                label: const Text(
                                  'Agendar com Cupom',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black87,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  side: const BorderSide(color: Colors.black, width: 2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Informação
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue[200]!, width: 1),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Use este cupom ao fazer um agendamento para aplicar o desconto',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.blue[900],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final menuItems = PageType.values.map((type) => MenuItem.fromType(type)).toList();

    return Scaffold(
      backgroundColor: bgColor,
      drawer: CustomDrawer(menuItems: menuItems),
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
                      icon: Icon(Icons.pets, size: screenHeight * 0.04, color: Colors.black),
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
                Positioned(
                  right: -10,
                  top: -6,
                  bottom: 0,
                  child: IconButton(
                    icon: Icon(Icons.refresh, size: screenHeight * 0.035, color: Colors.black),
                    onPressed: _carregarPromocoes,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: yellow))
          : _errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(_errorMessage!, style: const TextStyle(fontSize: 16, color: Colors.red)),
            const SizedBox(height: 24),
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
            Icon(Icons.local_offer_outlined, size: 100, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'Nenhuma promoção disponível',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Aguarde novas promoções! 🎉',
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            ),
            const SizedBox(height: 24),
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
        color: yellow,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _promotions.length,
          itemBuilder: (context, index) {
            final promo = _promotions[index];
            final validadeExibicao = converterDeISO(promo.validity);

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFF3CD), Color(0xFFFFE69C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () => _mostrarDetalhes(promo),
                borderRadius: BorderRadius.circular(18),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.local_offer, color: Colors.orange[700], size: 28),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  promo.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.green[700]!, width: 2),
                                  ),
                                  child: Text(
                                    '${promo.discountPercent?.toStringAsFixed(0) ?? '0'}% OFF',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[900],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        promo.description,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                              const SizedBox(width: 6),
                              Text(
                                'Válido até $validadeExibicao',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () => _mostrarDetalhes(promo),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black87,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: Colors.black, width: 2),
                              ),
                            ),
                            child: const Text(
                              'Ver Cupom',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Botão Agendar no card
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _navegarParaPetShop(promo),
                          icon: const Icon(Icons.calendar_today, size: 18),
                          label: const Text(
                            'Agendar com Esta Promoção',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: yellow,
                            foregroundColor: Colors.black87,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Colors.black, width: 2),
                            ),
                          ),
                        ),
                      ),
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