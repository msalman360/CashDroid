import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _dbName = 'myDatabase.db';
  static final _dbVersion = 1;

  static final tableAccounts = 'accounts';
  static final columnId = 'id';
  static final columnAccountName = 'accountName';
  static final columnAccountType = 'accountType';
  static final columnBalance = 'balance';

  // Singleton instance
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Database reference
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(path,
        version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableAccounts (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnAccountName TEXT NOT NULL,
        $columnAccountType TEXT NOT NULL,
        $columnBalance REAL NOT NULL
      )
    ''');
  }

  // CRUD methods
  // Insert
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    // Remove the 'id' key from the row map before inserting
    row.remove(columnId);
    return await db.insert(tableAccounts, row);
  }


  // Read all rows
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(tableAccounts);
  }

  // Read specific row by ID
  Future<Map<String, dynamic>?> queryRow(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(tableAccounts, where: '$columnId = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  // Update
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(tableAccounts, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Delete
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(tableAccounts, where: '$columnId = ?', whereArgs: [id]);
  }
}
