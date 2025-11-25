import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class PixPaymentScreen extends StatefulWidget {
  final int petShopId;
  final String serviceName;
  final double finalPrice;
  final String appointmentDate;
  final String appointmentTime;
  final String? couponCode;

  const PixPaymentScreen({
    super.key,
    required this.petShopId,
    required this.serviceName,
    required this.finalPrice,
    required this.appointmentDate,
    required this.appointmentTime,
    this.couponCode,
  });

  @override
  State<PixPaymentScreen> createState() => _PixPaymentScreenState();
}

class _PixPaymentScreenState extends State<PixPaymentScreen> {
  final Color corFundo = const Color(0xFFFBF8E1);
  final Color corPrimaria = const Color(0xFFF4E04D);
  final Color corTexto = Colors.black87;

  String? pixCode;
  bool isLoadingPix = true;
  int countdown = 300; // 5 minutos em segundos
  Timer? countdownTimer;
  bool paymentConfirmed = false;

  // Dados PIX do pet shop
  Map<String, dynamic>? pixSettings;

  @override
  void initState() {
    super.initState();
    _loadPixSettingsAndGenerate();
    _startCountdown();
  }

  Future<void> _loadPixSettingsAndGenerate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'pix_settings_${widget.petShopId}';

      final enabled = prefs.getBool('${key}_enabled') ?? false;

      if (!enabled) {
        _showPixNotConfiguredDialog();
        return;
      }

      pixSettings = {
        'pixKey': prefs.getString('${key}_key') ?? '',
        'keyType': prefs.getString('${key}_key_type') ?? '',
        'merchantName': prefs.getString('${key}_merchant_name') ?? '',
        'merchantCity': prefs.getString('${key}_merchant_city') ?? '',
        'merchantId': prefs.getString('${key}_merchant_id') ?? '',
      };

      await _generatePixCode();
    } catch (e) {
      _showErrorDialog('Erro ao carregar configurações PIX: $e');
    }
  }

  void _showPixNotConfiguredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.orange[700]!, width: 2),
        ),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange[700], size: 24),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'PIX não configurado',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: const Text(
          'O pet shop ainda não configurou o pagamento via PIX. '
              'Por favor, escolha outro método de pagamento ou entre em contato.',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: corPrimaria,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop(false);
            },
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.red[700]!, width: 2),
        ),
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red[700], size: 24),
            const SizedBox(width: 8),
            const Text(
              'Erro',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: corPrimaria,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop(false);
            },
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() => countdown--);
      } else {
        timer.cancel();
        _showTimeoutDialog();
      }
    });
  }

  Future<void> _generatePixCode() async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      final code = _createPixCode();

      if (code.isEmpty) {
        throw Exception('Não foi possível gerar o código PIX');
      }

      setState(() {
        pixCode = code;
        isLoadingPix = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => isLoadingPix = false);
        _showErrorDialog('Erro ao gerar código PIX: ${e.toString()}');
      }
    }
  }

  String _createPixCode() {
    if (pixSettings == null) return '';

    try {
      final valor = widget.finalPrice.toStringAsFixed(2);
      final pixKey = (pixSettings!['pixKey'] ?? '').trim();

      // Limitar tamanho do nome e cidade (máximo 25 caracteres cada)
      String merchantName = (pixSettings!['merchantName'] ?? 'COMERCIANTE').toUpperCase().trim();
      if (merchantName.length > 25) {
        merchantName = merchantName.substring(0, 25);
      }

      String merchantCity = (pixSettings!['merchantCity'] ?? 'CIDADE').toUpperCase().trim();
      if (merchantCity.length > 15) {
        merchantCity = merchantCity.substring(0, 15);
      }

      // Validar chave PIX
      if (pixKey.isEmpty) {
        throw Exception('Chave PIX não configurada');
      }

      // Construir o payload PIX corretamente
      String payload = '000201'; // Payload Format Indicator (ID: 00, Tamanho: 02, Valor: 01)

      // Merchant Account Information (Tag 26)
      String merchantAccountInfo = '';
      merchantAccountInfo += '0014'; // GUI ID + tamanho
      merchantAccountInfo += 'br.gov.bcb.pix'; // GUI valor

      final pixKeyLength = pixKey.length.toString().padLeft(2, '0');
      merchantAccountInfo += '01$pixKeyLength$pixKey'; // Chave PIX

      final merchantAccountLength = merchantAccountInfo.length.toString().padLeft(2, '0');
      payload += '26$merchantAccountLength$merchantAccountInfo';

      payload += '52040000'; // Merchant Category Code
      payload += '5303986'; // Currency Code (986 = BRL)

      final valorLength = valor.length.toString().padLeft(2, '0');
      payload += '54$valorLength$valor'; // Transaction Amount

      payload += '5802BR'; // Country Code

      // Merchant Name
      final nameLength = merchantName.length.toString().padLeft(2, '0');
      payload += '59$nameLength$merchantName';

      // Merchant City
      final cityLength = merchantCity.length.toString().padLeft(2, '0');
      payload += '60$cityLength$merchantCity';

      // Additional Data Field Template (Tag 62)
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final txid = timestamp.length > 25 ? timestamp.substring(timestamp.length - 25) : timestamp.padLeft(25, '0');

      final txidLength = txid.length.toString().padLeft(2, '0');
      String additionalData = '05$txidLength$txid';

      final additionalDataLength = additionalData.length.toString().padLeft(2, '0');
      payload += '62$additionalDataLength$additionalData';

      // CRC16
      payload += '6304';
      final crc = _calculateCRC16(payload);
      final crcHex = crc.toRadixString(16).toUpperCase().padLeft(4, '0');
      payload += crcHex;

      return payload;
    } catch (e) {
      debugPrint('Erro ao gerar código PIX: $e');
      return '';
    }
  }

  int _calculateCRC16(String payload) {
    int crc = 0xFFFF;
    final bytes = payload.codeUnits;

    for (int byte in bytes) {
      crc ^= byte << 8;
      for (int i = 0; i < 8; i++) {
        if ((crc & 0x8000) != 0) {
          crc = (crc << 1) ^ 0x1021;
        } else {
          crc = crc << 1;
        }
      }
    }

    return crc & 0xFFFF;
  }

  String _formatCountdown() {
    final minutes = countdown ~/ 60;
    final seconds = countdown % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _copyPixCode() {
    if (pixCode != null) {
      Clipboard.setData(ClipboardData(text: pixCode!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Código PIX copiado!'),
            ],
          ),
          backgroundColor: Colors.green[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showTimeoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.red[700]!, width: 2),
        ),
        title: Row(
          children: [
            Icon(Icons.access_time, color: Colors.red[700], size: 20),
            const SizedBox(width: 4),
            const Expanded(
              child: Text(
                'Tempo Esgotado',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: const Text(
          'O tempo para pagamento expirou. Por favor, faça um novo agendamento.',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: corPrimaria,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop(false);
            },
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmPayment() async {
    setState(() => paymentConfirmed = true);

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.green[700]!, width: 2),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[700]),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Pagamento Confirmado!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'Seu pagamento foi processado com sucesso.\nO agendamento está confirmado!',
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: corPrimaria,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop(true);
              },
              child: const Text('Concluir'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
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
          onPressed: () => Navigator.pop(context, false),
        ),
        title: Text(
          'Pagamento PIX',
          style: TextStyle(color: corTexto, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoadingPix
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: corPrimaria),
            const SizedBox(height: 16),
            Text(
              'Gerando código PIX...',
              style: TextStyle(color: corTexto, fontSize: 16),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Informações do Agendamento
              Container(
                width: double.infinity,
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
                child: Column(
                  children: [
                    Icon(Icons.pets, size: 50, color: corPrimaria),
                    const SizedBox(height: 12),
                    Text(
                      widget.serviceName,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: corTexto,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.appointmentDate} às ${widget.appointmentTime}',
                      style: TextStyle(
                        fontSize: 16,
                        color: corTexto.withOpacity(0.7),
                      ),
                    ),
                    if (widget.couponCode != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Cupom: ${widget.couponCode}',
                          style: TextStyle(
                            color: Colors.green[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    const Divider(height: 24, thickness: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Valor Total:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'R\$ ${widget.finalPrice.toStringAsFixed(2).replaceAll('.', ',')}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Contador
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: countdown < 60 ? Colors.red[50] : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: countdown < 60 ? Colors.red[700]! : corPrimaria,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timer,
                      color: countdown < 60 ? Colors.red[700] : corTexto,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Tempo restante: ${_formatCountdown()}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: countdown < 60 ? Colors.red[700] : corTexto,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // QR Code PIX
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: corPrimaria, width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      'Escaneie o QR Code',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: corTexto,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: corPrimaria, width: 3),
                      ),
                      child: QrImageView(
                        data: pixCode!,
                        version: QrVersions.auto,
                        size: 250.0,
                        backgroundColor: Colors.white,
                        eyeStyle: QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: corTexto,
                        ),
                        dataModuleStyle: QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: corTexto,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Abra o app do seu banco e escaneie o código',
                      style: TextStyle(
                        fontSize: 14,
                        color: corTexto.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Opção PIX Copia e Cola
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: corPrimaria, width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      'Ou use o PIX Copia e Cola',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: corTexto,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: corFundo,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: corTexto.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        pixCode!,
                        style: TextStyle(
                          fontSize: 12,
                          color: corTexto,
                          fontFamily: 'monospace',
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: corPrimaria,
                          foregroundColor: corTexto,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.copy),
                        label: const Text(
                          'Copiar Código PIX',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: _copyPixCode,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Botão de Confirmação (simulação)
              if (!paymentConfirmed)
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
                        side: const BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                    icon: const Icon(Icons.check_circle, size: 28),
                    label: const Text(
                      'Já Paguei',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _confirmPayment,
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[700]!, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.green[700]),
                      const SizedBox(width: 12),
                      Text(
                        'Verificando pagamento...',
                        style: TextStyle(
                          color: Colors.green[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              Text(
                'Após o pagamento, o agendamento será confirmado automaticamente',
                style: TextStyle(
                  fontSize: 12,
                  color: corTexto.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}