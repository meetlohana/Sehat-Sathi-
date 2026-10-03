import 'package:sqflite/sqflite.dart';

/// Tiny SQLite key-value store for permitted local state (e.g. language).
/// Never store voice recordings or health data here.
class VoiceLocalStore {
  Database? _db;

  Future<Database> _open() async {
    return _db ??= await openDatabase(
      '${await getDatabasesPath()}/voice_guide.db',
      version: 1,
      onCreate: (db, _) => db.execute(
          'CREATE TABLE prefs (k TEXT PRIMARY KEY, v TEXT NOT NULL)'),
    );
  }

  Future<String?> get(String key) async {
    final rows = await (await _open()).query('prefs', where: 'k = ?', whereArgs: [key]);
    return rows.isEmpty ? null : rows.first['v'] as String;
  }

  Future<void> set(String key, String value) async {
    await (await _open()).insert('prefs', {'k': key, 'v': value},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
