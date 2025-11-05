import 'package:flutter/material.dart';
import '../components/CustomDrawer.dart';
import '../models/menu_item.dart';
import '../pages/login_page.dart';
import 'home_page_pet_shop.dart';
import 'profile.dart';
import 'reviews.dart';
import 'promotions.dart';
import 'payment_method.dart';
import 'settings.dart';

class Services extends StatefulWidget {
  //final int petShopId;
  //const Services({super.key, required this.petShopId});
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  final List<Map<String, dynamic>> _servicos = [];

  final _formKey = GlobalKey<FormState>();
  String _nome = '';
  String _preco = '';
  String _duracao = '';
  IconData _iconeSelecionado = Icons.pets;
  int? _editIndex;

  final Color corFundo = const Color(0xFFFBF8E1);
  final Color corPrimaria = const Color(0xFFF4E04D);
  final Color corTexto = Colors.black87;

  void _abrirModalServico({Map<String, dynamic>? servico, int? index}) {
    if (servico != null) {
      _editIndex = index;
      _nome = servico['nome'];
      _preco = servico['preco'].replaceAll('R\$', '').trim();
      _duracao = servico['duracao'];
      _iconeSelecionado = servico['icone'];
    } else {
      _editIndex = null;
      _nome = '';
      _preco = '';
      _duracao = '';
      _iconeSelecionado = Icons.pets;
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
                    _editIndex == null
                        ? 'Adicionar Novo Serviço 🐾'
                        : 'Editar Serviço ✏️',
                    style: TextStyle(
                      fontSize: screenHeight * 0.025,
                      fontWeight: FontWeight.bold,
                      color: corTexto,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildTextField(
                    label: 'Nome do serviço',
                    icon: Icons.text_fields,
                    initialValue: _nome,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Informe o nome';
                      if (value.trim().length < 3) return 'O nome deve ter pelo menos 3 caracteres';
                      if (value.trim().length > 50) return 'O nome deve ter no máximo 50 caracteres';
                      if (!RegExp(r'^[a-zA-ZÀ-ú ]+$').hasMatch(value.trim())) return 'O nome deve conter apenas letras e espaços';
                      return null;
                    },
                    onSaved: (value) => _nome = value!.trim(),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  _buildTextField(
                    label: 'Preço',
                    icon: Icons.attach_money,
                    initialValue: _preco,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    prefixText: 'R\$ ',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Informe o preço';
                      final preco = double.tryParse(value.replaceAll(',', '.'));
                      if (preco == null || preco <= 0) return 'Informe um preço válido';
                      return null;
                    },
                    onSaved: (value) => _preco = 'R\$ ${value!.trim()}',
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  _buildTextField(
                    label: 'Duração (ex: 1h ou 1:30)',
                    icon: Icons.timer,
                    initialValue: _duracao,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Informe a duração';
                      final regex = RegExp(r'^(\d{1,2}(:\d{2})?|(\d{1,2}h(\d{1,2})?))$');
                      if (!regex.hasMatch(value.trim())) return 'Formato inválido (ex: 1h ou 1:30)';
                      return null;
                    },
                    onSaved: (value) => _duracao = _formatarDuracao(value!.trim()),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  DropdownButtonFormField<IconData>(
                    value: _iconeSelecionado,
                    decoration: InputDecoration(
                      labelText: 'Ícone',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: const [
                      DropdownMenuItem(value: Icons.pets, child: Text('Banho / Tosa 🐶')),
                      DropdownMenuItem(value: Icons.local_hotel, child: Text('Hotel 🏨')),
                      DropdownMenuItem(value: Icons.child_friendly, child: Text('Creche 🧸')),
                      DropdownMenuItem(value: Icons.local_shipping, child: Text('Transporte 🚗')),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _iconeSelecionado = value);
                    },
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
                        _editIndex == null ? 'Salvar Serviço' : 'Salvar Alterações',
                        style: TextStyle(fontSize: screenHeight * 0.022),
                      ),
                      onPressed: _salvarServico,
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
    String? prefixText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefixText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon),
      ),
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }

  String _formatarDuracao(String valor) {
    if (valor.contains(':')) {
      final partes = valor.split(':');
      return '${partes[0]}h${partes[1]}min';
    } else if (valor.contains('h')) {
      return valor;
    } else {
      return '${valor}h';
    }
  }

  void _salvarServico() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final novoServico = {
        'icone': _iconeSelecionado,
        'nome': _nome,
        'preco': _preco,
        'duracao': _duracao,
        'ativo': true,
      };

      setState(() {
        if (_editIndex == null) {
          _servicos.add(novoServico);
        } else {
          _servicos[_editIndex!] = novoServico;
        }
      });

      Navigator.pop(context);
    }
  }

  void _excluirServico(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Serviço'),
        content: const Text('Tem certeza que deseja remover este serviço?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: corPrimaria, foregroundColor: corTexto),
            onPressed: () {
              setState(() => _servicos.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _alternarAtivo(int index, bool value) {
    setState(() => _servicos[index]['ativo'] = value);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final barHeight = screenHeight * 0.05;

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
                    "Serviços",
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
        child: _servicos.isEmpty
            ? Center(
          child: Text(
            'Nenhum serviço cadastrado ainda 🐕',
            style: TextStyle(color: corTexto.withOpacity(0.6), fontSize: screenHeight * 0.02),
            textAlign: TextAlign.center,
          ),
        )
            : ListView.builder(
          itemCount: _servicos.length,
          itemBuilder: (context, index) {
            final servico = _servicos[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              margin: EdgeInsets.only(bottom: screenHeight * 0.015),
              color: Colors.white,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.012),
                leading: Icon(servico['icone'], size: screenHeight * 0.04, color: corPrimaria),
                title: Text(
                  servico['nome'],
                  style: TextStyle(fontWeight: FontWeight.bold, color: corTexto, fontSize: screenHeight * 0.022),
                ),
                subtitle: Text(
                  '${servico['preco']}  •  ${servico['duracao']}',
                  style: TextStyle(color: corTexto.withOpacity(0.7), fontSize: screenHeight * 0.018),
                ),
                trailing: Wrap(
                  spacing: 4,
                  children: [
                    Switch(
                      value: servico['ativo'],
                      onChanged: (v) => _alternarAtivo(index, v),
                      activeColor: corPrimaria,
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: corTexto),
                      onPressed: () => _abrirModalServico(servico: servico, index: index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: corPrimaria),
                      onPressed: () => _excluirServico(index),
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
        label: Text('Novo Serviço', style: TextStyle(fontWeight: FontWeight.bold, color: corTexto)),
        icon: Icon(Icons.add, color: corTexto),
        onPressed: () => _abrirModalServico(),
      ),
    );
  }
}
