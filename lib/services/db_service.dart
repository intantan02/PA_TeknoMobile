import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;

  DBService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    return await openDatabase(
      path,
      version: 2, // Naikkan versi DB jadi 2
      onCreate: _createDB,
      onUpgrade: _upgradeDB, // Handle upgrade DB jika versi berubah
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Buat tabel users lengkap dengan kolom password
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        email TEXT,
        password TEXT,   -- kolom password untuk hash password
        token TEXT
      )
    ''');

    // Buat tabel favorite_books
    await db.execute('''
      CREATE TABLE favorite_books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        book_id TEXT UNIQUE,
        title TEXT,
        author TEXT,
        cover_url TEXT
      )
    ''');

    // Buat tabel user_session untuk simpan session login
    await db.execute('''
      CREATE TABLE user_session (
        id INTEGER PRIMARY KEY,
        username TEXT,
        email TEXT
      )
    ''');
  }

  // Fungsi upgrade DB (migrasi) jika ada versi baru
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Tambahkan kolom password di tabel users
      await db.execute('ALTER TABLE users ADD COLUMN password TEXT');

      // Buat tabel user_session baru
      await db.execute('''
        CREATE TABLE user_session (
          id INTEGER PRIMARY KEY,
          username TEXT,
          email TEXT
        )
      ''');
    }
  }

  // User session
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getUser() async {
    final db = await database;
    final result = await db.query('users', limit: 1);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<void> clearUser() async {
    final db = await database;
    await db.delete('users');
  }

  // Session management
  Future<void> clearSession() async {
    final db = await database;
    await db.delete('user_session');
  }

  Future<void> insertSession(Map<String, dynamic> session) async {
    final db = await database;
    await clearSession();
    await db.insert('user_session', session);
  }

  Future<Map<String, dynamic>?> getSession() async {
    final db = await database;
    final result = await db.query('user_session', limit: 1);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // Favorite books
  Future<bool> isFavorite(String bookId) async {
    final db = await database;
    final result = await db.query(
      'favorite_books',
      where: 'book_id = ?',
      whereArgs: [bookId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<void> addFavorite(Map<String, dynamic> bookData) async {
    final db = await database;
    await db.insert('favorite_books', bookData, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeFavorite(String bookId) async {
    final db = await database;
    await db.delete('favorite_books', where: 'book_id = ?', whereArgs: [bookId]);
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;
    return await db.query('favorite_books');
  }
}
