import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../domain/appointment_models.dart';

final List<Department> departments = <Department>[
  Department(id: '1', name: 'General Medicine', icon: Icons.medical_services_rounded),
  Department(id: '2', name: 'Cardiology', icon: Icons.favorite_rounded),
  Department(id: '3', name: 'Dermatology', icon: Icons.spa_rounded),
  Department(id: '4', name: 'Pediatrics', icon: Icons.child_care_rounded),
  Department(id: '5', name: 'Orthopedics', icon: Icons.medical_services_rounded),
  Department(id: '6', name: 'Ophthalmology', icon: Icons.visibility_rounded),
  Department(id: '7', name: 'ENT', icon: Icons.hearing_rounded),
  Department(id: '8', name: 'Dentistry', icon: Icons.medical_services_rounded),
];

final List<Doctor> doctors = <Doctor>[
  Doctor(
    id: 'D1',
    name: 'Dr. Sarah Jenkins',
    specialty: 'General Medicine',
    hospital: 'City General Hospital',
    rating: 4.8,
    patients: 1250,
    yearsOfExperience: 12,
    availableDays: <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
    availableTimes: <String>['08:00 AM', '10:30 AM', '02:00 PM', '04:30 PM'],
  ),
  Doctor(
    id: 'D2',
    name: 'Dr. Rajesh Kumar',
    specialty: 'Cardiology',
    hospital: 'Metro Heart Institute',
    rating: 4.9,
    patients: 2100,
    yearsOfExperience: 18,
    availableDays: <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
    availableTimes: <String>['09:00 AM', '11:30 AM', '03:00 PM', '05:30 PM'],
  ),
  Doctor(
    id: 'D3',
    name: 'Dr. Priya Sharma',
    specialty: 'Pediatrics',
    hospital: 'Children\'s Care Hospital',
    rating: 4.7,
    patients: 980,
    yearsOfExperience: 10,
    availableDays: <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
    availableTimes: <String>['09:30 AM', '01:00 PM', '03:30 PM'],
  ),
  Doctor(
    id: 'D4',
    name: 'Dr. Amit Patel',
    specialty: 'Orthopedics',
    hospital: 'Spine & Joint Center',
    rating: 4.6,
    patients: 1500,
    yearsOfExperience: 15,
    availableDays: <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
    availableTimes: <String>['08:30 AM', '12:00 PM', '04:00 PM'],
  ),
  Doctor(
    id: 'D5',
    name: 'Dr. Meera Reddy',
    specialty: 'Dermatology',
    hospital: 'Skin Health Clinic',
    rating: 4.5,
    patients: 800,
    yearsOfExperience: 8,
    availableDays: <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
    availableTimes: <String>['10:00 AM', '02:30 PM', '05:00 PM'],
  ),
];

final Provider<List<Department>> departmentsProvider =
    Provider<List<Department>>((ref) => departments);

final Provider<List<Doctor>> doctorsProvider =
    Provider<List<Doctor>>((ref) => doctors);

final Provider<List<DateTime>> appointmentDatesProvider =
    Provider<List<DateTime>>((ref) {
  final DateTime today = DateTime.now();
  return List<DateTime>.generate(7, (int index) => today.add(Duration(days: index)));
});

final StateProvider<String?> selectedDoctorProvider =
    StateProvider<String?>((ref) => null);

final StateProvider<String?> selectedDepartmentProvider =
    StateProvider<String?>((ref) => null);

final StateProvider<String?> selectedDateProvider =
    StateProvider<String?>((ref) => null);

final StateProvider<String?> selectedTimeProvider =
    StateProvider<String?>((ref) => null);

final StateProvider<AppointmentPatientDetails?> patientDetailsProvider =
    StateProvider<AppointmentPatientDetails?>((ref) => null);

final StateProvider<BookedAppointment?> bookedAppointmentProvider =
    StateProvider<BookedAppointment?>((ref) => null);
