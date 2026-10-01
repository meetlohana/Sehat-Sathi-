/// Domain models for the appointment booking workflow.

import 'package:flutter/material.dart';

class AppointmentPatientDetails {
  AppointmentPatientDetails({
    this.fullName = '',
    this.age = '',
    this.bloodGroup = '',
    this.address = '',
    this.contactNumber = '',
    this.email = '',
    this.gender = '',
    this.height = '',
    this.weight = '',
    this.medicalHistory = '',
    this.currentMedications = '',
    this.allergies = '',
    this.reasonForVisit = '',
  });

  String fullName;
  String age;
  String bloodGroup;
  String address;
  String contactNumber;
  String email;
  String gender;
  String height;
  String weight;
  String medicalHistory;
  String currentMedications;
  String allergies;
  String reasonForVisit;
}

class Department {
  const Department({
    required this.id,
    required this.name,
    required this.icon,
  });

  final String id;
  final String name;
  final IconData icon;
}

class Doctor {
  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.rating,
    required this.patients,
    required this.yearsOfExperience,
    this.imageUrl,
    this.availableDays,
    this.availableTimes,
  });

  final String id;
  final String name;
  final String specialty;
  final String hospital;
  final double rating;
  final int patients;
  final int yearsOfExperience;
  final String? imageUrl;
  final List<String>? availableDays;
  final List<String>? availableTimes;
}

class BookedAppointment {
  const BookedAppointment({
    required this.id,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.hospitalName,
    required this.hospitalAddress,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.department,
    required this.consultationFee,
    this.doctorImageUrl,
    this.patientName,
    this.patientAge,
    this.reason,
  });

  final String id;
  final String doctorName;
  final String doctorSpecialty;
  final String hospitalName;
  final String hospitalAddress;
  final DateTime appointmentDate;
  final String appointmentTime;
  final String department;
  final double consultationFee;
  final String? doctorImageUrl;
  final String? patientName;
  final int? patientAge;
  final String? reason;
}
