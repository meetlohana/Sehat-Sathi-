import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';

/// Connection settings for the `sehat_sathi` MongoDB instance.
///
/// Handles loopback IP for Android Emulator (10.0.2.2) and local Windows (127.0.0.1).
abstract final class MongoDatabaseConfig {
  static const String databaseName = 'sehat_sathi';
  static const int port = 27017;

  /// Resolves the reachable host for the current runtime.
  static String get host {
    if (kIsWeb) return '127.0.0.1';
    return Platform.isAndroid ? '10.0.2.2' : '127.0.0.1';
  }

  static String get connectionUri => 'mongodb://$host:$port/$databaseName';
}

/// Lazily opened, shared MongoDB connection for storing patient clinical records,
/// appointments, lab tests, and medical histories.
class MongoDatabase {
  MongoDatabase._();

  static final MongoDatabase instance = MongoDatabase._();

  Db? _db;
  Future<Db>? _connecting;

  /// Returns a live MongoDB database instance.
  Future<Db> database() {
    final Db? existing = _db;
    if (existing != null && existing.isConnected) {
      return Future<Db>.value(existing);
    }
    return _connecting ??= _open().whenComplete(() => _connecting = null);
  }

  Future<Db> _open() async {
    try {
      final Db db = await Db.create(MongoDatabaseConfig.connectionUri);
      await db.open().timeout(const Duration(seconds: 6));
      _db = db;
      debugPrint('Connected to MongoDB at ${MongoDatabaseConfig.connectionUri}');
      return db;
    } catch (e) {
      debugPrint('MongoDB connection error: $e');
      _db = null;
      rethrow;
    }
  }

  /// Closes the connection.
  Future<void> close() async {
    try {
      await _db?.close();
    } catch (_) {}
    _db = null;
  }
}
