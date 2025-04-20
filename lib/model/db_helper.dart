import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'history_v2.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            data TEXT,
            detail TEXT
          )
        ''');
        
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            email TEXT UNIQUE,
            password TEXT,
            created_at TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE users (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              username TEXT UNIQUE,
              email TEXT UNIQUE,
              password TEXT,
              created_at TEXT
            )
          ''');
        }
      },
    );
  }

  // Existing history methods
  Future<void> insertHistory(String name, String data, String detail) async {
    final dbClient = await db;
    await dbClient.insert('history', {
      'name': name,
      'data': data,
      'detail': detail,
    });
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final dbClient = await db;
    return await dbClient.query('history', orderBy: 'id DESC');
  }

  Future<void> deleteHistory(int id) async {
    final dbClient = await db;
    await dbClient.delete('history', where: 'id = ?', whereArgs: [id]);
  }

  // New methods for user authentication
  Future<int> registerUser(String username, String email, String password) async {
    final dbClient = await db;
    final now = DateTime.now().toIso8601String();
    
    return await dbClient.insert('users', {
      'username': username,
      'email': email,
      'password': password, // In production, ensure password is hashed
      'created_at': now,
    });
  }

  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    final dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password], // In production, implement proper password verification
      limit: 1,
    );
    
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<int> updateUserProfile(int id, Map<String, dynamic> userData) async {
    final dbClient = await db;
    return await dbClient.update(
      'users',
      userData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> changePassword(int id, String newPassword) async {
    final dbClient = await db;
    return await dbClient.update(
      'users',
      {'password': newPassword}, // In production, ensure password is hashed
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAccount(int id) async {
    final dbClient = await db;
    return await dbClient.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}