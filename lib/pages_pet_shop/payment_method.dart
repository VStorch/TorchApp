import 'package:flutter/material.dart';
import 'package:torch_app/pages/login_page.dart';
import '../components/CustomDrawer.dart';
import '../models/menu_item.dart';
import 'home_page_pet_shop.dart';
import 'profile.dart';
import 'services.dart';
import 'reviews.dart';
import 'promotions.dart';
import 'settings.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  final List<Map<String, dynamic>> _methods = [];
  int? _editIndex;
  String? _selectedMetodo;

  // Cores padrão
  final Color corFundo = const Color(0xFFFBF8E1);
  final Color corPrimaria = const Color(0xFFF4E04D);
  final Color corTexto = Colors.black87;
  final Color corSelecionado = const Color(0xFFFAF59E); // fundo do item selecionado

  final Map<String, bool> _formasPadrao = {
    "Dinheiro": false,
    "PIX": false,
    "Cartão de crédito": false,
    "Cartão de débito": false,
  };

  void _abrirModalMetodo({int? index}) {
    if (index != null) {
      _editIndex = index;
      _selectedMetodo = _methods[index]['formas'].entries
          .firstWhere((e) => e.value == true,
          orElse: () => const MapEntry('', false))
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
                bottom: MediaQuery.of(context).viewInsets.bottom,
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
                      _editIndex == null ? 'Salvar Forma' : 'Salvar Alteração',
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione uma forma de pagamento!'),
        ),
      );
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
    return Scaffold(
      backgroundColor: corFundo,
      drawer: CustomDrawer(
        menuItems: [
          MenuItem(title: "Início", icon: Icons.home, destinationPage: const HomePagePetShop()),
          MenuItem(title: "Perfil", icon: Icons.person, destinationPage: const Profile()),
          MenuItem(title: "Serviços", icon: Icons.build, destinationPage: Services()),
          MenuItem(title: "Avaliações", icon: Icons.star, destinationPage: const Reviews()),
          MenuItem(title: "Promoções", icon: Icons.local_offer, destinationPage: const Promotions()),
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
                  "Forma de pagamento",
                  style: TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _methods.isEmpty
            ? Center(
          child: Text(
            'Nenhum método de pagamento cadastrado 💳',
            style: TextStyle(color: corTexto.withOpacity(0.6)),
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
              margin: const EdgeInsets.only(bottom: 12),
              color: Colors.white,
              child: ListTile(
                title: Text(
                  formasAtivas,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: corTexto),
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
