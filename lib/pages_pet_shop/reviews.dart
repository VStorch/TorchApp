import 'package:flutter/material.dart';
import 'package:torch_app/components/custom_drawer_pet_shop.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Reviews extends StatefulWidget {
  final int petShopId;
  final int userId;

  const Reviews({super.key, required this.petShopId, required this.userId});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  List<Map<String, dynamic>> _avaliacoes = [];
  bool isLoading = true;
  double mediaAvaliacoes = 0.0;
  int totalAvaliacoes = 0;

  final Color corFundo = const Color(0xFFFBF8E1);
  final Color corPrimaria = const Color(0xFFF4E04D);
  final Color corTexto = Colors.black87;

  @override
  void initState() {
    super.initState();
    _loadAvaliacoes();
  }

  Future<void> _loadAvaliacoes() async {
    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/evaluate/${widget.petShopId}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Ordenar por data mais recente
        final avaliacoes = data.map((item) => item as Map<String, dynamic>).toList();
        avaliacoes.sort((a, b) {
          final dateA = DateTime.parse(a['date']);
          final dateB = DateTime.parse(b['date']);
          return dateB.compareTo(dateA);
        });

        // Calcular média
        if (avaliacoes.isNotEmpty) {
          final soma = avaliacoes.fold<int>(0, (sum, item) => sum + (item['rating'] as int));
          mediaAvaliacoes = soma / avaliacoes.length;
          totalAvaliacoes = avaliacoes.length;
        }

        setState(() {
          _avaliacoes = avaliacoes;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        _showErrorSnackBar('Erro ao carregar avaliações');
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showErrorSnackBar('Erro de conexão: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      const months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final barHeight = screenHeight * 0.05;

    return Scaffold(
      backgroundColor: corFundo,
      drawer: CustomDrawerPetShop(petShopId: widget.petShopId, userId: widget.userId),
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
                Center(
                  child: Text(
                    "Avaliações",
                    style: TextStyle(
                      fontSize: barHeight * 0.6,
                      fontWeight: FontWeight.bold,
                      color: corTexto,
                    ),
                  ),
                ),
                Positioned(
                  right: -10,
                  top: -6,
                  bottom: 0,
                  child: IconButton(
                    icon: Icon(Icons.refresh, size: barHeight * 0.7, color: Colors.black87),
                    onPressed: _loadAvaliacoes,
                    tooltip: 'Atualizar',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: corPrimaria))
          : Column(
        children: [
          // Card de Resumo
          if (_avaliacoes.isNotEmpty)
            Container(
              margin: EdgeInsets.all(screenWidth * 0.04),
              padding: EdgeInsets.all(screenWidth * 0.05),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: corPrimaria, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        mediaAvaliacoes.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: screenHeight * 0.05,
                          fontWeight: FontWeight.bold,
                          color: corTexto,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                              (i) => Icon(
                            i < mediaAvaliacoes.round() ? Icons.star : Icons.star_border,
                            size: screenHeight * 0.025,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Text(
                        '$totalAvaliacoes ${totalAvaliacoes == 1 ? 'avaliação' : 'avaliações'}',
                        style: TextStyle(
                          color: corTexto.withOpacity(0.6),
                          fontSize: screenHeight * 0.018,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Lista de Avaliações
          Expanded(
            child: _avaliacoes.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.rate_review_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma avaliação ainda 🐾',
                    style: TextStyle(
                      color: corTexto.withOpacity(0.6),
                      fontSize: screenHeight * 0.02,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'As avaliações dos clientes aparecerão aqui',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: screenHeight * 0.016,
                    ),
                  ),
                ],
              ),
            )
                : RefreshIndicator(
              onRefresh: _loadAvaliacoes,
              color: corPrimaria,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                itemCount: _avaliacoes.length,
                itemBuilder: (context, index) {
                  return _buildReviewCard(_avaliacoes[index], screenHeight, screenWidth);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review, double screenHeight, double screenWidth) {
    final rating = review['rating'] ?? 0;
    final comment = review['comment'] ?? '';
    final date = review['date'] ?? '';
    final userName = review['userName'] ?? 'Cliente'; // Se o backend não retornar, use um valor padrão

    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.015),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com nome e estrelas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: corPrimaria,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.person, size: 24, color: corTexto),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          userName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: corTexto,
                            fontSize: screenHeight * 0.022,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber[700]),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[900],
                          fontSize: screenHeight * 0.018,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Estrelas
            Row(
              children: List.generate(
                5,
                    (i) => Icon(
                  i < rating ? Icons.star : Icons.star_border,
                  size: screenHeight * 0.022,
                  color: Colors.amber,
                ),
              ),
            ),

            // Comentário
            if (comment.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: corFundo,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: corPrimaria.withOpacity(0.3), width: 1.5),
                ),
                child: Text(
                  comment,
                  style: TextStyle(
                    color: corTexto.withOpacity(0.8),
                    fontSize: screenHeight * 0.018,
                    height: 1.4,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 12),

            // Data
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: corTexto.withOpacity(0.5)),
                const SizedBox(width: 6),
                Text(
                  _formatDate(date),
                  style: TextStyle(
                    color: corTexto.withOpacity(0.6),
                    fontSize: screenHeight * 0.015,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}