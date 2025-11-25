class User {
  final int? id;
  final String email;
  final String password;
  final String name;
  final String surname;
  final String? profileImage;

  User(this.name, this.surname, this.email, this.password, {this.id, this.profileImage});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['name'] ?? '',
      json['surname'] ?? '',
      json['email'] ?? '',
      json['password'] ?? '',
      id: json['id'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'password': password,
      'profileImage': profileImage,
    };
  }
}