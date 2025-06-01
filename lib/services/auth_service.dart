import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';
import 'db_service.dart';

class AuthService {
  final DBService _dbService = DBService();

  // Hash password menggunakan SHA-256
  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // Register user baru
  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final db = await _dbService.database;

    // Cek apakah username atau email sudah ada di database
    final existing = await db.query(
      'users',
      where: 'username = ? OR email = ?',
      whereArgs: [username, email],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      // Username atau email sudah terpakai
      return false;
    }

    final hashedPassword = _hashPassword(password);

    try {
      await db.insert('users', {
        'username': username,
        'email': email,
        'password': hashedPassword,
      });
      return true;
    } catch (e) {
      print('Error register user: $e');
      return false;
    }
  }

  // Login user berdasarkan username dan password
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    final db = await _dbService.database;
    final hashedPassword = _hashPassword(password);

    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, hashedPassword],
      limit: 1,
    );

    if (result.isNotEmpty) {
      // Simpan session user yang berhasil login
      await _saveSession(result.first);
      return true;
    }
    return false;
  }

  // Simpan session user saat login
  Future<void> _saveSession(Map<String, dynamic> user) async {
    final db = await _dbService.database;

    try {
      await db.transaction((txn) async {
        await txn.delete('user_session'); // Hapus session lama
        await txn.insert('user_session', {
          'id': user['id'],
          'username': user['username'],
          'email': user['email'],
        });
      });
    } catch (e) {
      print('Failed to save session: $e');
    }
  }

  // Ambil user session yang sedang login
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final db = await _dbService.database;
    final result = await db.query('user_session', limit: 1);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // Logout user dan hapus session
  Future<void> logout() async {
    final db = await _dbService.database;
    await db.delete('user_session');
  }
}
