import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper{

  //Create Table and table columns
  static Future<void> createTables (sql.Database database) async {
    await database.execute("""CREATE TABLE items(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title TEXT,
    description TEXT,
    createdAt TIME STAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)
      """);
  }

  // Give the name of database and create table
  static Future<sql.Database> db() async{
    return sql.openDatabase(
      'dbestech.db',
      version: 1,
      onCreate: (sql.Database database, int version) async{
        print("...creating a Table...");
        await createTables(database);
      }
    );
  }

  // insert the data in the database table named item
  static Future<int> createItem(String title, String? description) async {
    final db = await SQLHelper.db();

    final data = {'title': title, 'description': description};
    final id = await db.insert(
    'items',
    data,
    conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  //Database connection and use of query to get all or certain data from database
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: "id");
  }

  //Database connection and use of query to get 1 data based on id
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db  = await  SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  //Update the data in database based on id
  static Future<int> updateItem(
      int id, String title, String? description) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': description,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  //Delete data from database based on id
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try{
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    }catch(err){
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
