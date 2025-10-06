import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CepController {
  final TextEditingController cep = TextEditingController();
  final TextEditingController estado = TextEditingController();
  final TextEditingController cidade = TextEditingController();
  final TextEditingController bairro = TextEditingController();
  final TextEditingController endereco = TextEditingController();

  /// Busca o CEP na API ViaCEP e preenche os controllers
  Future<bool> buscarCep() async {
    final String cepValor = cep.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (cepValor.length != 8) {
      return false; // CEP inválido
    }

    final url = Uri.parse('https://viacep.com.br/ws/$cepValor/json/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('erro')) {
        return false; // CEP não encontrado
      }

      estado.text = data['uf'] ?? '';
      cidade.text = data['localidade'] ?? '';
      bairro.text = data['bairro'] ?? '';
      endereco.text = data['logradouro'] ?? '';

      return true;
    } else {
      return false; // erro na requisição
    }
  }

  void dispose() {
    cep.dispose();
    estado.dispose();
    cidade.dispose();
    bairro.dispose();
    endereco.dispose();
  }
}
