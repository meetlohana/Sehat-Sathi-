import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/referral_models.dart';

/// Mock data provider for active referral
final activeReferralProvider = FutureProvider<ActiveReferral?>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  
  return ActiveReferral(
    referralId: 'REF-2024-001234',
    specialistName: 'Dr. Rajesh Kumar',
    specialistSpecialty: 'Cardiology',
    hospitalName: 'Apollo Hospital, Chennai',
    hospitalAddress: '21, Greams Lane, Off Greams Road, Thousand Lights, Chennai, Tamil Nadu 600006',
    referralDate: DateTime(2024, 9, 28),
    reason: 'Chest pain evaluation & ECG - Patient experiencing intermittent chest discomfort with radiation to left arm.',
    priority: ReferralPriority.urgent,
    status: ReferralStatus.underReview,
    appointmentDate: DateTime(2024, 10, 5),
    appointmentTime: '10:30 AM',
    hospitalContact: '+91 44 2829 3333',
    documents: [
      ReferralDocument(
        id: 'DOC-001',
        name: 'ECG Report - 25 Sep 2024',
        type: 'PDF',
        url: 'https://example.com/ecg.pdf',
        uploadedAt: DateTime(2024, 9, 25),
      ),
      ReferralDocument(
        id: 'DOC-002',
        name: 'Blood Test Results',
        type: 'PDF',
        url: 'https://example.com/blood.pdf',
        uploadedAt: DateTime(2024, 9, 26),
      ),
      ReferralDocument(
        id: 'DOC-003',
        name: 'Previous Prescription',
        type: 'JPG',
        url: 'https://example.com/prescription.jpg',
        uploadedAt: DateTime(2024, 9, 20),
      ),
    ],
    timeline: [
      ReferralTimelineEvent(
        id: 'TL-001',
        title: 'Referral Created',
        description: 'Referral submitted by Dr. Sarah Jenkins (General Medicine)',
        timestamp: DateTime(2024, 9, 28, 14, 30),
        status: ReferralStatus.submitted,
      ),
      ReferralTimelineEvent(
        id: 'TL-002',
        title: 'Under Specialist Review',
        description: 'Dr. Rajesh Kumar (Cardiology) is reviewing your case and documents',
        timestamp: DateTime(2024, 9, 29, 9, 15),
        status: ReferralStatus.underReview,
        isCurrent: true,
      ),
      ReferralTimelineEvent(
        id: 'TL-003',
        title: 'Appointment Scheduled',
        description: 'Appointment confirmed for 5 Oct 2024 at 10:30 AM at Apollo Hospital',
        timestamp: DateTime(2024, 10, 1, 11, 0),
        status: ReferralStatus.appointmentScheduled,
      ),
      ReferralTimelineEvent(
        id: 'TL-004',
        title: 'Consultation Completed',
        description: 'Follow-up consultation with specialist completed',
        timestamp: DateTime(2024, 10, 5, 11, 0),
        status: ReferralStatus.completed,
      ),
    ],
  );
});

/// Mock data provider for referral archive
final referralArchiveProvider = FutureProvider<List<ArchiveReferral>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 400));
  
  return [
    ArchiveReferral(
      referralId: 'REF-2024-001156',
      specialistName: 'Dr. Meera Shah',
      specialty: 'Neurology',
      hospitalName: 'Fortis Hospital, Mumbai',
      referralDate: DateTime(2024, 8, 15),
      completionDate: DateTime(2024, 9, 2),
      status: ReferralStatus.completed,
      outcomeSummary: 'Migraine diagnosis confirmed. Prescribed preventive medication and lifestyle modifications.',
      hasReport: true,
      reportUrl: 'https://example.com/report1.pdf',
    ),
    ArchiveReferral(
      referralId: 'REF-2024-000987',
      specialistName: 'Dr. Arjun Patel',
      specialty: 'Orthopedics',
      hospitalName: 'AIIMS, New Delhi',
      referralDate: DateTime(2024, 7, 3),
      completionDate: DateTime(2024, 8, 10),
      status: ReferralStatus.completed,
      outcomeSummary: 'ACL tear confirmed. Arthroscopic surgery recommended and scheduled.',
      hasReport: true,
      reportUrl: 'https://example.com/report2.pdf',
    ),
    ArchiveReferral(
      referralId: 'REF-2024-000823',
      specialistName: 'Dr. Priya Nair',
      specialty: 'Dermatology',
      hospitalName: 'KEM Hospital, Mumbai',
      referralDate: DateTime(2024, 5, 22),
      completionDate: DateTime(2024, 6, 15),
      status: ReferralStatus.expired,
      outcomeSummary: 'Referral expired before appointment was scheduled.',
      hasReport: false,
    ),
    ArchiveReferral(
      referralId: 'REF-2024-000654',
      specialistName: 'Dr. Vikram Singh',
      specialty: 'Gastroenterology',
      hospitalName: 'Medanta, Gurgaon',
      referralDate: DateTime(2024, 3, 10),
      completionDate: DateTime(2024, 4, 5),
      status: ReferralStatus.completed,
      outcomeSummary: 'GERD diagnosed. Prescribed PPI therapy and dietary modifications.',
      hasReport: true,
      reportUrl: 'https://example.com/report4.pdf',
    ),
    ArchiveReferral(
      referralId: 'REF-2024-000412',
      specialistName: 'Dr. Anjali Desai',
      specialty: 'Endocrinology',
      hospitalName: 'Jaslok Hospital, Mumbai',
      referralDate: DateTime(2024, 1, 18),
      completionDate: DateTime(2024, 2, 28),
      status: ReferralStatus.completed,
      outcomeSummary: 'Thyroid function normalized. Medication dosage adjusted.',
      hasReport: true,
      reportUrl: 'https://example.com/report5.pdf',
    ),
    ArchiveReferral(
      referralId: 'REF-2023-002189',
      specialistName: 'Dr. Ramesh Iyer',
      specialty: 'Pulmonology',
      hospitalName: 'Hinduja Hospital, Mumbai',
      referralDate: DateTime(2023, 11, 5),
      completionDate: DateTime(2023, 12, 12),
      status: ReferralStatus.completed,
      outcomeSummary: 'Asthma action plan updated. Inhaler technique reviewed.',
      hasReport: true,
      reportUrl: 'https://example.com/report6.pdf',
    ),
    ArchiveReferral(
      referralId: 'REF-2023-001976',
      specialistName: 'Dr. Sunita Reddy',
      specialty: 'Rheumatology',
      hospitalName: 'Breach Candy Hospital, Mumbai',
      referralDate: DateTime(2023, 9, 20),
      completionDate: DateTime(2023, 10, 15),
      status: ReferralStatus.cancelled,
      outcomeSummary: 'Patient cancelled referral due to scheduling conflict.',
      hasReport: false,
    ),
  ];
});

/// Action provider for referral operations
class ReferralActions {
  ReferralActions(this.ref);
  final Ref ref;

  Future<void> contactHospital(BuildContext context, String phone) async {
    // TODO: Implement phone dialer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calling $phone...')),
    );
  }

  Future<void> viewDocument(BuildContext context, ReferralDocument doc) async {
    // TODO: Implement document viewer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${doc.name}...')),
    );
  }

  Future<void> cancelReferral(BuildContext context, String referralId) async {
    // TODO: Implement cancellation API
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cancelling referral $referralId...')),
    );
  }

  Future<void> downloadReport(BuildContext context, ArchiveReferral referral) async {
    // TODO: Implement download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading report for ${referral.referralId}...')),
    );
  }
}

final referralActionsProvider = Provider<ReferralActions>((ref) => ReferralActions(ref));