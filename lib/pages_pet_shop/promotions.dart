import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/custom_drawer_pet_shop.dart';
import '../models/promotion.dart';
import '../services/promotion_service.dart';

class Promotions extends StatefulWidget {
  final int petShopId;
  final int userId;

  const Promotions({super.key, required this.petShopId, required this.userId});

  @override
  State<Promotions> createState() => _PromotionsState();
}

class _PromotionsState extends State<Promotions> {
  final PromotionService _promotionService = PromotionService();
  List<Promotion> _promocoes = [];
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();
  String _titulo = '';
  String _descricao = '';
  String _validade = '';
  String _codigoCupom = '';
  double _porcentagemDesconto = 0;
  Promotion? _editPromotion;

  final Color corFundo = const Color(0xFFFBF8E1);
  final Color corPrimaria = const Color(0xFFF4E04D);
  final Color corTexto = Colors.black87;

  @override
  void initState() {
    super.initState();
    _carregarPromocoes();
  }

  // Na função _carregarPromocoes(), substitua o trecho atual por:

  Future<void> _carregarPromocoes() async {
    setState(() => _isLoading = true);
    try {
      final promocoes = await _promotionService.getAllPromotions();
      ('===== DEBUG CARREGAR PROMOÇÕES =====');
      ('Total promoções retornadas do backend: ${promocoes.length}');
      ('Pet Shop ID atual: ${widget.petShopId}');

      for (var p in promocoes) {
        ('Promoção: ${p.name}, petShopId: ${p.petShopId}');
      }

      final promocoesFiltradas = promocoes
          .where((p) => p.petShopId == widget.petShopId)
          .toList();

      ('Promoções sendo exibidas: ${promocoesFiltradas.length}');
      ('====================================');

      setState(() {
        _promocoes = promocoesFiltradas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _mostrarErro('Erro ao carregar promoções: $e');
      ('ERRO ao carregar: $e');
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(mensagem)),
          ],
        ),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _mostrarSucesso(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(mensagem)),
          ],
        ),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String formatarDataExibicao(String input) {
    String numeros = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (numeros.length >= 4) {
      String dia = numeros.substring(0, 2);
      String mes = numeros.substring(2, 4);
      return '$dia/$mes';
    }
    return input;
  }

  String converterParaISO(String dataDDMM) {
    try {
      final regex = RegExp(r'^(\d{2})/(\d{2})$');
      final match = regex.firstMatch(dataDDMM);
      if (match != null) {
        final dia = match.group(1)!;
        final mes = match.group(2)!;
        final anoAtual = DateTime.now().year;
        return '$anoAtual-$mes-$dia';
      }
    } catch (e) {
      ('Erro ao converter data: $e');
    }
    return dataDDMM;
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
      ('Erro ao converter de ISO: $e');
    }
    return dataISO;
  }

  void _abrirModalPromocao({Promotion? promocao}) {
    if (promocao != null) {
      _editPromotion = promocao;
      _titulo = promocao.name;
      _descricao = promocao.description;
      _validade = converterDeISO(promocao.validity);
      _codigoCupom = promocao.couponCode ?? '';
      _porcentagemDesconto = promocao.discountPercent ?? 0;
    } else {
      _editPromotion = null;
      _titulo = '';
      _descricao = '';
      _validade = '';
      _codigoCupom = '';
      _porcentagemDesconto = 0;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                border: Border.all(color: corPrimaria, width: 3),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: corPrimaria,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(22),
                        topRight: Radius.circular(22),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.local_offer, size: 30, color: corTexto),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _editPromotion == null ? 'Nova Promoção' : 'Editar Promoção',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: corTexto,
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextField(
                              label: 'Nome da Promoção',
                              icon: Icons.title,
                              initialValue: _titulo,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Informe o nome da promoção';
                                }
                                if (value.trim().length < 3) {
                                  return 'Mínimo 3 caracteres';
                                }
                                if (value.trim().length > 50) {
                                  return 'Máximo 50 caracteres';
                                }
                                return null;
                              },
                              onSaved: (value) => _titulo = value!.trim(),
                            ),
                            const SizedBox(height: 16),

                            _buildTextField(
                              label: 'Descrição',
                              icon: Icons.description,
                              initialValue: _descricao,
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Informe a descrição';
                                }
                                if (value.trim().length > 200) {
                                  return 'Máximo 200 caracteres';
                                }
                                return null;
                              },
                              onSaved: (value) => _descricao = value!.trim(),
                            ),
                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: _buildTextField(
                                    label: 'Código do Cupom',
                                    icon: Icons.confirmation_number,
                                    initialValue: _codigoCupom,
                                    textCapitalization: TextCapitalization.characters,
                                    onChanged: (value) {
                                      setModalState(() {
                                        _codigoCupom = value.toUpperCase();
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'Informe o código';
                                      }
                                      if (value.trim().length < 3) {
                                        return 'Mínimo 3 caracteres';
                                      }
                                      if (value.trim().length > 20) {
                                        return 'Máximo 20 caracteres';
                                      }
                                      if (!RegExp(r'^[A-Z0-9]+$').hasMatch(value.trim())) {
                                        return 'Apenas letras e números';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) => _codigoCupom = value!.trim().toUpperCase(),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildTextField(
                                    label: 'Desconto %',
                                    icon: Icons.percent,
                                    initialValue: _porcentagemDesconto > 0
                                        ? _porcentagemDesconto.toStringAsFixed(0)
                                        : '',
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(3),
                                    ],
                                    onChanged: (value) {
                                      setModalState(() {
                                        _porcentagemDesconto = double.tryParse(value) ?? 0;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'Informe %';
                                      }
                                      final percent = double.tryParse(value);
                                      if (percent == null) {
                                        return 'Inválido';
                                      }
                                      if (percent <= 0 || percent > 100) {
                                        return '1-100';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _porcentagemDesconto = double.parse(value!.trim());
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            _buildTextField(
                              label: 'Validade (DD/MM)',
                              icon: Icons.calendar_today,
                              initialValue: _validade,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                                _DateInputFormatter(),
                              ],
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Informe a validade';
                                }
                                final regex = RegExp(r'^(\d{2})/(\d{2})$');
                                if (!regex.hasMatch(value)) {
                                  return 'Formato inválido (use DD/MM)';
                                }
                                final match = regex.firstMatch(value)!;
                                final dia = int.parse(match.group(1)!);
                                final mes = int.parse(match.group(2)!);
                                if (dia < 1 || dia > 31 || mes < 1 || mes > 12) {
                                  return 'Data inválida';
                                }
                                return null;
                              },
                              onSaved: (value) => _validade = formatarDataExibicao(value!),
                            ),
                            const SizedBox(height: 24),

                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: corFundo,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: corPrimaria, width: 2),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.visibility, size: 20, color: corTexto.withOpacity(0.7)),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Preview do Cupom',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: corTexto.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _codigoCupom.isNotEmpty ? _codigoCupom.toUpperCase() : 'CODIGO123',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: corTexto,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.green[700]!, width: 2),
                                    ),
                                    child: Text(
                                      '${_porcentagemDesconto > 0 ? _porcentagemDesconto.toStringAsFixed(0) : '0'}% OFF',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[900],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: corPrimaria,
                                  foregroundColor: corTexto,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(color: Colors.black, width: 2),
                                  ),
                                ),
                                icon: const Icon(Icons.save),
                                label: Text(
                                  _editPromotion == null ? 'Criar Promoção' : 'Salvar Alterações',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                onPressed: _salvarPromocao,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    String? initialValue,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: corFundo,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: corPrimaria, width: 2),
        ),
      ),
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
    );
  }

  Future<void> _salvarPromocao() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final validadeISO = converterParaISO(_validade);

      final promotion = Promotion(
        id: _editPromotion?.id,
        name: _titulo,
        description: _descricao,
        validity: validadeISO,
        couponCode: _codigoCupom.toUpperCase(),
        discountPercent: _porcentagemDesconto,
        petShopId: widget.petShopId,
      );

      ('===== DEBUG SALVAR PROMOÇÃO =====');
      ('Promoção sendo salva:');
      ('Nome: ${promotion.name}');
      ('Cupom: ${promotion.couponCode}');
      ('PetShopId: ${promotion.petShopId}');
      ('JSON: ${promotion.toJson()}');
      ('=================================');

      try {
        if (_editPromotion == null) {
          final resultado = await _promotionService.createPromotion(promotion);
          ('Promoção criada! Resultado: $resultado');
          _mostrarSucesso('Promoção criada com sucesso!');
        } else {
          await _promotionService.updatePromotion(_editPromotion!.id!, promotion);
          _mostrarSucesso('Promoção atualizada com sucesso!');
        }

        Navigator.pop(context);
        _carregarPromocoes();
      } catch (e) {
        ('ERRO ao salvar promoção: $e');
        _mostrarErro('Erro ao salvar promoção: $e');
      }
    }
  }

  void _excluirPromocao(Promotion promotion) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.delete_outline, color: Colors.red.shade700, size: 28),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Excluir Promoção', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
          ],
        ),
        content: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Tem certeza que deseja remover esta promoção? Esta ação não pode ser desfeita.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _promotionService.deletePromotion(promotion.id!);
                _mostrarSucesso('Promoção excluída com sucesso!');
                _carregarPromocoes();
              } catch (e) {
                _mostrarErro('Erro ao excluir promoção: $e');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Excluir', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final barHeight = screenHeight * 0.05;

    return Scaffold(
      backgroundColor: corFundo,
      drawer: CustomDrawerPetShop(
        petShopId: widget.petShopId,
        userId: widget.userId,
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
                    "Promoções",
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
                    onPressed: _carregarPromocoes,
                    tooltip: 'Atualizar',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: corPrimaria))
          : _promocoes.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_offer_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Nenhuma promoção cadastrada',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Crie cupons de desconto para seus clientes!',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _carregarPromocoes,
        color: corPrimaria,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _promocoes.length,
          itemBuilder: (context, index) {
            final promo = _promocoes[index];
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
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
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
                          child: Icon(Icons.local_offer, color: corPrimaria, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                promo.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.green[700]!, width: 1.5),
                                    ),
                                    child: Text(
                                      '${promo.discountPercent?.toStringAsFixed(0) ?? '0'}% OFF',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[900],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.calendar_today, size: 14, color: Colors.black54),
                                  const SizedBox(width: 4),
                                  Text(
                                    validadeExibicao,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        promo.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: corPrimaria, width: 2),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.confirmation_number, color: corTexto, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Cupom:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            promo.couponCode ?? 'N/A',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: corTexto,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => _abrirModalPromocao(promocao: promo),
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text('Editar'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black87,
                            side: const BorderSide(color: Colors.black, width: 2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () => _excluirPromocao(promo),
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: const Text('Excluir'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[50],
                            foregroundColor: Colors.red[700],
                            side: BorderSide(color: Colors.red[300]!, width: 2),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: corPrimaria,
        foregroundColor: corTexto,
        label: const Text('Nova Promoção', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add),
        onPressed: () => _abrirModalPromocao(),
      ),
    );
  }
}

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue) {
    final text = newValue.text;

    if (text.isEmpty) {
      return newValue;
    }

    // Remove tudo que não é número
    final numbersOnly = text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limita a 4 dígitos
    if (numbersOnly.length > 4) {
      return oldValue;
    }

    // Formata DD/MM
    String formatted = numbersOnly;
    if (numbersOnly.length >= 3) {
      formatted = '${numbersOnly.substring(0, 2)}/${numbersOnly.substring(2)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}