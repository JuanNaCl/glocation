import 'package:glocation/models/register_model.dart';
import 'package:glocation/services/sqlite/sqlite_conecction.dart';

import 'package:sqflite/sqflite.dart';

class GlocationDB{
  final tableName = 'Registers';

  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NO EXIST  $tableName(
        "id" INTEGER KEY NOT NULL,
        "name" TEXT NOT NULL,
        "email" TEXT NOT NULL,
        "password" TEXT NOT NULL,
        "vehicle" TEXT NOT NULL,
        "devices" TEXT NOT NULL
        PRIMARY KEY("id" AUTOINCREMENT)
      );
    ''');
  }

  Future<int> create({required String title,email,password,vehicle,devices})  async {
    final database = await DatabaseSqlite().database;
    return await database.rawInsert('''
      INSERT INTO $tableName (name,email,password,vehicle,devices) VALUES (?, ?, ?, ?, ?)
    ''', [title,email,password,vehicle,devices]);
  }

  Future<List<Register>> fetchAll() async {
    final database = await DatabaseSqlite().database;
    final result = await database.rawQuery(
      '''SELECT * FROM $tableName ORDER BY COALESCE(id, 0) DESC'''
    );
    return result.map((e) => Register.fromSqliteDatabase(e)).toList();
  }
}