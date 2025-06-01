import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/session_manager.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await SessionManager.saveToken(data['token']);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(String name, String email, String password, String genre) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'genre': genre,
      }),
    );
    return response.statusCode == 201;
  }

  Future<List<dynamic>> fetchBooks() async {
    final token = await SessionManager.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/books'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['books']; // tergantung struktur JSON backend
    } else {
      throw Exception('Gagal mengambil buku');
    }
  }

  Future<void> sendFeedback(String feedback) async {
    final token = await SessionManager.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/feedback'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'feedback': feedback}),
    );

    if (response.statusCode != 201) {
      throw Exception('Gagal mengirim feedback');
    }
  }
}