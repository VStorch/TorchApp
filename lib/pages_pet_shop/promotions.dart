import 'package:flutter/material.dart';
import 'package:torch_app/pages/login_page.dart';
import '../components/CustomDrawer.dart';
import '../models/menu_item.dart';
import 'home_page_pet_shop.dart';
import 'profile.dart';
import 'services.dart';
import 'reviews.dart';
import 'payment_method.dart';
import 'settings.dart';

class Promotions extends StatefulWidget {
  const Promotions({super.key});

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

  // Cores
  final Color corFundo = const Color(0xFFFBF8E1);
  final Color corPrimaria = const Color(0xFFF4E04D);
  final Color corTexto = Colors.black87;

  // Formata data automaticamente
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
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 25,
          ),
          child: Form(
            key: _formKey,
            child: Wrap(
              runSpacing: 12,
              children: [
                Center(
                  child: Text(
                    _editIndex == null
                        ? 'Adicionar Promoção 🏷️'
                        : 'Editar Promoção ✏️',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: corTexto.withValues(alpha: 255),
                    ),
                  ),
                ),
                TextFormField(
                  initialValue: _titulo,
                  decoration: InputDecoration(
                    labelText: 'Nome do serviço',
                    labelStyle: TextStyle(
                      color: corTexto.withValues(alpha: 153),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.label),
                  ),
                  validator: (value) =>
                  value!.isEmpty ? 'Informe o título da promoção' : null,
                  onSaved: (value) => _titulo = value!,
                ),
                TextFormField(
                  initialValue: _descricao,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    labelStyle: TextStyle(
                      color: corTexto.withValues(alpha: 153),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.description),
                  ),
                  validator: (value) =>
                  value!.isEmpty ? 'Informe a descrição' : null,
                  onSaved: (value) => _descricao = value!,
                ),
                TextFormField(
                  initialValue: _validade,
                  decoration: InputDecoration(
                    labelText: 'Validade (ex: 15/07)',
                    labelStyle: TextStyle(
                      color: corTexto.withValues(alpha: 153),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                  validator: (value) =>
                  value!.isEmpty ? 'Informe a validade' : null,
                  onSaved: (value) => _validade = formatarData(value!),
                ),
                const SizedBox(height: 10),
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
                    _editIndex == null ? 'Salvar Promoção' : 'Salvar Alterações',
                  ),
                  onPressed: _salvarPromocao,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
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
                  "Promoções",
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
        child: _promocoes.isEmpty
            ? Center(
          child: Text(
            'Nenhuma promoção cadastrada ainda 🏷️',
            style: TextStyle(color: corTexto.withValues(alpha: 153)),
          ),
        )
            : ListView.builder(
          itemCount: _promocoes.length,
          itemBuilder: (context, index) {
            final promo = _promocoes[index];
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
                  promo['titulo']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: corTexto,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  '${promo['descricao']!}\nVálido até ${promo['validade']!}',
                  style: TextStyle(color: corTexto.withValues(alpha: 179)),
                ),
                isThreeLine: true,
                trailing: Wrap(
                  spacing: 4,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: corTexto),
                      onPressed: () =>
                          _abrirModalPromocao(promocao: promo, index: index),
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
        label: Text(
          'Nova Promoção',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: corTexto,
          ),
        ),
        icon: Icon(Icons.add, color: corTexto),
        onPressed: () => _abrirModalPromocao(),
      ),
    );
  }
}
