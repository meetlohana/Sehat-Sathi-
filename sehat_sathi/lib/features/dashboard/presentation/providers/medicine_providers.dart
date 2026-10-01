import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/medicine_models.dart';

/// Mock data provider for active medications
final activeMedicationsProvider = FutureProvider<List<ActiveMedication>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  
  final now = DateTime.now();
  
  return [
    ActiveMedication(
      medicationId: 'MED-001',
      name: 'Metformin',
      dosage: '500mg',
      form: MedicationForm.tablet,
      frequency: MedicationFrequency.threeTimesDaily,
      doseTimes: [
        const TimeOfDay(hour: 8, minute: 0),
        const TimeOfDay(hour: 14, minute: 0),
        const TimeOfDay(hour: 20, minute: 0),
      ],
      startDate: DateTime(2024, 9, 15),
      endDate: DateTime(2024, 12, 15),
      totalDurationDays: 90,
      daysCompleted: 16,
      refillsRemaining: 2,
      refillsTotal: 3,
      prescribingDoctor: 'Dr. Sarah Jenkins',
      doctorSpecialty: 'General Medicine',
      instructions: 'Take with meals to reduce stomach upset. Monitor blood glucose regularly.',
      reminderEnabled: true,
      doseHistory: [
        DoseLog(id: 'DL-001', scheduledTime: now.subtract(const Duration(days: 1)).copyWith(hour: 8), takenAt: now.subtract(const Duration(days: 1)).copyWith(hour: 8, minute: 5), wasTaken: true),
        DoseLog(id: 'DL-002', scheduledTime: now.subtract(const Duration(days: 1)).copyWith(hour: 14), takenAt: now.subtract(const Duration(days: 1)).copyWith(hour: 14, minute: 10), wasTaken: true),
        DoseLog(id: 'DL-003', scheduledTime: now.subtract(const Duration(days: 1)).copyWith(hour: 20), takenAt: now.subtract(const Duration(days: 1)).copyWith(hour: 20, minute: 15), wasTaken: true),
        DoseLog(id: 'DL-004', scheduledTime: now.copyWith(hour: 8), takenAt: null, wasTaken: false),
        DoseLog(id: 'DL-005', scheduledTime: now.copyWith(hour: 14), takenAt: null, wasTaken: false),
        DoseLog(id: 'DL-006', scheduledTime: now.copyWith(hour: 20), takenAt: null, wasTaken: false),
      ],
      status: MedicationStatus.active,
    ),
    ActiveMedication(
      medicationId: 'MED-002',
      name: 'Amlodipine',
      dosage: '5mg',
      form: MedicationForm.tablet,
      frequency: MedicationFrequency.onceDaily,
      doseTimes: [
        const TimeOfDay(hour: 21, minute: 0),
      ],
      startDate: DateTime(2024, 8, 28),
      endDate: DateTime(2024, 9, 28),
      totalDurationDays: 30,
      daysCompleted: 30,
      refillsRemaining: 0,
      refillsTotal: 1,
      prescribingDoctor: 'Dr. Rajesh Kumar',
      doctorSpecialty: 'Cardiology',
      instructions: 'Take at bedtime. May cause ankle swelling - report if severe.',
      reminderEnabled: true,
      doseHistory: List.generate(30, (i) => DoseLog(
        id: 'DL-A-$i',
        scheduledTime: DateTime(2024, 8, 28 + i, 21, 0),
        takenAt: DateTime(2024, 8, 28 + i, 21, 10),
        wasTaken: true,
      )),
      status: MedicationStatus.refillNeeded,
    ),
    ActiveMedication(
      medicationId: 'MED-003',
      name: 'Atorvastatin',
      dosage: '20mg',
      form: MedicationForm.tablet,
      frequency: MedicationFrequency.onceDaily,
      doseTimes: [
        const TimeOfDay(hour: 21, minute: 0),
      ],
      startDate: DateTime(2024, 9, 1),
      endDate: DateTime(2024, 11, 30),
      totalDurationDays: 90,
      daysCompleted: 30,
      refillsRemaining: 1,
      refillsTotal: 2,
      prescribingDoctor: 'Dr. Sarah Jenkins',
      doctorSpecialty: 'General Medicine',
      instructions: 'Take at night. Avoid grapefruit juice. Regular liver function tests recommended.',
      reminderEnabled: true,
      doseHistory: List.generate(30, (i) => DoseLog(
        id: 'DL-AT-$i',
        scheduledTime: DateTime(2024, 9, 1 + i, 21, 0),
        takenAt: DateTime(2024, 9, 1 + i, 21, 5),
        wasTaken: true,
      )),
      status: MedicationStatus.active,
    ),
  ];
});

/// Mock data provider for prescription history
final prescriptionHistoryProvider = FutureProvider<List<PrescriptionRecord>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 400));
  
  return [
    PrescriptionRecord(
      prescriptionId: 'RX-2024-001234',
      prescribedDate: DateTime(2024, 9, 15),
      doctorName: 'Dr. Sarah Jenkins',
      doctorSpecialty: 'General Medicine',
      hospitalClinic: 'Sehat Sathi Clinic, Mumbai',
      medications: [
        PrescribedMedication(name: 'Metformin', dosage: '500mg', frequency: MedicationFrequency.threeTimesDaily, durationDays: 90),
        PrescribedMedication(name: 'Atorvastatin', dosage: '20mg', frequency: MedicationFrequency.onceDaily, durationDays: 90),
        PrescribedMedication(name: 'Vitamin D3', dosage: '1000 IU', frequency: MedicationFrequency.onceDaily, durationDays: 30, form: MedicationForm.capsule),
      ],
      diagnosis: 'Type 2 Diabetes Mellitus, Hyperlipidemia',
      notes: 'Follow-up in 3 months. HbA1c target <7%. Lipid profile in 6 weeks.',
      status: PrescriptionStatus.ongoing,
      pdfUrl: 'https://example.com/rx-001.pdf',
    ),
    PrescriptionRecord(
      prescriptionId: 'RX-2024-001156',
      prescribedDate: DateTime(2024, 8, 28),
      doctorName: 'Dr. Rajesh Kumar',
      doctorSpecialty: 'Cardiology',
      hospitalClinic: 'Apollo Hospital, Chennai',
      medications: [
        PrescribedMedication(name: 'Amlodipine', dosage: '5mg', frequency: MedicationFrequency.onceDaily, durationDays: 30),
        PrescribedMedication(name: 'Aspirin', dosage: '75mg', frequency: MedicationFrequency.onceDaily, durationDays: 90, form: MedicationForm.tablet),
      ],
      diagnosis: 'Hypertension, Post-CABG follow-up',
      notes: 'BP target <130/80. ECG normal. Continue current regimen.',
      status: PrescriptionStatus.completed,
      pdfUrl: 'https://example.com/rx-002.pdf',
    ),
    PrescriptionRecord(
      prescriptionId: 'RX-2024-000987',
      prescribedDate: DateTime(2024, 7, 10),
      doctorName: 'Dr. Meera Shah',
      doctorSpecialty: 'Neurology',
      hospitalClinic: 'Fortis Hospital, Mumbai',
      medications: [
        PrescribedMedication(name: 'Topiramate', dosage: '50mg', frequency: MedicationFrequency.twiceDaily, durationDays: 60),
        PrescribedMedication(name: 'Propranolol', dosage: '40mg', frequency: MedicationFrequency.twiceDaily, durationDays: 60),
      ],
      diagnosis: 'Chronic Migraine Prophylaxis',
      notes: 'Titrate topiramate slowly. Review in 2 months.',
      status: PrescriptionStatus.completed,
      pdfUrl: 'https://example.com/rx-003.pdf',
    ),
    PrescriptionRecord(
      prescriptionId: 'RX-2024-000823',
      prescribedDate: DateTime(2024, 5, 22),
      doctorName: 'Dr. Priya Nair',
      doctorSpecialty: 'Dermatology',
      hospitalClinic: 'KEM Hospital, Mumbai',
      medications: [
        PrescribedMedication(name: 'Isotretinoin', dosage: '20mg', frequency: MedicationFrequency.onceDaily, durationDays: 120),
        PrescribedMedication(name: 'Cetaphil Moisturizer', dosage: 'As needed', frequency: MedicationFrequency.custom, durationDays: 120, form: MedicationForm.cream),
      ],
      diagnosis: 'Moderate Acne Vulgaris',
      notes: 'Monthly LFT and lipid profile. Pregnancy prevention program.',
      status: PrescriptionStatus.discontinued,
      pdfUrl: 'https://example.com/rx-004.pdf',
    ),
    PrescriptionRecord(
      prescriptionId: 'RX-2024-000654',
      prescribedDate: DateTime(2024, 3, 15),
      doctorName: 'Dr. Vikram Singh',
      doctorSpecialty: 'Gastroenterology',
      hospitalClinic: 'Medanta, Gurgaon',
      medications: [
        PrescribedMedication(name: 'Omeprazole', dosage: '20mg', frequency: MedicationFrequency.onceDaily, durationDays: 60),
        PrescribedMedication(name: 'Domperidone', dosage: '10mg', frequency: MedicationFrequency.threeTimesDaily, durationDays: 14),
      ],
      diagnosis: 'GERD with Esophagitis Grade A',
      notes: 'Lifestyle modifications advised. Endoscopy if symptoms persist.',
      status: PrescriptionStatus.completed,
      pdfUrl: 'https://example.com/rx-005.pdf',
    ),
    PrescriptionRecord(
      prescriptionId: 'RX-2024-000412',
      prescribedDate: DateTime(2024, 1, 18),
      doctorName: 'Dr. Anjali Desai',
      doctorSpecialty: 'Endocrinology',
      hospitalClinic: 'Jaslok Hospital, Mumbai',
      medications: [
        PrescribedMedication(name: 'Levothyroxine', dosage: '75mcg', frequency: MedicationFrequency.onceDaily, durationDays: 90),
      ],
      diagnosis: 'Hypothyroidism',
      notes: 'TSH target 0.4-4.0. Take empty stomach 30 min before breakfast.',
      status: PrescriptionStatus.completed,
      pdfUrl: 'https://example.com/rx-006.pdf',
    ),
  ];
});

/// Action provider for medication operations
class MedicationActions {
  MedicationActions(this.ref);
  final Ref ref;

  Future<void> markDoseTaken(BuildContext context, ActiveMedication medication, TimeOfDay doseTime) async {
    // TODO: Implement dose logging API
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Marked ${medication.name} ${medication.dosage} as taken'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF0F172A),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // TODO: Implement undo
          },
        ),
      ),
    );
  }

  Future<void> requestRefill(BuildContext context, ActiveMedication medication) async {
    // TODO: Implement refill request API
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Refill requested for ${medication.name} ${medication.dosage}'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF0F172A),
      ),
    );
  }

  Future<void> viewPrescriptionPdf(BuildContext context, PrescriptionRecord prescription) async {
    // TODO: Implement PDF viewer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening prescription ${prescription.prescriptionId}...')),
    );
  }

  Future<void> toggleReminder(BuildContext context, ActiveMedication medication) async {
    // TODO: Implement reminder toggle
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reminder ${medication.reminderEnabled ? "disabled" : "enabled"} for ${medication.name}')),
    );
  }
}

final medicationActionsProvider = Provider<MedicationActions>((ref) => MedicationActions(ref));