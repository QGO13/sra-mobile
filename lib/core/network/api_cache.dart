import 'package:sqflite/sqflite.dart';
import 'package:sra_hotel/core/database/local_database.dart';

class ApiCache {
  final LocalDatabase localDatabase;

  ApiCache({required this.localDatabase});

  Future<void> save(String key, String jsonStr) async {
    final db = await localDatabase.database;
    if (db == null) return;
    await db.insert(
      'api_cache',
      {'key': key, 'value': jsonStr},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> get(String key) async {
    final db = await localDatabase.database;
    if (db == null) return null;
    final List<Map<String, dynamic>> maps = await db.query(
      'api_cache',
      where: 'key = ?',
      whereArgs: [key],
    );
    if (maps.isNotEmpty) {
      return maps.first['value'] as String?;
    }
    return null;
  }

  Future<void> clear(String key) async {
    final db = await localDatabase.database;
    if (db == null) return;
    await db.delete(
      'api_cache',
      where: 'key = ?',
      whereArgs: [key],
    );
  }
}
