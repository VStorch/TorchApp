class Pet {
  final int? id;
  final String name;
  final String breed;
  final String species;
  final double weight;
  final DateTime birthDate;
  final int userId; // <- ID do usuário dono do pet

  Pet(
      this.name,
      this.breed,
      this.species,
      this.weight,
      this.birthDate,
      this.userId, {
        this.id,
      });

  // Cria um objeto Pet a partir do JSON recebido do backend
  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      json['name'] ?? '',
      json['breed'] ?? '',
      json['species'] ?? '',
      (json['weight'] ?? 0).toDouble(),
      DateTime.parse(json['birthDate']),
      json['user'] != null
          ? json['user']['id'] ?? 0
          : json['userId'] ?? 0, // compatível com ambos formatos
      id: json['id'],
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
      'user': {
        'id': userId,
      }, // backend espera um objeto com o ID do user
    };
  }
}
