import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart';

class DatabaseHelper {
  static final _databaseName = 'Project_PI.db';
  static final table = 'Kamus';
  static const String columnID = 'ID';
  static const String columnBali = 'BALI';
  static const String columnInggris = 'INGGRIS';

  DatabaseHelper._();
  static final DatabaseHelper db = DatabaseHelper._();
  Database _database;

  Future<Database> get database async {
    print("database getter called");
    if (_database != null) {
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    var databasePath = await getDatabasesPath();
    var path = join(databasePath, _databaseName);

    var exists = await databaseExists(path);
    if (!exists) {
      print("Creating new copy from asset");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets", _databaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      //Write
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Open Existing Database");
    }
    return await openDatabase(path, version: 1);
  }

  Future<List> getKamus() async {
    final db = await database;
    var result = await db.query(table, columns: [columnBali, columnInggris]);
    return result.toList();
  }
}
