import 'package:postgres/postgres.dart';

import '../../../core/database/app_database.dart';

/// Immutable snapshot of one login record persisted in the `SehatSathi`
/// PostgreSQL database.
class LoginRecord {
  const LoginRecord({
    required this.id,
    required this.mobileNumber,
    required this.otpCode,
    required this.loginMethod,
    required this.role,
    required this.language,
    required this.rememberMe,
    required this.loginCount,
    required this.createdAt,
    required this.lastLoginAt,
    this.healthIdNumber = '',
    this.fullName = '',
    this.dateOfBirth,
    this.gender = '',
    this.email = '',
    this.address = '',
  });

  final int id;
  final String mobileNumber;
  final String? otpCode;
  final String loginMethod;
  final String role;
  final String language;
  final bool rememberMe;
  final int loginCount;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  /// Health ID profile fields (populated from the `users` table).
  final String healthIdNumber;
  final String fullName;
  final DateTime? dateOfBirth;
  final String gender;
  final String email;
  final String address;

  factory LoginRecord.fromRow(ResultRow row) {
    final Map<String, Object?> map = row.toColumnMap();
    return LoginRecord(
      id: map['id']! as int,
      mobileNumber: map['mobile_number']! as String,
      otpCode: map['otp_code'] as String?,
      loginMethod: map['login_method']! as String,
      role: map['role']! as String,
      language: map['language']! as String,
      rememberMe: map['remember_me']! as bool,
      loginCount: map['login_count']! as int,
      createdAt: map['created_at']! as DateTime,
      lastLoginAt: map['last_login_at']! as DateTime,
      healthIdNumber: (map['health_id_number'] as String?)?.trim() ?? '',
      fullName: (map['full_name'] as String?)?.trim() ?? '',
      dateOfBirth:
          (map['date_of_birth'] as DateTime?)?.toLocal(),
      gender: (map['gender'] as String?)?.trim() ?? '',
      email: (map['email'] as String?)?.trim() ?? '',
      address: (map['address'] as String?)?.trim() ?? '',
    );
  }
}

/// Data access for the auth module: persists every login submission into the
/// PostgreSQL `users` table and reads records back for verification.
class LoginRepository {
  LoginRepository({AppDatabase? database})
      : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  /// Inserts a new login record, or bumps `login_count` / refreshes the
  /// details when the same mobile number logs in again.
  Future<LoginRecord> saveLogin({
    required String mobileNumber,
    required String? otpCode,
    required String loginMethod,
    required String role,
    required String language,
    required bool rememberMe,
    String healthIdNumber = '',
    String fullName = '',
    DateTime? dateOfBirth,
    String gender = '',
    String email = '',
    String address = '',
  }) async {
    try {
      final Connection connection = await _database.connection();
      final Result result = await connection.execute(
        Sql.named('''
          INSERT INTO users
            (mobile_number, otp_code, login_method, role, language, remember_me,
             health_id_number, full_name, date_of_birth, gender, email, address)
          VALUES
            (@mobile, @otp, @method, @role, @language, @remember,
             @healthId, @fullName, @dob, @gender, @email, @address)
          ON CONFLICT (mobile_number) DO UPDATE
             SET otp_code      = EXCLUDED.otp_code,
                 login_method  = EXCLUDED.login_method,
                 role          = EXCLUDED.role,
                 language      = EXCLUDED.language,
                 remember_me   = EXCLUDED.remember_me,
                 health_id_number = EXCLUDED.health_id_number,
                 full_name      = EXCLUDED.full_name,
                 date_of_birth  = EXCLUDED.date_of_birth,
                 gender         = EXCLUDED.gender,
                 email          = EXCLUDED.email,
                 address        = EXCLUDED.address,
                 login_count   = users.login_count + 1,
                 last_login_at = NOW()
          RETURNING *'''),
        parameters: <String, Object?>{
          'mobile': mobileNumber,
          'otp': otpCode,
          'method': loginMethod,
          'role': role,
          'language': language,
          'remember': rememberMe,
          'healthId': healthIdNumber,
          'fullName': fullName,
          'dob': dateOfBirth,
          'gender': gender,
          'email': email,
          'address': address,
        },
      );
      return LoginRecord.fromRow(result.first);
    } on Object {
      _database.invalidate();
      rethrow;
    }
  }

  /// Fetches the stored login record for [mobileNumber], or `null` when the
  /// user has never logged in.
  Future<LoginRecord?> findByMobile(String mobileNumber) async {
    try {
      final Connection connection = await _database.connection();
      final Result result = await connection.execute(
        Sql.named('''
          SELECT * FROM users
           WHERE mobile_number = @mobile
           LIMIT 1'''),
        parameters: <String, Object?>{'mobile': mobileNumber},
      );
      if (result.isEmpty) return null;
      return LoginRecord.fromRow(result.first);
    } on Object {
      _database.invalidate();
      rethrow;
    }
  }
}
