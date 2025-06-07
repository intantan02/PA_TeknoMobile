import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/session_manager.dart';

class ApiService {
  static const String baseUrl =
      'https://api.itbook.store/1.0/new';

  // Login memakai username dan password (sesuai backend)
  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}login'), // endpoint login
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await SessionManager.saveToken(data['token']);
      return true;
    } else {
      return false;
    }
  }

  // Register dengan username, email, dan password (genre tidak ada di backend ini)
  Future<bool> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}register'), // endpoint register
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    return response.statusCode == 201;
  }

  // Ambil daftar buku, butuh token (backend sendiri)
  Future<List<dynamic>> fetchBooks() async {
    final token = await SessionManager.getToken();
    final response = await http.get(
      Uri.parse('${baseUrl}books'), // endpoint buku
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data; // langsung list buku (karena backend mengirim array buku langsung)
    } else {
      throw Exception('Gagal mengambil buku');
    }
  }

  // API baru: Ambil rekomendasi buku dari itbook.store (tanpa token)
  Future<List<dynamic>> fetchRecommendedBooks() async {
    final response = await http.get(Uri.parse('https://api.itbook.store/1.0/new'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['books']; // list buku
    } else {
      throw Exception('Gagal mengambil data rekomendasi buku');
    }
  }

  // Tambah buku baru, butuh token
  Future<bool> addBook(String title, String author) async {
    final token = await SessionManager.getToken();
    final response = await http.post(
      Uri.parse('${baseUrl}books'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'title': title, 'author': author}),
    );
    return response.statusCode == 201;
  }

  // Update buku by id, butuh token
  Future<bool> updateBook(int id, {String? title, String? author}) async {
    final token = await SessionManager.getToken();
    final body = <String, String>{};
    if (title != null) body['title'] = title;
    if (author != null) body['author'] = author;

    final response = await http.put(
      Uri.parse('${baseUrl}books/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    return response.statusCode == 200;
  }

  // Hapus buku by id, butuh token
  Future<bool> deleteBook(int id) async {
    final token = await SessionManager.getToken();
    final response = await http.delete(
      Uri.parse('${baseUrl}books/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200;
  }

  // Logout: hapus session token
  Future<void> logout() async {
    await SessionManager.clearSession();
  }

  // Kirim feedback, butuh token
  Future<bool> sendFeedback(String feedback) async {
    final token = await SessionManager.getToken();
    final response = await http.post(
      Uri.parse('${baseUrl}feedback'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'feedback': feedback}),
    );
    return response.statusCode == 201;
  }
}
