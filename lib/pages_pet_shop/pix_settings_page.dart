import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PixSettingsPage extends StatefulWidget {
  final int petShopId;
  final int userId;

  const PixSettingsPage({
    super.key,
    required this.petShopId,
    required this.userId,
  });

  @override
  State<PixSettingsPage> createState() => _PixSettingsPageState();
}

class _PixSettingsPageState extends State<PixSettingsPage> {
  final Color corFundo = const Color(0xFFFBF8E1);
  final Color corPrimaria = const Color(0xFFF4E04D);
  final Color corTexto = Colors.black87;

  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _pixKeyController = TextEditingController();
  final _merchantNameController = TextEditingController();
  final _merchantCityController = TextEditingController();
  final _merchantIdController = TextEditingController();

  // Tipo de chave PIX selecionado
  String _selectedKeyType = 'CPF';
  final List<String> _keyTypes = ['CPF', 'CNPJ', 'Email', 'Telefone', 'Chave Aleatória'];

  bool _isLoading = false;
  bool _pixEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadPixSettings();
  }

  Future<void> _loadPixSettings() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'pix_settings_${widget.petShopId}';

      if (mounted) {
        setState(() {
          _pixEnabled = prefs.getBool('${key}_enabled') ?? false;
          _selectedKeyType = prefs.getString('${key}_key_type') ?? 'CPF';
          _pixKeyController.text = prefs.getString('${key}_key') ?? '';
          _merchantNameController.text = prefs.getString('${key}_merchant_name') ?? '';
          _merchantCityController.text = prefs.getString('${key}_merchant_city') ?? '';
          _merchantIdController.text = prefs.getString('${key}_merchant_id') ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar configurações: ${e.toString()}'),
            backgroundColor: Colors.red[700],
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _savePixSettings() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'pix_settings_${widget.petShopId}';

      // Limpar a chave PIX antes de salvar
      final cleanedKey = _cleanPixKey(_pixKeyController.text);

      await prefs.setBool('${key}_enabled', _pixEnabled);
      await prefs.setString('${key}_key_type', _selectedKeyType);
      await prefs.setString('${key}_key', cleanedKey);
      await prefs.setString('${key}_merchant_name', _merchantNameController.text.trim());
      await prefs.setString('${key}_merchant_city', _merchantCityController.text.trim());
      await prefs.setString('${key}_merchant_id', _merchantIdController.text.trim());

      if (mounted) {
        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Configurações PIX salvas com sucesso!'),
              ],
            ),
            backgroundColor: Colors.green[700],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar configurações: ${e.toString()}'),
            backgroundColor: Colors.red[700],
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Limpa a chave PIX removendo caracteres especiais
  String _cleanPixKey(String value) {
    switch (_selectedKeyType) {
      case 'CPF':
      case 'CNPJ':
      case 'Telefone':
      // Remove tudo exceto números
        return value.replaceAll(RegExp(r'[^\d]'), '');
      case 'Email':
      // Remove espaços
        return value.trim().toLowerCase();
      case 'Chave Aleatória':
      // Remove espaços e converte para minúsculas
        return value.trim().toLowerCase();
      default:
        return value.trim();
    }
  }

  String? _validatePixKey(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, insira a chave PIX';
    }

    // Limpar o valor para validação
    final cleanedValue = _cleanPixKey(value);

    switch (_selectedKeyType) {
      case 'CPF':
        if (cleanedValue.length != 11) {
          return 'CPF deve ter 11 dígitos';
        }
        // Validação básica de CPF (todos dígitos iguais)
        if (RegExp(r'^(\d)\1{10}$').hasMatch(cleanedValue)) {
          return 'CPF inválido';
        }
        break;

      case 'CNPJ':
        if (cleanedValue.length != 14) {
          return 'CNPJ deve ter 14 dígitos';
        }
        // Validação básica de CNPJ (todos dígitos iguais)
        if (RegExp(r'^(\d)\1{13}$').hasMatch(cleanedValue)) {
          return 'CNPJ inválido';
        }
        break;

      case 'Email':
        if (!RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,}$').hasMatch(cleanedValue)) {
          return 'Email inválido';
        }
        break;

      case 'Telefone':
        if (cleanedValue.length < 10 || cleanedValue.length > 11) {
          return 'Telefone deve ter 10 ou 11 dígitos';
        }
        break;

      case 'Chave Aleatória':
        if (cleanedValue.length < 32) {
          return 'Chave aleatória deve ter no mínimo 32 caracteres';
        }
        break;
    }
    return null;
  }

  Widget _buildInfoCard(String title, String description, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!, width: 2),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[700], size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pixKeyController.dispose();
    _merchantNameController.dispose();
    _merchantCityController.dispose();
    _merchantIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        backgroundColor: corPrimaria,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Configurações PIX',
          style: TextStyle(
            color: corTexto,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: corPrimaria),
            const SizedBox(height: 16),
            Text(
              'Carregando configurações...',
              style: TextStyle(color: corTexto, fontSize: 16),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header com ícone
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: corPrimaria, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.pix,
                      size: 60,
                      color: corPrimaria,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Ativar/Desativar PIX
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: corPrimaria, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Aceitar PIX',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: corTexto,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ative para receber pagamentos via PIX',
                              style: TextStyle(
                                fontSize: 14,
                                color: corTexto.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _pixEnabled,
                        onChanged: (value) {
                          setState(() => _pixEnabled = value);
                        },
                        activeColor: Colors.green[700],
                        activeTrackColor: Colors.green[200],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Informação sobre PIX
                _buildInfoCard(
                  'Por que configurar o PIX?',
                  'Configure seus dados PIX para receber pagamentos instantâneos dos seus clientes diretamente no app.',
                  Icons.info_outline,
                ),

                const SizedBox(height: 24),

                // Formulário (só aparece se PIX estiver ativado)
                if (_pixEnabled) ...[
                  // Tipo de Chave PIX
                  Text(
                    'Tipo de Chave PIX',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: corTexto,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: corPrimaria, width: 2),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedKeyType,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down, color: corTexto),
                        style: TextStyle(
                          fontSize: 16,
                          color: corTexto,
                          fontWeight: FontWeight.w500,
                        ),
                        items: _keyTypes.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedKeyType = newValue;
                              _pixKeyController.clear();
                            });
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Chave PIX
                  Text(
                    'Chave PIX',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: corTexto,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getFormatInfo(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _pixKeyController,
                    decoration: InputDecoration(
                      hintText: _getHintForKeyType(),
                      prefixIcon: Icon(Icons.key, color: corPrimaria),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: corPrimaria, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: corPrimaria, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: corPrimaria, width: 3),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.red, width: 2),
                      ),
                    ),
                    validator: _validatePixKey,
                    keyboardType: _getKeyboardTypeForKey(),
                  ),

                  const SizedBox(height: 20),

                  // Nome do Beneficiário
                  Text(
                    'Nome do Beneficiário',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: corTexto,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _merchantNameController,
                    decoration: InputDecoration(
                      hintText: 'Nome completo ou razão social',
                      prefixIcon: Icon(Icons.business, color: corPrimaria),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: corPrimaria, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: corPrimaria, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: corPrimaria, width: 3),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor, insira o nome do beneficiário';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                  ),

                  const SizedBox(height: 20),

                  // Cidade
                  Text(
                    'Cidade',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: corTexto,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _merchantCityController,
                    decoration: InputDecoration(
                      hintText: 'Cidade do estabelecimento',
                      prefixIcon: Icon(Icons.location_city, color: corPrimaria),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: corPrimaria, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: corPrimaria, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: corPrimaria, width: 3),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor, insira a cidade';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                  ),

                  const SizedBox(height: 20),

                  // Merchant ID (Opcional)
                  Text(
                    'ID do Comerciante (Opcional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: corTexto,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _merchantIdController,
                    decoration: InputDecoration(
                      hintText: 'Identificador fornecido pelo banco',
                      prefixIcon: Icon(Icons.badge, color: corPrimaria),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: corPrimaria, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: corPrimaria, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: corPrimaria, width: 3),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Aviso de segurança
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange[300]!, width: 2),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.security, color: Colors.orange[700], size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Suas informações são armazenadas localmente no dispositivo.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange[900],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Botão Salvar
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.save, size: 28),
                      label: const Text(
                        'Salvar Configurações',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _isLoading ? null : _savePixSettings,
                    ),
                  ),
                ],

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getHintForKeyType() {
    switch (_selectedKeyType) {
      case 'CPF':
        return '123.456.789-00 ou 12345678900';
      case 'CNPJ':
        return '12.345.678/0001-90 ou 12345678000190';
      case 'Email':
        return 'seuemail@exemplo.com';
      case 'Telefone':
        return '(11) 99999-9999 ou 11999999999';
      case 'Chave Aleatória':
        return 'Cole sua chave aleatória aqui';
      default:
        return '';
    }
  }

  String _getFormatInfo() {
    switch (_selectedKeyType) {
      case 'CPF':
        return '✓ Pode digitar com ou sem pontuação (xxx.xxx.xxx-xx ou xxxxxxxxxxx)';
      case 'CNPJ':
        return '✓ Pode digitar com ou sem pontuação (xx.xxx.xxx/xxxx-xx ou xxxxxxxxxxxxxx)';
      case 'Telefone':
        return '✓ Pode digitar com ou sem pontuação ((xx) xxxxx-xxxx ou xxxxxxxxxxx)';
      case 'Email':
        return '✓ Digite seu email completo';
      case 'Chave Aleatória':
        return '✓ Cole a chave aleatória gerada pelo seu banco';
      default:
        return '';
    }
  }

  TextInputType _getKeyboardTypeForKey() {
    switch (_selectedKeyType) {
      case 'CPF':
      case 'CNPJ':
      case 'Telefone':
        return TextInputType.number;
      case 'Email':
        return TextInputType.emailAddress;
      default:
        return TextInputType.text;
    }
  }
}