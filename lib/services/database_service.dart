
// lib/services/database_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/primate.dart';
import 'dart:convert';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'primate_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE primates(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            species TEXT NOT NULL,
            age INTEGER,
            did TEXT NOT NULL,
            imageUrl TEXT,
            metadata TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertPrimate(Primate primate) async {
    final Database db = await database;
    await db.insert(
      'primates',
      {
        ...primate.toJson(),
        'metadata': jsonEncode(primate.metadata),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Primate>> getPrimates() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('primates');

    return List.generate(maps.length, (i) {
      var map = maps[i];
      map['metadata'] = jsonDecode(map['metadata'] ?? '{}');
      return Primate.fromJson(map);
    });
  }

  Future<Primate?> getPrimateByDID(String did) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'primates',
      where: 'did = ?',
      whereArgs: [did],
    );

    if (maps.isEmpty) return null;

    var map = maps.first;
    map['metadata'] = jsonDecode(map['metadata'] ?? '{}');
    return Primate.fromJson(map);
  }

  Future<void> updatePrimate(Primate primate) async {
    final db = await database;
    await db.update(
      'primates',
      {
        ...primate.toJson(),
        'metadata': jsonEncode(primate.metadata),
      },
      where: 'id = ?',
      whereArgs: [primate.id],
    );
  }

  Future<void> deletePrimate(String id) async {
    final db = await database;
    await db.delete(
      'primates',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}