class PetShop {

  final int? id;
  final String name;
  final String cep;
  final String state;
  final String city;
  final String neighborhood;
  final String street;
  final String number;
  final String? addressComplement;
  final String phone;
  final String email;
  final String cnpj;
  bool isFavorite;

  PetShop({
    this.id,
    required this.name,
    required this.cep,
    required this.state,
    required this.city,
    required this.neighborhood,
    required this.street,
    required this.number,
    this.addressComplement,
    required this.phone,
    required this.email,
    required this.cnpj,
    this.isFavorite = false,
  });

  factory PetShop.fromJson(Map<String, dynamic> json) {
    return PetShop(
      id: json['id'],
      name: json['name'],
      cep: json['cep'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      neighborhood: json['neighborhood'] ?? '',
      street: json['street'] ?? '',
      number: json['number'] ?? '',
      addressComplement: json['addressComplement'],
      cnpj: json['cnpj'] ?? '',
      phone: json['phone'],
      email: json['email'],
      isFavorite: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'cep': cep,
      'state': state,
      'city': city,
      'neighborhood': neighborhood,
      'street': street,
      'number': number,
      if (addressComplement != null) 'addressComplement': addressComplement,
      'cnpj': cnpj,
      'phone': phone,
      'email': email,
    };
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }

  String get fullAddress {
    final base = '$street, $number${addressComplement != null ? ', $addressComplement' : ''}';
    return '$base - $neighborhood, $city - $state';
  }
}