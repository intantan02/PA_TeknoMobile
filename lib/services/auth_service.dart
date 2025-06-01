import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/encryption.dart';
import '../utils/session_manager.dart';

class AuthService {
  static const String baseUrl = 'https://www.googleapis.com/books/v1/volumes'; // Ganti dengan URL API asli

  Future<bool> login(String username, String password) async {
    final encryptedPassword = Encryption.encryptPassword(password);
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': encryptedPassword,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Simpan token dan user info ke session
      await SessionManager.saveToken(data['token']);
      await SessionManager.saveUser(data['user']);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    final encryptedPassword = Encryption.encryptPassword(password);
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': encryptedPassword,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    await SessionManager.clearSession();
  }
}
