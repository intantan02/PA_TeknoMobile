import 'package:hive/hive.dart';
import '../models/user.dart';
import '../models/book.dart';
import '../models/usersession.dart';

class DBService {
  static const String userBoxName = 'users';
  static const String sessionBoxName = 'user_session';
  static const String favoriteBoxName = 'favorite_books';

  // ===== USERS =====
  Future<void> insertUser(User user) async {
    final userBox = await Hive.openBox<User>(userBoxName);
    await userBox.put(user.id, user);
  }

  Future<User?> getUserByUsername(String username) async {
    final userBox = await Hive.openBox<User>(userBoxName);
    try {
      return userBox.values.firstWhere((u) => u.username == username);
    } catch (e) {
      return null;
    }
  }

  // ===== SESSION =====
  Future<void> insertSession(UserSession session) async {
    final sessionBox = Hive.box<UserSession>('user_session');
    await sessionBox.clear();
    await sessionBox.put('current', session);
  }

  Future<UserSession?> getSession() async {
    final sessionBox = Hive.box<UserSession>('user_session');
    return sessionBox.get('current');
  }

  Future<void> clearSession() async {
    final sessionBox = Hive.box<UserSession>('user_session');
    await sessionBox.clear();
  }

  // ===== FAVORITE BOOKS =====
  Future<bool> isFavorite(String bookId) async {
    final favBox = Hive.box<Book>(favoriteBoxName);
    return favBox.containsKey(bookId);
  }

  Future<void> addFavorite(Book book) async {
    final favBox = Hive.box<Book>(favoriteBoxName);
    await favBox.put(book.id, book);
  }

  Future<void> removeFavorite(String bookId) async {
    final favBox = Hive.box<Book>(favoriteBoxName);
    await favBox.delete(bookId);
  }

  Future<List<Book>> getFavorites() async {
    final favBox = Hive.box<Book>(favoriteBoxName);
    return favBox.values.toList();
  }
}