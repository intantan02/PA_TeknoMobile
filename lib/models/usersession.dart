import 'package:hive/hive.dart';

part 'usersession.g.dart';

@HiveType(typeId: 2)
class UserSession extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String username;

  @HiveField(2)
  String? email;

  @HiveField(3)
  String? fullName;

  UserSession({
    required this.id,
    required this.username,
    this.email,
    this.fullName,
  });
}