import 'dart:async';
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weighttracker/models/weightRecord.dart';
import 'package:flutter/widgets.dart';

/// Tutorial for how to use sqflite:
/// https://petercoding.com/flutter/2021/03/21/using-sqlite-in-flutter/

class DBHandler {

  // "connect", and CREATE table if it does not exist
  Future<Database> initializeDB() async {

    String path = await getDatabasesPath();

    return openDatabase(
        join(path, "weighttracker.db"),
        version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("""
      CREATE TABLE weights (
          weight REAL NOT NULL,
          date INT PRIMARY KEY
        )
        """);
    });
  }

  // INSERT
  Future<int> insertRecord(WeightRecord weightRecord) async {
    int result = 0;
    final Database db = await initializeDB();
    await db.insert('weights', weightRecord.toMap());
    return result;
  }

  // SELECT (with sorting)
  Future<List<WeightRecord>> retrieveRecords() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('weights');
    final weightList = queryResult.map((e) => WeightRecord.fromMap(e)).toList();
    return sortWeightRecords(weightList);
  }

  // DELETE
  Future<void> deleteRecord(int datetime) async {
    final db = await initializeDB();
    await db.delete(
      'weights',
      where: "date = ?",
      whereArgs: [datetime],
    );
  }

}
