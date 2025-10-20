import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import '../data/user/verification_pet_shop/verification_services.dart';
import 'user_information.dart';

class VerificationPage extends StatefulWidget {
  final String email;

  const VerificationPage({super.key, required this.email});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  static const Color bgColor = Color(0xFFFBF8E1);
  static const Color yellow = Color(0xFFF7E34D);

  final List<TextEditingController> _controllers =
  List.generate(5, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());

  /// 🔒 Função para mascarar o e-mail exibido na tela
  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;

    final name = parts[0];
    final domain = parts[1];

    final maskedName = name.length > 3
        ? '${name.substring(0, 3)}***'
        : '${name.substring(0, 1)}***';

    final domainName = domain.split('.').first;
    return '$maskedName@${domainName}...';
  }

  void _onChanged(String value, int index) {
    if (value.length == 1 && index + 1 < _focusNodes.length) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  String getOtp() => _controllers.map((c) => c.text).join();

  Future<void> _verifyCode() async {
    final code = getOtp();

    if (code.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite o código completo de 5 dígitos.')),
      );
      return;
    }

    try {
      await VerificationService.checkVerificationCode(widget.email, code);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Código verificado com sucesso!')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserInformationPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(height: 50, color: yellow),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(height: 50, color: yellow),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(height: 1, color: Colors.black),
                  const SizedBox(height: 16),
                  Text(
                    "Digite o código de 5 dígitos enviado para\nE-mail: ${_maskEmail(widget.email)}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      return Container(
                        width: 56,
                        height: 56,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        child: TextField(
                          controller: _controllers[i],
                          focusNode: _focusNodes[i],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(1),
                          ],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            counterText: '',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onChanged: (v) => _onChanged(v, i),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Reenviar Código",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: yellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 36,
                            vertical: 14,
                          ),
                        ),
                        child: const Text(
                          "Voltar",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _verifyCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: yellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 34,
                            vertical: 14,
                          ),
                        ),
                        child: const Text(
                          "Continuar",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(height: 1, color: Colors.black),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: SizedBox(
                  height: 200,
                  child: Lottie.asset(
                    'lib/assets/images/Doodles.json',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
