class User {
  final int id;
  final String dni;
  final String email;
  final String name;
  final String address;
  final String phone;
  final String photoUrl;
  final String rol;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.dni,
    required this.email,
    required this.name,
    required this.address,
    required this.phone,
    required this.photoUrl,
    required this.rol,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      dni: json['dni'],
      email: json['email'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      photoUrl: json['photo_url'],
      rol: json['rol'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dni': dni,
      'email': email,
      'name': name,
      'address': address,
      'phone': phone,
      'photo_url': photoUrl,
      'rol': rol,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
