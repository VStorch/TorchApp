import 'package:flutter/material.dart';
import '../components/custom_drawer_pet_shop.dart';

class PaymentMethod extends StatefulWidget {
  final int petShopId;
  final int userId;

  const PaymentMethod({
    super.key,
    required this.petShopId,
    required this.userId,
  });

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  final List<Map<String, dynamic>> _methods = [];
  int? _editIndex;
  String? _selectedMetodo;

  final Color corFundo = const Color(0xFFFBF8E1);
  final Color corPrimaria = const Color(0xFFF4E04D);
  final Color corTexto = Colors.black87;
  final Color corSelecionado = const Color(0xFFFAF59E);

  final Map<String, bool> _formasPadrao = {
    "Dinheiro": false,
    "PIX": false,
    "Cartão de crédito": false,
    "Cartão de débito": false,
  };

  void _mostrarAviso(String mensagem) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              color: corPrimaria.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black26, width: 1),
            ),
            child: Text(
              mensagem,
              style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  void _abrirModalMetodo({int? index}) {
    if (index != null) {
      _editIndex = index;
      _selectedMetodo = _methods[index]['formas'].entries
          .firstWhere((e) => e.value == true, orElse: () => const MapEntry('', false))
          .key;
      if (_selectedMetodo == '') _selectedMetodo = null;
    } else {
      _editIndex = null;
      _selectedMetodo = null;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: corFundo,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                left: 20,
                right: 20,
                top: 25,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _editIndex == null
                        ? 'Adicionar Forma de Pagamento 💳'
                        : 'Editar Forma de Pagamento ✏️',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: corTexto),
                  ),
                  const SizedBox(height: 20),
                  ..._formasPadrao.keys.map((key) {
                    final bool isSelected = _selectedMetodo == key;
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? corSelecionado : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: RadioListTile<String>(
                        title: Text(key),
                        value: key,
                        groupValue: _selectedMetodo,
                        activeColor: corPrimaria,
                        onChanged: (val) {
                          setModalState(() {
                            _selectedMetodo = val;
                          });
                        },
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: corPrimaria,
                      foregroundColor: corTexto,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.save),
                    label: Text(
                      _editIndex == null
                          ? 'Salvar Forma'
                          : 'Salvar Alteração',
                    ),
                    onPressed: _salvarMetodo,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _salvarMetodo() {
    if (_selectedMetodo == null) {
      _mostrarAviso('Selecione uma forma de pagamento!');
      return;
    }

    bool jaExiste = _methods.asMap().entries.any((entry) {
      int i = entry.key;
      Map metodo = entry.value;
      if (_editIndex != null && i == _editIndex) return false;
      return metodo['formas'][_selectedMetodo!] == true;
    });

    if (jaExiste) {
      _mostrarAviso('Este método já está cadastrado!');
      return;
    }

    Map<String, bool> novoMetodoMap = Map.from(_formasPadrao);
    novoMetodoMap.updateAll((key, value) => key == _selectedMetodo);

    final novoMetodo = {
      'formas': novoMetodoMap,
      'ativo': true,
    };

    setState(() {
      if (_editIndex == null) {
        _methods.add(novoMetodo);
      } else {
        _methods[_editIndex!] = novoMetodo;
      }
    });

    Navigator.pop(context);
  }

  void _excluirMetodo(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Método'),
        content: const Text('Tem certeza que deseja remover este método?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _methods.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _alternarAtivo(int index, bool value) {
    setState(() => _methods[index]['ativo'] = value);
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
                    "Forma de pagamento",
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
        child: _methods.isEmpty
            ? Center(
          child: Text(
            'Nenhum método de pagamento cadastrado 💳',
            style: TextStyle(color: corTexto.withOpacity(0.6), fontSize: screenHeight * 0.02),
            textAlign: TextAlign.center,
          ),
        )
            : ListView.builder(
          itemCount: _methods.length,
          itemBuilder: (context, index) {
            final metodo = _methods[index];
            final formasAtivas = metodo['formas']
                .entries
                .where((e) => e.value == true)
                .map((e) => e.key)
                .join(', ');

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              margin: EdgeInsets.only(bottom: screenHeight * 0.015),
              color: Colors.white,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.012),
                title: Text(
                  formasAtivas,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: corTexto, fontSize: screenHeight * 0.022),
                ),
                trailing: Wrap(
                  spacing: 4,
                  children: [
                    Switch(
                      value: metodo['ativo'],
                      onChanged: (v) => _alternarAtivo(index, v),
                      activeColor: corPrimaria,
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: corTexto),
                      onPressed: () => _abrirModalMetodo(index: index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _excluirMetodo(index),
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
        label: Text(
          'Novo Método',
          style: TextStyle(fontWeight: FontWeight.bold, color: corTexto),
        ),
        icon: Icon(Icons.add, color: corTexto),
        onPressed: () => _abrirModalMetodo(),
      ),
    );
  }
}