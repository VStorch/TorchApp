// lib/models/promotion.dart
class Promotion {
  final int? id;
  final String name;
  final String description;
  final String validity;
  final String? couponCode;
  final double? discountPercent;
  final int? petShopId; // ← NOVO: ID do pet shop
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Promotion({
    this.id,
    required this.name,
    required this.description,
    required this.validity,
    this.couponCode,
    this.discountPercent,
    this.petShopId, // ← NOVO
    this.createdAt,
    this.updatedAt,
  });

  // Cria uma instância a partir de JSON
  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      validity: json['validity'] ?? '',
      couponCode: json['couponCode'],
      discountPercent: json['discountPercent'] != null
          ? (json['discountPercent'] as num).toDouble()
          : null,
      petShopId: json['petShopId'], // ← NOVO
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  // Converte para JSON (para enviar ao backend)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'validity': validity,
      if (couponCode != null && couponCode!.isNotEmpty) 'couponCode': couponCode,
      if (discountPercent != null) 'discountPercent': discountPercent,
      if (petShopId != null) 'petShopId': petShopId, // ← NOVO
    };
  }

  // Calcula o valor final com desconto aplicado
  double calcularValorComDesconto(double valorOriginal) {
    if (discountPercent == null || discountPercent! <= 0 || valorOriginal <= 0) {
      return valorOriginal;
    }
    final desconto = valorOriginal * (discountPercent! / 100);
    return valorOriginal - desconto;
  }

  // Retorna apenas o valor do desconto
  double calcularValorDesconto(double valorOriginal) {
    if (discountPercent == null || discountPercent! <= 0 || valorOriginal <= 0) {
      return 0;
    }
    return valorOriginal * (discountPercent! / 100);
  }

  // Verifica se a promoção ainda é válida
  bool isValida() {
    try {
      final validityDate = DateTime.parse(validity);
      final hoje = DateTime.now();
      return validityDate.isAfter(hoje) ||
          validityDate.year == hoje.year &&
              validityDate.month == hoje.month &&
              validityDate.day == hoje.day;
    } catch (e) {
      return false;
    }
  }

  // Verifica se o cupom está disponível e configurado
  bool temCupom() {
    return couponCode != null &&
        couponCode!.isNotEmpty &&
        discountPercent != null &&
        discountPercent! > 0;
  }

  // Retorna uma descrição formatada do desconto
  String getDescontoFormatado() {
    if (discountPercent == null || discountPercent! <= 0) {
      return '';
    }
    return '${discountPercent!.toStringAsFixed(0)}% OFF';
  }

  // Formata o código do cupom para exibição
  String getCupomFormatado() {
    if (couponCode == null || couponCode!.isEmpty) {
      return 'SEM CUPOM';
    }
    return couponCode!.toUpperCase();
  }

  // Retorna os dias restantes até expirar
  int diasRestantes() {
    try {
      final validityDate = DateTime.parse(validity);
      final hoje = DateTime.now();
      return validityDate.difference(hoje).inDays;
    } catch (e) {
      return 0;
    }
  }

  // Verifica se está prestes a expirar (menos de 7 dias)
  bool estaProximoDeExpirar() {
    final dias = diasRestantes();
    return dias >= 0 && dias <= 7;
  }

  // Cria uma cópia com campos modificados
  Promotion copyWith({
    int? id,
    String? name,
    String? description,
    String? validity,
    String? couponCode,
    double? discountPercent,
    int? petShopId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Promotion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      validity: validity ?? this.validity,
      couponCode: couponCode ?? this.couponCode,
      discountPercent: discountPercent ?? this.discountPercent,
      petShopId: petShopId ?? this.petShopId, // ← NOVO
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Sobrescreve toString para facilitar debug
  @override
  String toString() {
    return 'Promotion(id: $id, name: $name, couponCode: $couponCode, discountPercent: $discountPercent%, petShopId: $petShopId, validity: $validity)';
  }

  // Sobrescreve equals para comparação
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Promotion && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}