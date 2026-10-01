import 'package:flutter/material.dart';

enum MedicationFrequency {
  onceDaily,
  twiceDaily,
  threeTimesDaily,
  fourTimesDaily,
  sos,
  weekly,
  custom,
}

extension MedicationFrequencyExt on MedicationFrequency {
  String get label {
    switch (this) {
      case MedicationFrequency.onceDaily:
        return '1× Daily';
      case MedicationFrequency.twiceDaily:
        return '2× Daily';
      case MedicationFrequency.threeTimesDaily:
        return '3× Daily';
      case MedicationFrequency.fourTimesDaily:
        return '4× Daily';
      case MedicationFrequency.sos:
        return 'SOS';
      case MedicationFrequency.weekly:
        return 'Weekly';
      case MedicationFrequency.custom:
        return 'Custom';
    }
  }

  String get shortLabel {
    switch (this) {
      case MedicationFrequency.onceDaily:
        return 'OD';
      case MedicationFrequency.twiceDaily:
        return 'BD';
      case MedicationFrequency.threeTimesDaily:
        return 'TDS';
      case MedicationFrequency.fourTimesDaily:
        return 'QDS';
      case MedicationFrequency.sos:
        return 'SOS';
      case MedicationFrequency.weekly:
        return 'Weekly';
      case MedicationFrequency.custom:
        return 'Custom';
    }
  }
}

enum MedicationForm { tablet, capsule, syrup, injection, drops, cream, inhaler, patch }

extension MedicationFormExt on MedicationForm {
  IconData get icon {
    switch (this) {
      case MedicationForm.tablet:
        return Icons.medication_rounded;
      case MedicationForm.capsule:
        return Icons.medication_rounded;
      case MedicationForm.syrup:
        return Icons.local_drink_rounded;
      case MedicationForm.injection:
        return Icons.vaccines_rounded;
      case MedicationForm.drops:
        return Icons.water_drop_rounded;
      case MedicationForm.cream:
        return Icons.medical_services_rounded;
      case MedicationForm.inhaler:
        return Icons.air_rounded;
      case MedicationForm.patch:
        return Icons.healing_rounded;
    }
  }

  Color get color {
    switch (this) {
      case MedicationForm.tablet:
        return const Color(0xFF4A90D9);
      case MedicationForm.capsule:
        return const Color(0xFF7B5FD4);
      case MedicationForm.syrup:
        return const Color(0xFF22C55E);
      case MedicationForm.injection:
        return const Color(0xFFE05C7A);
      case MedicationForm.drops:
        return const Color(0xFF06B6D4);
      case MedicationForm.cream:
        return const Color(0xFFF59E0B);
      case MedicationForm.inhaler:
        return const Color(0xFF8B5CF6);
      case MedicationForm.patch:
        return const Color(0xFFEC4899);
    }
  }

  Color get bgColor {
    return color.withValues(alpha: 0.1);
  }
}

enum MedicationStatus { active, lowStock, refillNeeded, expiringSoon }

extension MedicationStatusExt on MedicationStatus {
  String get label {
    switch (this) {
      case MedicationStatus.active:
        return 'Active';
      case MedicationStatus.lowStock:
        return 'Low Stock';
      case MedicationStatus.refillNeeded:
        return 'Refill Needed';
      case MedicationStatus.expiringSoon:
        return 'Expiring Soon';
    }
  }

  Color get color {
    switch (this) {
      case MedicationStatus.active:
        return const Color(0xFF22C55E);
      case MedicationStatus.lowStock:
        return const Color(0xFFF59E0B);
      case MedicationStatus.refillNeeded:
        return const Color(0xFFDC2626);
      case MedicationStatus.expiringSoon:
        return const Color(0xFFF59E0B);
    }
  }

  Color get bgColor {
    switch (this) {
      case MedicationStatus.active:
        return const Color(0xFFECFDF5);
      case MedicationStatus.lowStock:
        return const Color(0xFFFFF8E1);
      case MedicationStatus.refillNeeded:
        return const Color(0xFFFFEBEE);
      case MedicationStatus.expiringSoon:
        return const Color(0xFFFFF8E1);
    }
  }

  IconData get icon {
    switch (this) {
      case MedicationStatus.active:
        return Icons.check_circle_rounded;
      case MedicationStatus.lowStock:
        return Icons.warning_amber_rounded;
      case MedicationStatus.refillNeeded:
        return Icons.error_rounded;
      case MedicationStatus.expiringSoon:
        return Icons.schedule_rounded;
    }
  }
}

class DoseLog {
  const DoseLog({
    required this.id,
    required this.scheduledTime,
    required this.takenAt,
    required this.wasTaken,
  });

  final String id;
  final DateTime scheduledTime;
  final DateTime? takenAt;
  final bool wasTaken;
}

class ActiveMedication {
  const ActiveMedication({
    required this.medicationId,
    required this.name,
    required this.dosage,
    required this.form,
    required this.frequency,
    required this.doseTimes,
    required this.startDate,
    required this.endDate,
    required this.totalDurationDays,
    required this.daysCompleted,
    required this.refillsRemaining,
    required this.refillsTotal,
    required this.prescribingDoctor,
    required this.doctorSpecialty,
    required this.instructions,
    required this.reminderEnabled,
    required this.doseHistory,
    required this.status,
  });

  final String medicationId;
  final String name;
  final String dosage;
  final MedicationForm form;
  final MedicationFrequency frequency;
  final List<TimeOfDay> doseTimes;
  final DateTime startDate;
  final DateTime endDate;
  final int totalDurationDays;
  final int daysCompleted;
  final int refillsRemaining;
  final int refillsTotal;
  final String prescribingDoctor;
  final String doctorSpecialty;
  final String instructions;
  final bool reminderEnabled;
  final List<DoseLog> doseHistory;
  final MedicationStatus status;

  double get progress => totalDurationDays > 0 ? daysCompleted / totalDurationDays : 0.0;

  bool get isLowStock => refillsRemaining <= 1 && refillsRemaining > 0;
  bool get needsRefill => refillsRemaining == 0;
  bool get isExpiringSoon => endDate.difference(DateTime.now()).inDays <= 7;

  String get displayName => '$name $dosage';

  int get dosesPerDay => doseTimes.length;

  List<TimeOfDay> get todayDoses {
    final List<TimeOfDay> sorted = List<TimeOfDay>.from(doseTimes);
    sorted.sort((TimeOfDay a, TimeOfDay b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute));
    return sorted;
  }

  DoseLog? get lastTaken {
    if (doseHistory.isEmpty) return null;
    return doseHistory.last;
  }

  int get takenToday {
    final today = DateTime.now();
    return doseHistory.where((log) =>
      log.wasTaken &&
      log.takenAt != null &&
      log.takenAt!.year == today.year &&
      log.takenAt!.month == today.month &&
      log.takenAt!.day == today.day
    ).length;
  }
}

class PrescribedMedication {
  const PrescribedMedication({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.durationDays,
    this.form = MedicationForm.tablet,
    this.instructions,
  });

  final String name;
  final String dosage;
  final MedicationFrequency frequency;
  final int durationDays;
  final MedicationForm form;
  final String? instructions;

  String get displayName => '$name $dosage';
}

enum PrescriptionStatus { completed, discontinued, ongoing }

extension PrescriptionStatusExt on PrescriptionStatus {
  String get label {
    switch (this) {
      case PrescriptionStatus.completed:
        return 'COMPLETED';
      case PrescriptionStatus.discontinued:
        return 'DISCONTINUED';
      case PrescriptionStatus.ongoing:
        return 'ONGOING';
    }
  }

  Color get color {
    switch (this) {
      case PrescriptionStatus.completed:
        return const Color(0xFF22C55E);
      case PrescriptionStatus.discontinued:
        return const Color(0xFFDC2626);
      case PrescriptionStatus.ongoing:
        return const Color(0xFF4A90D9);
    }
  }

  Color get bgColor {
    switch (this) {
      case PrescriptionStatus.completed:
        return const Color(0xFFECFDF5);
      case PrescriptionStatus.discontinued:
        return const Color(0xFFFFEBEE);
      case PrescriptionStatus.ongoing:
        return const Color(0xFFEAF2FB);
    }
  }
}

class PrescriptionRecord {
  const PrescriptionRecord({
    required this.prescriptionId,
    required this.prescribedDate,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.hospitalClinic,
    required this.medications,
    required this.diagnosis,
    required this.notes,
    required this.status,
    this.pdfUrl,
  });

  final String prescriptionId;
  final DateTime prescribedDate;
  final String doctorName;
  final String doctorSpecialty;
  final String hospitalClinic;
  final List<PrescribedMedication> medications;
  final String diagnosis;
  final String notes;
  final PrescriptionStatus status;
  final String? pdfUrl;

  int get medicationCount => medications.length;

  String get displayTitle => '$doctorName • ${doctorSpecialty}';
}