import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db; // Make it nullable with 'Database?'

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = dir.path + 'transactions.db';

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        amount REAL
      )
    ''');
  }

  static Future<int> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database;
    return db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> fetchData(String table) async {
    final db = await DBHelper.database;
    return db.query(table);
  }

  static Future<int> delete(String table, int id) async {
    final db = await DBHelper.database;
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
