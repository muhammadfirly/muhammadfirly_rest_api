class User {
  final int id;
  final String name;
  final String email;
  final String? address;
  final String? photoUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.address,
    this.photoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      address: json['address'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'photoUrl': photoUrl,
    };
  }
}