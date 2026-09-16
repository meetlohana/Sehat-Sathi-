import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart';

/// Connection settings for the `SehatSathi` PostgreSQL database.
///
/// The app talks to the local PostgreSQL 18 instance. When running on the
/// Android emulator the host loopback is reachable through the special alias
/// `10.0.2.2`; on Windows desktop (and other native targets) `localhost` is
/// used directly.
abstract final class AppDatabaseConfig {
  static const String databaseName = 'SehatSathi';
  static const String username = 'sehat_sathi_app';
  static const String password = 'sehat_sathi_2026';
  static const int port = 5432;

  /// Resolves the reachable host for the current runtime.
  static String get host {
    if (kIsWeb) return 'localhost';
    return Platform.isAndroid ? '10.0.2.2' : 'localhost';
  }
}

/// Lazily opened, shared PostgreSQL connection used by every feature.
class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  Connection? _connection;
  Future<Connection>? _connecting;

  /// Returns a live connection, opening one on first use (and again after a
  /// dropped connection).
  Future<Connection> connection() {
    final Connection? open = _connection;
    if (open != null && open.isOpen) {
      return Future<Connection>.value(open);
    }
    return _connecting ??= _open().whenComplete(() => _connecting = null);
  }

  Future<Connection> _open() async {
    final Connection connection = await Connection.open(
      Endpoint(
        host: AppDatabaseConfig.host,
        port: AppDatabaseConfig.port,
        database: AppDatabaseConfig.databaseName,
        username: AppDatabaseConfig.username,
        password: AppDatabaseConfig.password,
      ),
      settings: const ConnectionSettings(
        connectTimeout: Duration(seconds: 8),
        queryTimeout: Duration(seconds: 15),
      ),
    );
    _connection = connection;
    return connection;
  }

  /// Closes the cached connection after a failure so the next call retries.
  void invalidate() {
    _connection?.close();
    _connection = null;
  }
}
