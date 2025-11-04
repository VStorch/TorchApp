class PetShopDto {
  final String cep;
  final String state;
  final String city;
  final String neighborhood;
  final String street;
  final String number;
  final String complement;
  final String cnpj; // Temporariamente não pode ser nulo
  final int ownerId;

  PetShopDto ({
    required this.cep,
    required this.state,
    required this.city,
    required this.neighborhood,
    required this.street,
    required this.number,
    required this.complement,
    required this.cnpj,
    required this.ownerId,
});

  Map<String, dynamic> toJson() {
    return {
      "cep": cep,
      "state": state,
      "city": city,
      "neighborhood": neighborhood,
      "street": street,
      "number": number,
      "addressComplement": complement.isEmpty ? null : complement,
      'cnpj': cnpj,
      'ownerId': ownerId,
    };
  }
}