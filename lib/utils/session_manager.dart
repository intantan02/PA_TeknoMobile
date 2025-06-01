import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyToken = 'auth_token';
  static const String _keyUser = 'user_data';

  /// Simpan token autentikasi
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  /// Ambil token autentikasi
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  /// Hapus token autentikasi
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
  }

  /// Simpan data user dalam bentuk JSON string
  static Future<void> saveUser(String userJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, userJson);
  }

  /// Ambil data user
  static Future<String?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUser);
  }

  /// Hapus data user
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUser);
  }

  /// Bersihkan token dan user (untuk logout)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUser);
  }

  /// Bersihkan semua sesi (jika ingin hapus semua data)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}