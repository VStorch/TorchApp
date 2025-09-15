class PetShop {

final String name;
final String address;
final String phone;
bool isFavorite;

  PetShop({
    required this.name,
    required this.address,
    required this.phone,
    this.isFavorite = false,
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }
}
