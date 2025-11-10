import 'package:flutter/material.dart';
import 'package:torch_app/pages/login_page.dart';
import '../components/custom_drawer.dart';
import '../components/custom_drawer_pet_shop.dart';
import '../models/menu_item.dart';
import 'home_page_pet_shop.dart';
import 'profile.dart';
import 'services.dart';
import 'reviews.dart';
import 'payment_method.dart';
import 'settings.dart';

class Promotions extends StatefulWidget {
  final int petShopId;
  final int userId;

  const Promotions({super.key, required this.petShopId, required this.userId});

  @override
  State<Promotions> createState() => _PromotionsState();
}

class _PromotionsState extends State<Promotions> {
  final List<Map<String, String>> _promocoes = [];
  final _formKey = GlobalKey<FormState>();
  String _titulo = '';
  String _descricao = '';
  String _validade = '';
  int? _editIndex;

  final Color corFundo = const Color(0xFFFBF8E1);
  final Color corPrimaria = const Color(0xFFF4E04D);
  final Color corTexto = Colors.black87;

  String formatarData(String input) {
    String numeros = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (numeros.length >= 4) {
      String dia = numeros.substring(0, 2);
      String mes = numeros.substring(2, 4);
      return '$dia/$mes';
    }
    return input;
  }

  void _abrirModalPromocao({Map<String, String>? promocao, int? index}) {
    if (promocao != null) {
      _editIndex = index;
      _titulo = promocao['titulo']!;
      _descricao = promocao['descricao']!;
      _validade = promocao['validade']!;
    } else {
      _editIndex = null;
      _titulo = '';
      _descricao = '';
      _validade = '';
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: corFundo,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + screenHeight * 0.02,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            top: screenHeight * 0.02,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _editIndex == null ? 'Adicionar Promoção 🏷️' : 'Editar Promoção ✏️',
                    style: TextStyle(
                      fontSize: screenHeight * 0.025,
                      fontWeight: FontWeight.bold,
                      color: corTexto,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildTextField(
                    label: 'Nome da promoção',
                    icon: Icons.label,
                    initialValue: _titulo,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Informe o título';
                      if (value.trim().length < 3) return 'O título deve ter pelo menos 3 caracteres';
                      if (value.trim().length > 50) return 'O título deve ter no máximo 50 caracteres';
                      return null;
                    },
                    onSaved: (value) => _titulo = value!.trim(),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  _buildTextField(
                    label: 'Descrição',
                    icon: Icons.description,
                    initialValue: _descricao,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Informe a descrição';
                      if (value.trim().length > 200) return 'A descrição deve ter no máximo 200 caracteres';
                      return null;
                    },
                    onSaved: (value) => _descricao = value!.trim(),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  _buildTextField(
                    label: 'Validade (ex: 15/07)',
                    icon: Icons.calendar_today,
                    initialValue: _validade,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Informe a validade';
                      final regex = RegExp(r'^(\d{2})/(\d{2})$');
                      if (!regex.hasMatch(value)) return 'Formato inválido (use DD/MM)';
                      final match = regex.firstMatch(value)!;
                      final dia = int.parse(match.group(1)!);
                      final mes = int.parse(match.group(2)!);
                      if (dia < 1 || dia > 31 || mes < 1 || mes > 12) return 'Data inválida';
                      return null;
                    },
                    onSaved: (value) => _validade = formatarData(value!),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: corPrimaria,
                        foregroundColor: corTexto,
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.save),
                      label: Text(
                        _editIndex == null ? 'Salvar Promoção' : 'Salvar Alterações',
                        style: TextStyle(fontSize: screenHeight * 0.022),
                      ),
                      onPressed: _salvarPromocao,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    String? initialValue,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }

  void _salvarPromocao() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final novaPromocao = {
        'titulo': _titulo,
        'descricao': _descricao,
        'validade': _validade,
      };

      setState(() {
        if (_editIndex == null) {
          _promocoes.add(novaPromocao);
        } else {
          _promocoes[_editIndex!] = novaPromocao;
        }
      });

      Navigator.pop(context);
    }
  }

  void _excluirPromocao(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Promoção'),
        content: const Text('Tem certeza que deseja remover esta promoção?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              setState(() => _promocoes.removeAt(index));
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
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: _promocoes.isEmpty
            ? Center(
          child: Text(
            'Nenhuma promoção cadastrada ainda 🏷️',
            style: TextStyle(color: corTexto.withOpacity(0.6), fontSize: screenHeight * 0.02),
            textAlign: TextAlign.center,
          ),
        )
            : ListView.builder(
          itemCount: _promocoes.length,
          itemBuilder: (context, index) {
            final promo = _promocoes[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              margin: EdgeInsets.only(bottom: screenHeight * 0.015),
              color: Colors.white,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.012),
                title: Text(
                  promo['titulo']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: corTexto,
                    fontSize: screenHeight * 0.022,
                  ),
                ),
                subtitle: Text(
                  '${promo['descricao']!}\nVálido até ${promo['validade']!}',
                  style: TextStyle(color: corTexto.withOpacity(0.7), fontSize: screenHeight * 0.018),
                ),
                isThreeLine: true,
                trailing: Wrap(
                  spacing: 4,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: corTexto),
                      onPressed: () => _abrirModalPromocao(promocao: promo, index: index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _excluirPromocao(index),
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
        label: Text('Nova Promoção', style: TextStyle(fontWeight: FontWeight.bold, color: corTexto)),
        icon: Icon(Icons.add, color: corTexto),
        onPressed: () => _abrirModalPromocao(),
      ),
    );
  }
}
