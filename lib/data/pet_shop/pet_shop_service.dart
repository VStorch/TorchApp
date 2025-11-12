import 'package:torch_app/data/pet_shop/pet_shop.dart';

class PetShopService {
  final List<PetShop> _petShops = [
    PetShop(
        id: 1,
        name: "Pet shop Realeza",
        cep: "89110-976",
        state: 'SC',
        city: 'Gaspar',
        neighborhood: 'Bela Vista',
        street: 'Anfilóquio Nunes',
        number: '5274',
        addressComplement: 'Fundos',
        phone: "(48) 99999-9999",
        email: 'realeza@email.com',
        cnpj: '39.659.321/0001-38'
    ),
  ];

  List<PetShop> getPetShops() => _petShops;

  void toggleFavorite(PetShop shop) {
    shop.toggleFavorite();
  }
}
