import 'dart:ffi';

class PetShopService {
  final int? id;
  final String name;
  final double price;
  final int petShopId;

  PetShopService({this.id, required this.name, required this.price, required this.petShopId});

  factory PetShopService.fromJson(Map<String, dynamic> json) {
    return PetShopService(
      id: json['id'],
      name: json['name'],
      price: _parsePrice(json['price']),
      petShopId: json['petShopId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'petShopId': petShopId
    };
  }

  static double _parsePrice(dynamic price) {
    if (price is double) return price;
    if (price is int) return price.toDouble();
    if (price is String) {
      String cleaned = price.replaceAll('R\$', '').replaceAll(' ', '').replaceAll(',', '.');
      return double.tryParse(cleaned) ?? 0.0;
    }
    return 0.0;
  }

  String get formattedPrice => 'R\$ ${price.toStringAsFixed(2).replaceAll('.', ',')}';
}