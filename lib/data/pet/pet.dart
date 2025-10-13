class Pet {
  final int? id;
  final String name;
  final String breed;
  final String species;
  final double weight;
  final DateTime birthDate;

  // Construtor principal (id nomeado)
  Pet(
      this.name,
      this.breed,
      this.species,
      this.weight,
      this.birthDate, {
        this.id, // id é nomeado
      });

  // Cria um objeto Pet a partir de um JSON (Map vindo do backend)
  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      json['name'] ?? '',
      json['breed'] ?? '',
      json['species'] ?? '',
      (json['weight'] ?? 0).toDouble(),
      DateTime.parse(json['birthDate']),
      id: json['id'], // id passado como nomeado
    );
  }

  // Converte o objeto Pet em JSON para enviar ao backend
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'species': species,
      'weight': weight,
      'birthDate': birthDate.toIso8601String(),
    };
  }
}
