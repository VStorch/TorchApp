import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  static const Color bgColor = Color(0xFFFBF8E1);
  static const Color yellow = Color(0xFFF7E34D);

  final List<TextEditingController> _controllers =
  List.generate(5, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());

  void _onChanged(String value, int index) {
    if (value.length == 1) {
      if (index + 1 < _focusNodes.length) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        _focusNodes[index].unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  String getOtp() => _controllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            /// Faixa amarela em cima
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 50, // diminuído
                color: yellow,
              ),
            ),

            /// Faixa amarela embaixo
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 50, // diminuído
                color: yellow,
              ),
            ),

            /// Conteúdo central
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // linha preta em cima
                  Container(height: 1, color: Colors.black),

                  const SizedBox(height: 16),

                  const Text(
                    "Digite o código de 5 dígitos que enviamos para\nE-mail: leo********@gmail.com",
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),

                  const SizedBox(height: 22),

                  // caixas OTP
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

                  // Reenviar Código
                  const Text(
                    "Renviar Código",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // botões
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
                              horizontal: 36, vertical: 14),
                        ),
                        child: const Text(
                          "Voltar",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          final otp = getOtp();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('OTP: $otp')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: yellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 34, vertical: 14),
                        ),
                        child: const Text(
                          "Continuar",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // linha preta embaixo
                  Container(height: 1, color: Colors.black),
                ],
              ),
            ),

            /// Animação Lottie no rodapé
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50), // acompanha a faixa
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
