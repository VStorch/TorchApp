// Adicione este import no seu booking_page.dart
// import 'pix_payment_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';

class PixPaymentScreen extends StatefulWidget {
  final String serviceName;
  final double finalPrice;
  final String appointmentDate;
  final String appointmentTime;
  final String? couponCode;

  const PixPaymentScreen({
    super.key,
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

  @override
  void initState() {
    super.initState();
    _generatePixCode();
    _startCountdown();
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
    // Simula a geração do código PIX
    // Em produção, você deve chamar sua API backend para gerar o código PIX real
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      // Código PIX de exemplo (formato simplificado)
      // Em produção, use o código PIX real gerado pela sua instituição financeira
      pixCode = _createMockPixCode();
      isLoadingPix = false;
    });
  }

  String _createMockPixCode() {
    // Este é apenas um exemplo para demonstração
    // Em produção, você deve gerar um código PIX válido através da API do seu banco
    final valor = widget.finalPrice.toStringAsFixed(2);
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // Formato simplificado de código PIX (apenas para demonstração)
    return '00020126580014br.gov.bcb.pix0136$timestamp'
        '520400005303986540$valor'
        '5802BR5925SEU PETSHOP LTDA6009SAO PAULO62070503***63041D3D';
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
            Icon(Icons.access_time, color: Colors.red[700]),
            const SizedBox(width: 8),
            const Text('Tempo Esgotado'),
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
    // Aqui você deve implementar a verificação real do pagamento
    // Por enquanto, vamos simular uma confirmação
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
              const Text('Pagamento Confirmado!'),
            ],
          ),
          content: const Text(
            'Seu pagamento foi processado com sucesso. O agendamento está confirmado!',
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