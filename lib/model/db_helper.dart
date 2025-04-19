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
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            data TEXT,
            detail TEXT

          )
        ''');
      },
    );
  }

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
}