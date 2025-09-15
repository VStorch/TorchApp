import 'pet.dart';

class PetService {
  final List<Pet> _pets = [];
  int _nextId = 1; // gera IDs únicos

  void adicionarPet(Pet pet) {
    final petComId = Pet(
      _nextId++, // gera id único
      pet.name,
      pet.breed,
      pet.weight,
      pet.birthDate,
    );
    _pets.add(petComId);
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
