import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:crypto/crypto.dart';

part 'user.g.dart';

// Fungsi hash password
String hashPassword(String password) {
  return sha256.convert(utf8.encode(password)).toString();
}

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  int id; // ubah dari String ke int

  @HiveField(1)
  String username;

  @HiveField(2)
  String passwordHash;

  @HiveField(3)
  String? fullName;

  @HiveField(4)
  String? email;

  @HiveField(5)
  String? profileImageUrl;

  User({
    required this.id,
    required this.username,
    required this.passwordHash,
    this.fullName,
    this.email,
    this.profileImageUrl,
  });
}
