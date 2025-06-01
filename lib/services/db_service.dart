import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;
  DBService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'booklist.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY,
        bookId INTEGER UNIQUE,
        title TEXT,
        author TEXT,
        coverUrl TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        username TEXT UNIQUE,
        email TEXT,
        token TEXT
      )
    ''');
  }

  Future<bool> isFavorite(int bookId) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'bookId = ?',
      whereArgs: [bookId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<int> addFavorite(Map<String, dynamic> book) async {
    final db = await database;
    return await db.insert('favorites', book, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> removeFavorite(int bookId) async {
    final db = await database;
    return await db.delete('favorites', where: 'bookId = ?', whereArgs: [bookId]);
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;
    return await db.query('favorites');
  }

  Future<void> clearFavorites() async {
    final db = await database;
    await db.delete('favorites');
  }

  // User session data local storage
  Future<int> saveUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getUser() async {
    final db = await database;
    final users = await db.query('users');
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  Future<void> clearUser() async {
    final db = await database;
    await db.delete('users');
  }
}
