import 'package:glocation/services/sqlite/glocation_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseSqlite {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = 'glocation.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> initDB() async {
    final path = await fullPath;
    var database = await openDatabase(path, version: 1, onCreate: create, singleInstance: true);
    return database;
  }

  Future<void> create(Database db, int version) async => await GlocationDB().createTable(db);
}
