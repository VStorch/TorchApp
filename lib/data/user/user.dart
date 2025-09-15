class User {
  // id pode ser nulo, pois quando o usuário for criado, obviamente não estará no backend
  final int? id;

  final String email;
  final String password;
  final String name;
  final String surname;


// Definição da classe User
  User(this.name, this.surname, this.email, this.password, {this.id});

  // Cria um objeto User com base nos dados do backend
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        json['name'] ?? '',
        json['surname'] ?? '',
        json['email'] ?? '',
        json['password'] ?? '',
        id: json['id']
    );
  }

  // Envia para o backend, converte em Json os dados
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'password': password,
    };
  }
}