import 'package:flutter/material.dart';

enum ReferralPriority { urgent, routine, followUp }

enum ReferralStatus {
  submitted,
  underReview,
  appointmentScheduled,
  completed,
  cancelled,
  expired,
  rejected,
}

extension ReferralPriorityExt on ReferralPriority {
  String get label {
    switch (this) {
      case ReferralPriority.urgent:
        return 'URGENT';
      case ReferralPriority.routine:
        return 'ROUTINE';
      case ReferralPriority.followUp:
        return 'FOLLOW-UP';
    }
  }

  Color get color {
    switch (this) {
      case ReferralPriority.urgent:
        return const Color(0xFFDC2626);
      case ReferralPriority.routine:
        return const Color(0xFF4A90D9);
      case ReferralPriority.followUp:
        return const Color(0xFF7B5FD4);
    }
  }

  Color get bgColor {
    switch (this) {
      case ReferralPriority.urgent:
        return const Color(0xFFFFEBEE);
      case ReferralPriority.routine:
        return const Color(0xFFEAF2FB);
      case ReferralPriority.followUp:
        return const Color(0xFFF5EFFF);
    }
  }
}

extension ReferralStatusExt on ReferralStatus {
  String get label {
    switch (this) {
      case ReferralStatus.submitted:
        return 'SUBMITTED';
      case ReferralStatus.underReview:
        return 'UNDER REVIEW';
      case ReferralStatus.appointmentScheduled:
        return 'APPOINTMENT SCHEDULED';
      case ReferralStatus.completed:
        return 'COMPLETED';
      case ReferralStatus.cancelled:
        return 'CANCELLED';
      case ReferralStatus.expired:
        return 'EXPIRED';
      case ReferralStatus.rejected:
        return 'REJECTED';
    }
  }

  Color get color {
    switch (this) {
      case ReferralStatus.submitted:
        return const Color(0xFF7B5FD4);
      case ReferralStatus.underReview:
        return const Color(0xFF4A90D9);
      case ReferralStatus.appointmentScheduled:
        return const Color(0xFF22C55E);
      case ReferralStatus.completed:
        return const Color(0xFF22C55E);
      case ReferralStatus.cancelled:
        return const Color(0xFFDC2626);
      case ReferralStatus.expired:
        return const Color(0xFF94A3B8);
      case ReferralStatus.rejected:
        return const Color(0xFFDC2626);
    }
  }

  Color get bgColor {
    switch (this) {
      case ReferralStatus.submitted:
        return const Color(0xFFF5EFFF);
      case ReferralStatus.underReview:
        return const Color(0xFFEAF2FB);
      case ReferralStatus.appointmentScheduled:
        return const Color(0xFFECFDF5);
      case ReferralStatus.completed:
        return const Color(0xFFECFDF5);
      case ReferralStatus.cancelled:
        return const Color(0xFFFFEBEE);
      case ReferralStatus.expired:
        return const Color(0xFFF1F5F9);
      case ReferralStatus.rejected:
        return const Color(0xFFFFEBEE);
    }
  }

  IconData get icon {
    switch (this) {
      case ReferralStatus.submitted:
        return Icons.send_rounded;
      case ReferralStatus.underReview:
        return Icons.visibility_rounded;
      case ReferralStatus.appointmentScheduled:
        return Icons.event_available_rounded;
      case ReferralStatus.completed:
        return Icons.check_circle_rounded;
      case ReferralStatus.cancelled:
        return Icons.cancel_rounded;
      case ReferralStatus.expired:
        return Icons.schedule_rounded;
      case ReferralStatus.rejected:
        return Icons.block_rounded;
    }
  }
}

class ReferralDocument {
  const ReferralDocument({
    required this.id,
    required this.name,
    required this.type,
    required this.url,
    required this.uploadedAt,
  });

  final String id;
  final String name;
  final String type;
  final String url;
  final DateTime uploadedAt;
}

class ReferralTimelineEvent {
  const ReferralTimelineEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.status,
    this.isCurrent = false,
  });

  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final ReferralStatus status;
  final bool isCurrent;
}

class ActiveReferral {
  const ActiveReferral({
    required this.referralId,
    required this.specialistName,
    required this.specialistSpecialty,
    required this.hospitalName,
    required this.hospitalAddress,
    required this.referralDate,
    required this.reason,
    required this.priority,
    required this.status,
    this.appointmentDate,
    this.appointmentTime,
    this.hospitalContact,
    this.documents = const [],
    this.timeline = const [],
  });

  final String referralId;
  final String specialistName;
  final String specialistSpecialty;
  final String hospitalName;
  final String hospitalAddress;
  final DateTime referralDate;
  final String reason;
  final ReferralPriority priority;
  final ReferralStatus status;
  final DateTime? appointmentDate;
  final String? appointmentTime;
  final String? hospitalContact;
  final List<ReferralDocument> documents;
  final List<ReferralTimelineEvent> timeline;

  int get currentStepIndex {
    const steps = [
      ReferralStatus.submitted,
      ReferralStatus.underReview,
      ReferralStatus.appointmentScheduled,
      ReferralStatus.completed,
    ];
    return steps.indexOf(status);
  }

  bool get isCompleted => status == ReferralStatus.completed;
  bool get isCancelled => status == ReferralStatus.cancelled;
}

class ArchiveReferral {
  const ArchiveReferral({
    required this.referralId,
    required this.specialistName,
    required this.specialty,
    required this.hospitalName,
    required this.referralDate,
    this.completionDate,
    required this.status,
    this.outcomeSummary,
    this.hasReport = false,
    this.reportUrl,
  });

  final String referralId;
  final String specialistName;
  final String specialty;
  final String hospitalName;
  final DateTime referralDate;
  final DateTime? completionDate;
  final ReferralStatus status;
  final String? outcomeSummary;
  final bool hasReport;
  final String? reportUrl;
}