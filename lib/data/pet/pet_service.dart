import 'pet.dart';

class PetService {
  final List<Pet> _pets = [];

  void adicionarPet(Pet pet) {
    _pets.add(pet);
  }

  void editarPet(Pet petAtualizado) {
    int index = _pets.indexWhere((pet) => pet.id == petAtualizado.id);
    if (index != -1) {
      _pets[index] = petAtualizado;
    }
  }

  void removerPet(int id) {
    _pets.removeWhere((pet) => pet.id == id);
  }

  List<Pet> get pets => _pets;
}
