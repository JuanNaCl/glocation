import 'package:glocation/models/register_model.dart';
import 'package:glocation/services/sqlite/sqlite_connection.dart';

import 'package:sqflite/sqflite.dart';

class GlocationDB{
  final tableName = 'Registers';

  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS  $tableName(
        "id" INTEGER NOT NULL,
        "name" TEXT NOT NULL,
        "email" TEXT NOT NULL,
        "password" TEXT NOT NULL,
        "vehicle" TEXT NOT NULL,
        "devices" TEXT NOT NULL,
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

  Future<void> update(Register register) async {
    final database = await DatabaseSqlite().database;
    await database.rawUpdate('''
      UPDATE $tableName SET name = ?, email = ?, password = ?, vehicle = ?, devices = ? WHERE id = ?
    ''', [register.name, register.email, register.password, register.vehicle, register.devices, register.id]);
  }

  Future<void> delete(int id) async {
    final database = await DatabaseSqlite().database;
    await database.rawDelete('''
      DELETE FROM $tableName WHERE id = ?
    ''', [id]);
  }

  Future<Register> fetchById(int id) async {
    final database = await DatabaseSqlite().database;
    final result = await database.rawQuery('''
      SELECT * FROM $tableName WHERE id = ?
    ''', [id]);
    return Register.fromSqliteDatabase(result.first);
  }
}