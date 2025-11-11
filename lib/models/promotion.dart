// lib/models/promotion.dart
class Promotion {
  final int? id;
  final String name;
  final String description;
  final String validity;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Promotion({
    this.id,
    required this.name,
    required this.description,
    required this.validity,
    this.createdAt,
    this.updatedAt,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      validity: json['validity'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'validity': validity,
    };
  }
}