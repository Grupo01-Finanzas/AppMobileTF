class User {
  int? id;
  String? dni;
  String? email;
  String? name;
  String? address;
  String? phone;
  String? photoUrl;
  String? rol;
  String? password;

  User({
    required this.id,
    required this.dni,
    required this.email,
    required this.name,
    required this.address,
    required this.phone,
    required this.photoUrl,
    required this.rol,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      dni: json['dni'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      rol: json['rol'] ?? '',
      password: json['password'] ?? json['dni'],
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
      'password': password,
    };
  }
}
