import 'package:flutter_test/flutter_test.dart';
import 'package:sehat_sathi/features/auth/data/user_health_repository.dart';

void main() {
  group('UserHealthRepository & Dummy Profile Tests', () {
    test('dummy profile contains expected credentials and clinical data', () {
      final PatientHealthProfile dummy = PatientHealthProfile.dummy();

      expect(dummy.mobileNumber, '9823456780');
      expect(dummy.fullName, contains('Ram Krishna Sharma'));
      expect(dummy.role, 'patient');
      expect(dummy.healthIdNumber, 'HRB1001234567890');
      expect(dummy.appointments.length, greaterThanOrEqualTo(2));
      expect(dummy.healthRecords.length, greaterThanOrEqualTo(2));
      expect(dummy.labResults.length, greaterThanOrEqualTo(1));
      expect(dummy.prescriptions.length, greaterThanOrEqualTo(1));
    });

    test('PatientHealthProfile maps appointment data properly', () {
      final appt = AppointmentRecord(
        title: 'Upcoming Appointment',
        subtitle: 'Dr. Sharma',
        dateLabel: 'Tomorrow',
        timeLabel: '10:30 AM',
        status: 'Scheduled',
      );

      final map = appt.toMap();
      expect(map['title'], 'Upcoming Appointment');
      expect(map['dateLabel'], 'Tomorrow');

      final fromMap = AppointmentRecord.fromMap(map);
      expect(fromMap.title, appt.title);
      expect(fromMap.status, 'Scheduled');
    });

    test('PatientHealthProfile maps clinical items properly', () {
      final item = ClinicalItemRecord(
        title: 'CBC Test',
        subtitle: 'Complete Blood Count',
        tag: 'New',
        badge: 'Normal',
      );

      final map = item.toMap();
      final fromMap = ClinicalItemRecord.fromMap(map);
      expect(fromMap.title, 'CBC Test');
      expect(fromMap.badge, 'Normal');
    });
  });
}
