import 'package:hive/hive.dart';
import 'package:rekomendasi_buku/models/usersession.dart';
import '../models/user.dart';

class AuthService {
  static const String userBoxName = 'users';
  static const String sessionBoxName = 'user_session';

  // Register user baru
  Future<bool> register({
    required String username,
    required String password,
    String? fullName,
    String? email,
    String? profileImageUrl,
  }) async {
    final userBox = await Hive.openBox<User>(userBoxName);

    // Cek apakah username atau email sudah ada
    final exists = userBox.values.any((u) =>
        u.username == username || (email != null && u.email == email));
    if (exists) return false;

    // Hitung ID baru (auto increment)
    final newId = userBox.isEmpty
        ? 1
        : (userBox.values.map((u) => u.id).reduce((a, b) => a > b ? a : b) + 1);

    final user = User(
      id: newId,
      username: username,
      passwordHash: hashPassword(password),
      fullName: fullName,
      email: email,
      profileImageUrl: profileImageUrl,
    );

    await userBox.put(newId, user);
    return true;
  }

  // Login user
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    final userBox = await Hive.openBox<User>(userBoxName);
    final sessionBox = Hive.box<UserSession>('user_session');

    try {
      final user = userBox.values.firstWhere(
        (u) => u.username == username && u.passwordHash == hashPassword(password),
        orElse: () => throw Exception('User not found'),
      );
      await sessionBox.clear();
      await sessionBox.put('current', user as UserSession);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Ambil user session saat ini
  Future<UserSession?> getCurrentUser() async {
    final sessionBox = await Hive.openBox<UserSession>(sessionBoxName);
    return sessionBox.get('current');
  }

  // Logout
  Future<void> logout() async {
    final sessionBox = await Hive.openBox<User>(sessionBoxName);
    await sessionBox.clear();
  }
}
