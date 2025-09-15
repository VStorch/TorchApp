import 'package:torch_app/data/pet_shop/pet_shop.dart';

class PetShopService {
  final List<PetShop> _petShops = [
    PetShop(
        name: "Pet shop Realeza",
        address: "Rua Adriano Kormann",
        phone: "(48) 99999-9999"),
    PetShop(
        name: "Pet Feliz",
        address: "Av. Central, 123",
        phone: "(48) 98888-8888"),
  ];

  List<PetShop> getPetShops() => _petShops;

  void toggleFavorite(PetShop shop) {
    shop.toggleFavorite();
  }
}
