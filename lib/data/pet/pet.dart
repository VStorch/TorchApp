class Pet {
  final int? id;
  final String name;
  final String breed;
  final String species;
  final double weight;
  final DateTime birthDate;
  final int userId;

  Pet(
      this.name,
      this.breed,
      this.species,
      this.weight,
      this.birthDate,
      this.userId, {
        this.id,
      });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      json['name'] ?? '',
      json['breed'] ?? '',
      json['species'] ?? '',
      (json['weight'] ?? 0).toDouble(),
      DateTime.parse(json['birthDate']),
      json['userId'] ?? (json['user']?['id'] ?? 0),
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'name': name,
      'breed': breed,
      'species': species,
      'weight': weight,
      'birthDate': birthDate.toIso8601String(),
      'userId': userId,
    };

    // Só inclui o id se ele não for null (para edição)
    if (id != null) {
      json['id'] = id!;
    }

    return json;
  }
}