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
      price: double.tryParse(json['price'].toString()) ?? 0.0,
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
}