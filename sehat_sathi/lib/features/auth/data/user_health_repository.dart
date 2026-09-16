import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:postgres/postgres.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/mongo_database.dart';
import 'login_repository.dart';

/// Clinical appointment document model stored in MongoDB.
class AppointmentRecord {
  const AppointmentRecord({
    required this.title,
    required this.subtitle,
    required this.dateLabel,
    required this.timeLabel,
    required this.status,
  });

  final String title;
  final String subtitle;
  final String dateLabel;
  final String timeLabel;
  final String status;

  Map<String, dynamic> toMap() => {
        'title': title,
        'subtitle': subtitle,
        'dateLabel': dateLabel,
        'timeLabel': timeLabel,
        'status': status,
      };

  factory AppointmentRecord.fromMap(Map<String, dynamic> map) {
    return AppointmentRecord(
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      dateLabel: map['dateLabel'] as String? ?? '',
      timeLabel: map['timeLabel'] as String? ?? '',
      status: map['status'] as String? ?? 'Scheduled',
    );
  }
}

/// Clinical health record / lab item document model stored in MongoDB.
class ClinicalItemRecord {
  const ClinicalItemRecord({
    required this.title,
    required this.subtitle,
    required this.tag,
    this.badge,
  });

  final String title;
  final String subtitle;
  final String tag;
  final String? badge;

  Map<String, dynamic> toMap() => {
        'title': title,
        'subtitle': subtitle,
        'tag': tag,
        'badge': badge,
      };

  factory ClinicalItemRecord.fromMap(Map<String, dynamic> map) {
    return ClinicalItemRecord(
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      tag: map['tag'] as String? ?? '',
      badge: map['badge'] as String?,
    );
  }
}

/// Full patient health profile aggregated from PostgreSQL (accounts & auth)
/// and MongoDB (clinical history, appointments, labs, prescriptions).
class PatientHealthProfile {
  const PatientHealthProfile({
    required this.mobileNumber,
    required this.fullName,
    required this.role,
    required this.language,
    required this.healthIdNumber,
    required this.gender,
    required this.email,
    required this.address,
    required this.appointments,
    required this.healthRecords,
    required this.labResults,
    required this.prescriptions,
    this.loginCount = 1,
    this.pgConnected = false,
    this.mongoConnected = false,
  });

  final String mobileNumber;
  final String fullName;
  final String role;
  final String language;
  final String healthIdNumber;
  final String gender;
  final String email;
  final String address;
  final int loginCount;
  final bool pgConnected;
  final bool mongoConnected;

  final List<AppointmentRecord> appointments;
  final List<ClinicalItemRecord> healthRecords;
  final List<ClinicalItemRecord> labResults;
  final List<ClinicalItemRecord> prescriptions;

  /// Default dummy profile used for immediate access and resilient fallback.
  static PatientHealthProfile dummy() {
    return const PatientHealthProfile(
      mobileNumber: '9823456780',
      fullName: 'राम कृष्ण शर्मा / Ram Krishna Sharma',
      role: 'patient',
      language: 'mr',
      healthIdNumber: 'HRB1001234567890',
      gender: 'Male / पुरुष',
      email: 'ram.sharma@example.com',
      address: 'Gandhi Nagar, Aurangabad, Maharashtra 431001',
      loginCount: 1,
      pgConnected: true,
      mongoConnected: true,
      appointments: [
        AppointmentRecord(
          title: 'Upcoming Appointment',
          subtitle: 'Dr. Sharma - 15 Sep 2026, 10:30 AM',
          dateLabel: 'Tomorrow',
          timeLabel: '10:30 AM',
          status: 'Scheduled',
        ),
        AppointmentRecord(
          title: "Today's Schedule",
          subtitle: '3 appointments completed',
          dateLabel: 'Today',
          timeLabel: '3 Done',
          status: 'Completed',
        ),
      ],
      healthRecords: [
        ClinicalItemRecord(
          title: 'Health ID Profile',
          subtitle: 'HRB1001234567890 (Verified ABHA)',
          tag: 'Health ID',
          badge: 'Active',
        ),
        ClinicalItemRecord(
          title: 'Medical History',
          subtitle: 'Vaccination, Allergies, Surgeries',
          tag: 'History',
          badge: '12 Records',
        ),
      ],
      labResults: [
        ClinicalItemRecord(
          title: 'Recent Lab Results',
          subtitle: 'CBC, Lipid Profile, Blood Sugar',
          tag: 'New',
          badge: 'Normal',
        ),
      ],
      prescriptions: [
        ClinicalItemRecord(
          title: 'Prescriptions',
          subtitle: 'Last: Amoxicillin 500mg, Paracetamol 650mg',
          tag: 'Active',
          badge: 'Amoxy 500mg',
        ),
      ],
    );
  }
}

/// Dual-database repository:
/// - PostgreSQL: User account authentication, roles, login history
/// - MongoDB: Patient clinical documents, appointments, prescriptions, and health records
class UserHealthRepository {
  UserHealthRepository({
    AppDatabase? pgDatabase,
    MongoDatabase? mongoDatabase,
  })  : _pgDatabase = pgDatabase ?? AppDatabase.instance,
        _mongoDatabase = mongoDatabase ?? MongoDatabase.instance;

  final AppDatabase _pgDatabase;
  final MongoDatabase _mongoDatabase;

  static const String dummyMobile = '9823456780';
  static const String dummyHealthId = 'HRB1001234567890';
  static const String dummyFullName = 'राम कृष्ण शर्मा / Ram Krishna Sharma';

  /// Seeds dummy user data in both PostgreSQL and MongoDB if not already present.
  Future<void> seedDummyUser() async {
    // 1. Seed into PostgreSQL
    try {
      final Connection conn = await _pgDatabase.connection();
      await conn.execute(
        Sql.named('''
          INSERT INTO users
            (mobile_number, otp_code, login_method, role, language, remember_me,
             health_id_number, full_name, gender, email, address, login_count)
          VALUES
            (@mobile, '492700', 'Phone OTP', 'patient', 'mr', true,
             @healthId, @fullName, 'Male / पुरुष', 'ram.sharma@example.com',
             'Gandhi Nagar, Aurangabad, Maharashtra 431001', 1)
          ON CONFLICT (mobile_number) DO UPDATE
             SET health_id_number = EXCLUDED.health_id_number,
                 full_name = EXCLUDED.full_name,
                 gender = EXCLUDED.gender,
                 email = EXCLUDED.email,
                 address = EXCLUDED.address
        '''),
        parameters: <String, Object?>{
          'mobile': dummyMobile,
          'healthId': dummyHealthId,
          'fullName': dummyFullName,
        },
      );
      debugPrint('PostgreSQL dummy user seeded successfully');
    } catch (e) {
      debugPrint('PostgreSQL seed notice: $e');
    }

    // 2. Seed into MongoDB
    try {
      final mongo.Db db = await _mongoDatabase.database();
      final mongo.DbCollection patientsCol = db.collection('patients');
      final mongo.DbCollection appointmentsCol = db.collection('appointments');
      final mongo.DbCollection healthRecordsCol = db.collection('health_records');

      // Upsert patient record
      await patientsCol.modernUpdate(
        mongo.where.eq('mobileNumber', dummyMobile),
        mongo.modify
            .set('mobileNumber', dummyMobile)
            .set('fullName', dummyFullName)
            .set('healthIdNumber', dummyHealthId)
            .set('role', 'patient')
            .set('gender', 'Male / पुरुष')
            .set('email', 'ram.sharma@example.com')
            .set('address', 'Gandhi Nagar, Aurangabad, Maharashtra 431001')
            .set('updatedAt', DateTime.now().toIso8601String()),
        upsert: true,
      );

      // Upsert appointments
      final int count = await appointmentsCol.count(mongo.where.eq('mobileNumber', dummyMobile));
      if (count == 0) {
        await appointmentsCol.insertMany([
          {
            'mobileNumber': dummyMobile,
            'title': 'Upcoming Appointment',
            'subtitle': 'Dr. Sharma - 15 Sep 2026, 10:30 AM',
            'dateLabel': 'Tomorrow',
            'timeLabel': '10:30 AM',
            'status': 'Scheduled',
          },
          {
            'mobileNumber': dummyMobile,
            'title': "Today's Schedule",
            'subtitle': '3 appointments completed',
            'dateLabel': 'Today',
            'timeLabel': '3 Done',
            'status': 'Completed',
          },
        ]);
      }

      // Upsert health records
      final int hrCount = await healthRecordsCol.count(mongo.where.eq('mobileNumber', dummyMobile));
      if (hrCount == 0) {
        await healthRecordsCol.insertMany([
          {
            'mobileNumber': dummyMobile,
            'category': 'records',
            'title': 'Health ID Profile',
            'subtitle': 'HRB1001234567890 (Verified ABHA)',
            'tag': 'Health ID',
            'badge': 'Active',
          },
          {
            'mobileNumber': dummyMobile,
            'category': 'records',
            'title': 'Medical History',
            'subtitle': 'Vaccination, Allergies, Surgeries',
            'tag': 'History',
            'badge': '12 Records',
          },
          {
            'mobileNumber': dummyMobile,
            'category': 'labs',
            'title': 'Recent Lab Results',
            'subtitle': 'CBC, Lipid Profile, Blood Sugar',
            'tag': 'New',
            'badge': 'Normal',
          },
          {
            'mobileNumber': dummyMobile,
            'category': 'prescriptions',
            'title': 'Prescriptions',
            'subtitle': 'Last: Amoxicillin 500mg, Paracetamol 650mg',
            'tag': 'Active',
            'badge': 'Amoxy 500mg',
          },
        ]);
      }
      debugPrint('MongoDB dummy records seeded successfully');
    } catch (e) {
      debugPrint('MongoDB seed notice: $e');
    }
  }

  /// Loads full profile and records combining PostgreSQL and MongoDB.
  Future<PatientHealthProfile> getPatientProfile(String mobileNumber) async {
    bool pgOk = false;
    bool mongoOk = false;

    String fullName = dummyFullName;
    String role = 'patient';
    String language = 'mr';
    String healthId = dummyHealthId;
    String gender = 'Male / पुरुष';
    String email = 'ram.sharma@example.com';
    String address = 'Gandhi Nagar, Aurangabad, Maharashtra 431001';
    int loginCount = 1;

    // 1. Fetch from PostgreSQL
    try {
      final LoginRepository loginRepo = LoginRepository(database: _pgDatabase);
      final LoginRecord? record = await loginRepo.findByMobile(mobileNumber);
      if (record != null) {
        pgOk = true;
        fullName = record.fullName.isNotEmpty ? record.fullName : fullName;
        role = record.role.isNotEmpty ? record.role : role;
        language = record.language.isNotEmpty ? record.language : language;
        healthId = record.healthIdNumber.isNotEmpty ? record.healthIdNumber : healthId;
        gender = record.gender.isNotEmpty ? record.gender : gender;
        email = record.email.isNotEmpty ? record.email : email;
        address = record.address.isNotEmpty ? record.address : address;
        loginCount = record.loginCount;
      }
    } catch (e) {
      debugPrint('PostgreSQL profile fetch notice: $e');
    }

    // 2. Fetch from MongoDB
    List<AppointmentRecord> appointments = [];
    List<ClinicalItemRecord> healthRecords = [];
    List<ClinicalItemRecord> labResults = [];
    List<ClinicalItemRecord> prescriptions = [];

    try {
      final mongo.Db db = await _mongoDatabase.database();
      mongoOk = true;

      // Clinical appointments
      final mongo.DbCollection appointmentsCol = db.collection('appointments');
      final apptDocs = await appointmentsCol.find(mongo.where.eq('mobileNumber', mobileNumber)).toList();
      appointments = apptDocs.map((doc) => AppointmentRecord.fromMap(doc)).toList();

      // Clinical records & labs
      final mongo.DbCollection hrCol = db.collection('health_records');
      final hrDocs = await hrCol.find(mongo.where.eq('mobileNumber', mobileNumber)).toList();
      for (final doc in hrDocs) {
        final String category = doc['category'] as String? ?? 'records';
        final recordItem = ClinicalItemRecord.fromMap(doc);
        if (category == 'labs') {
          labResults.add(recordItem);
        } else if (category == 'prescriptions') {
          prescriptions.add(recordItem);
        } else {
          healthRecords.add(recordItem);
        }
      }
    } catch (e) {
      debugPrint('MongoDB records fetch notice: $e');
    }

    // Fallbacks if lists are empty (e.g. initial run or offline)
    final PatientHealthProfile dummyDefault = PatientHealthProfile.dummy();
    if (appointments.isEmpty) appointments = dummyDefault.appointments;
    if (healthRecords.isEmpty) healthRecords = dummyDefault.healthRecords;
    if (labResults.isEmpty) labResults = dummyDefault.labResults;
    if (prescriptions.isEmpty) prescriptions = dummyDefault.prescriptions;

    return PatientHealthProfile(
      mobileNumber: mobileNumber,
      fullName: fullName,
      role: role,
      language: language,
      healthIdNumber: healthId,
      gender: gender,
      email: email,
      address: address,
      loginCount: loginCount,
      pgConnected: pgOk,
      mongoConnected: mongoOk,
      appointments: appointments,
      healthRecords: healthRecords,
      labResults: labResults,
      prescriptions: prescriptions,
    );
  }

  /// Saves login and syncs both PostgreSQL and MongoDB.
  Future<LoginRecord> recordLogin({
    required String mobileNumber,
    required String? otpCode,
    required String loginMethod,
    required String role,
    required String language,
    required bool rememberMe,
  }) async {
    // 1. Save to PostgreSQL
    final LoginRepository pgRepo = LoginRepository(database: _pgDatabase);
    LoginRecord? record;
    try {
      record = await pgRepo.saveLogin(
        mobileNumber: mobileNumber,
        otpCode: otpCode,
        loginMethod: loginMethod,
        role: role,
        language: language,
        rememberMe: rememberMe,
        fullName: mobileNumber == dummyMobile ? dummyFullName : '',
        healthIdNumber: mobileNumber == dummyMobile ? dummyHealthId : '',
      );
    } catch (e) {
      debugPrint('PG save notice: $e');
      record = LoginRecord(
        id: 1,
        mobileNumber: mobileNumber,
        otpCode: otpCode,
        loginMethod: loginMethod,
        role: role,
        language: language,
        rememberMe: rememberMe,
        loginCount: 1,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        fullName: dummyFullName,
        healthIdNumber: dummyHealthId,
      );
    }

    // 2. Sync to MongoDB asynchronously
    try {
      final mongo.Db db = await _mongoDatabase.database();
      final mongo.DbCollection patientsCol = db.collection('patients');
      await patientsCol.modernUpdate(
        mongo.where.eq('mobileNumber', mobileNumber),
        mongo.modify
            .set('mobileNumber', mobileNumber)
            .set('lastLoginMethod', loginMethod)
            .set('role', role)
            .set('language', language)
            .set('lastLoginAt', DateTime.now().toIso8601String())
            .inc('loginCount', 1),
        upsert: true,
      );
    } catch (e) {
      debugPrint('MongoDB login sync notice: $e');
    }

    return record;
  }
}
