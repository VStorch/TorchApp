import 'package:flutter/material.dart';
import 'package:torch_app/components/custom_drawer_pet_shop.dart';
import 'package:torch_app/data/pet_shop_services/petshop_service.dart';
import '../data/pet_shop_services/pet_shop_service_service.dart';
import 'slots_service.dart'; // Importe a tela de slots

class Services extends StatefulWidget {
  final int petShopId;
  final int userId;

  const Services({super.key, required this.petShopId, required this.userId});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  List<PetShopService> _servicos = [];
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();
  String _nome = '';
  String _preco = '';
  int? _editId;

  final Color corFundo = const Color(0xFFFBF8E1);
  final Color corPrimaria = const Color(0xFFF4E04D);
  final Color corTexto = Colors.black87;

  @override
  void initState() {
    super.initState();
    _carregarServicos();
  }

  Future<void> _carregarServicos() async {
    setState(() => _isLoading = true);
    try {
      final servicos = await PetShopServiceService.getByPetShopId(widget.petShopId);
      setState(() {
        _servicos = servicos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('Erro ao carregar serviços: $e');
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(mensagem),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3)
        )
    );
  }

  void _mostrarSucesso(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(mensagem),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3)
        )
    );
  }

  void _abrirModalServico({PetShopService? servico}) {
    if (servico != null) {
      _editId = servico.id;
      _nome = servico.name;
      _preco = servico.price.toStringAsFixed(2).replaceAll('.', ',');
    } else {
      _editId = null;
      _nome = '';
      _preco = '';
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
                    _editId == null
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
                    onSaved: (value) => _preco = value!.trim(),
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
                        _editId == null ? 'Salvar Serviço' : 'Salvar Alterações',
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

  void _salvarServico() async{
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final preco = double.parse(_preco.replaceAll(',', '.'));

      final novoServico = PetShopService(
          id: _editId,
          name: _nome,
          price: preco,
          petShopId: widget.petShopId
      );

      Navigator.pop(context);

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator())
      );

      try {
        if (_editId == null) {
          final resultado = await PetShopServiceService.addService(novoServico);
          Navigator.pop(context);

          if (resultado != null) {
            _mostrarSucesso('Serviço atualizado com sucesso!');
            await _carregarServicos();
          } else {
            Navigator.pop(context);
            _mostrarErro('Erro ao atualizar serviço ');
          }
        }
      }catch (e) {
        Navigator.pop(context);
        _mostrarErro('Erro ao atualizar serviço: $e');
      }
    }
  }

  void _excluirServico(PetShopService servico) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Serviço'),
        content: Text('Tem certeza que deseja remover "${servico.name}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white
            ),
            onPressed: () async {
              Navigator.pop(context);

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(child: CircularProgressIndicator()),
              );

              final sucesso = await PetShopServiceService.deleteService(servico.id!);
              Navigator.pop(context);

              if (sucesso) {
                _mostrarSucesso('Serviço excluído com sucesso!');
                await _carregarServicos();
              } else {
                _mostrarErro('Erro ao excluir serviço');
              }
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _abrirGerenciadorHorarios(int serviceId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScheduleManagerPage(
          serviceId: serviceId,
          petShopId: widget.petShopId, // Passa o petShopId
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _carregarServicos,
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: _servicos.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pets, size: 64, color: corTexto.withOpacity(0.3)),
                SizedBox(height: 16),
                Text(
                  'Nenhum serviço cadastrado ainda 🐕',
                  style: TextStyle(
                    color: corTexto.withOpacity(0.6),
                    fontSize: screenHeight * 0.02,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Arraste para baixo para atualizar',
                  style: TextStyle(
                    color: corTexto.withOpacity(0.4),
                    fontSize: screenHeight * 0.016,
                  ),
                ),
              ],
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
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.012,
                      ),
                      leading: Icon(Icons.pets, size: screenHeight * 0.04, color: corPrimaria),
                      title: Text(
                        servico.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: corTexto,
                          fontSize: screenHeight * 0.022,
                        ),
                      ),
                      subtitle: Text(
                        servico.formattedPrice,
                        style: TextStyle(
                          color: corTexto.withOpacity(0.7),
                          fontSize: screenHeight * 0.018,
                        ),
                      ),
                      trailing: Wrap(
                        spacing: 4,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: corTexto),
                            onPressed: () => _abrirModalServico(servico: servico),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _excluirServico(servico),
                          ),
                        ],
                      ),
                    ),
                    // Botão para gerenciar horários
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        screenWidth * 0.04,
                        0,
                        screenWidth * 0.04,
                        screenHeight * 0.012,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: corPrimaria,
                            foregroundColor: corTexto,
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.012,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: Icon(Icons.schedule, size: screenHeight * 0.022),
                          label: Text(
                            'Gerenciar Horários',
                            style: TextStyle(
                              fontSize: screenHeight * 0.018,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () => _abrirGerenciadorHorarios(servico.id!),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: corPrimaria,
        label: Text(
            'Novo Serviço',
            style: TextStyle(fontWeight: FontWeight.bold, color: corTexto)
        ),
        icon: Icon(Icons.add, color: corTexto),
        onPressed: () => _abrirModalServico(),
      ),
    );
  }
}