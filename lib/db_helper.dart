import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('images.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();

    final path = join(dbPath.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE disliked_images(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        url TEXT
      );''');
    await db.execute('''
      CREATE TABLE liked_images(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        url TEXT
      );
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<void> insertUrl(String table, String url) async {
    final db = await instance.database;
    await db.insert(table, {'url': url});
  }

  Future<List<String>> getUrls(String table) async {
    final db = await instance.database;
    final result = await db.query(table);

    return result.map((json) => json['url'] as String).toList();
  }

  Future<void> deleteUrl(String table, String url) async {
    final db = await instance.database;
    await db.delete(table, where: 'url = ?', whereArgs: [url]);
  }
}
