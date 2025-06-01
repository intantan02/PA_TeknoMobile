class User {
  final String id;
  final String username;
  final String passwordHash;
  final String? fullName;
  final String? email;
  final String? profileImageUrl;

  User({
    required this.id,
    required this.username,
    required this.passwordHash,
    this.fullName,
    this.email,
    this.profileImageUrl,
  });

  // Convert User object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'passwordHash': passwordHash,
      'fullName': fullName,
      'email': email,
      'profileImageUrl': profileImageUrl,
    };
  }

  // Create User object from JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      passwordHash: json['passwordHash'],
      fullName: json['fullName'],
      email: json['email'],
      profileImageUrl: json['profileImageUrl'],
    );
  }
}
