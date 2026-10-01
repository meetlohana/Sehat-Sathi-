import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/appointment_models.dart';
import '../providers/appointment_providers.dart';
import '../widgets/dashboard_titlebar.dart';

class AppointmentConfirmationScreen extends ConsumerWidget {
  const AppointmentConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BookedAppointment? appointment = ref.watch(bookedAppointmentProvider);
    final AppointmentPatientDetails? patientDetails = ref.watch(patientDetailsProvider);

    final BookedAppointment displayAppointment = appointment ?? _defaultAppointment();
    final AppointmentPatientDetails displayDetails = patientDetails ?? AppointmentPatientDetails(fullName: 'John Doe', age: '35', bloodGroup: 'A+', gender: 'Male');

    final String formattedDate = DateFormat('EEEE, MMMM d, y').format(displayAppointment.appointmentDate);

    return Scaffold(
      backgroundColor: const Color(0xFFEEF3FB),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DashboardTitleBar(
                      title: 'Confirm Appointment',
                      subtitle: 'Review and confirm booking details',
                      onBack: () => context.pop(),
                    ),
                    const SizedBox(height: 16),
                    Text('STEP 2 OF 2', style: AppTypography.stepLabel),
                    const SizedBox(height: 16),
                    _buildPatientInfoCard(displayDetails),
                    const SizedBox(height: 16),
                    _buildDoctorCard(displayAppointment),
                    const SizedBox(height: 16),
                    _buildAppointmentDetailsCard(displayAppointment, formattedDate),
                    const SizedBox(height: 16),
                    _buildHospitalCard(displayAppointment),
                    const SizedBox(height: 16),
                    _buildPaymentSummaryCard(displayAppointment),
                  ],
                ),
              ),
            ),
            _buildConfirmButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientInfoCard(AppointmentPatientDetails details) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadii.cardAll,
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.person_rounded, size: 20, color: AppColors.brand),
              const SizedBox(width: 8),
              Text('Patient Information', style: AppTypography.cardTitle),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Name', details.fullName),
          _buildInfoRow('Age / Gender', '${details.age} / ${details.gender}'),
          _buildInfoRow('Blood Group', details.bloodGroup),
          _buildInfoRow('Contact', details.contactNumber),
          if (details.email.isNotEmpty) _buildInfoRow('Email', details.email),
          _buildInfoRow('Address', details.address),
          if (details.height.isNotEmpty || details.weight.isNotEmpty)
            _buildInfoRow('Height / Weight', '${details.height} cm / ${details.weight} kg'),
          if (details.allergies.isNotEmpty) _buildInfoRow('Allergies', details.allergies),
          if (details.currentMedications.isNotEmpty)
            _buildInfoRow('Current Medications', details.currentMedications),
          if (details.medicalHistory.isNotEmpty) _buildInfoRow('Medical History', details.medicalHistory),
          if (details.reasonForVisit.isNotEmpty) _buildInfoRow('Reason for Visit', details.reasonForVisit),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 120,
            child: Text(label, style: AppTypography.cardBadge.copyWith(color: AppColors.muted, fontSize: 11)),
          ),
          Expanded(child: Text(value, style: AppTypography.bodyCopy.copyWith(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(BookedAppointment appointment) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadii.cardAll,
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_rounded, size: 32, color: AppColors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(appointment.doctorName, style: AppTypography.cardTitle),
                const SizedBox(height: 2),
                Text('${appointment.doctorSpecialty} • ${appointment.department}', style: AppTypography.cardSubtitle),
                const SizedBox(height: 6),
                Row(
                  children: <Widget>[
                    const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 4),
                    Text('4.8 Rating', style: AppTypography.cardBadge.copyWith(color: AppColors.ink, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentDetailsCard(BookedAppointment appointment, String formattedDate) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadii.cardAll,
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.event_available_rounded, size: 20, color: AppColors.brand),
              const SizedBox(width: 8),
              Text('Appointment Details', style: AppTypography.cardTitle),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow(Icons.calendar_today_rounded, 'Date', formattedDate),
          _buildDetailRow(Icons.access_time_rounded, 'Time', appointment.appointmentTime),
          _buildDetailRow(Icons.medical_services_rounded, 'Department', appointment.department),
          _buildDetailRow(Icons.local_hospital_rounded, 'Consultation Type', 'In-person'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.tile,
              borderRadius: AppRadii.chipAll,
            ),
            child: Icon(icon, size: 18, color: AppColors.brand),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label, style: AppTypography.cardBadge.copyWith(color: AppColors.muted, fontSize: 11)),
                const SizedBox(height: 2),
                Text(value, style: AppTypography.bodyCopy.copyWith(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalCard(BookedAppointment appointment) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadii.cardAll,
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.local_hospital_rounded, size: 20, color: AppColors.brand),
              const SizedBox(width: 8),
              Text('Hospital / Clinic', style: AppTypography.cardTitle),
            ],
          ),
          const SizedBox(height: 16),
          Text(appointment.hospitalName, style: AppTypography.cardTitle.copyWith(fontSize: 15)),
          const SizedBox(height: 4),
          Text(appointment.hospitalAddress, style: AppTypography.bodyCopy),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.directions_rounded, size: 18, color: AppColors.brand),
                  label: Text('Directions', style: AppTypography.bodyCopy.copyWith(color: AppColors.brand)),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: AppRadii.buttonAll), side: const BorderSide(color: AppColors.border)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.phone_rounded, size: 18, color: AppColors.brand),
                  label: Text('Call', style: AppTypography.bodyCopy.copyWith(color: AppColors.brand)),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: AppRadii.buttonAll), side: const BorderSide(color: AppColors.border)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummaryCard(BookedAppointment appointment) {
    final double consultationFee = appointment.consultationFee;
    final double taxes = consultationFee * 0.05;
    final double total = consultationFee + taxes;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadii.cardAll,
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.payment_rounded, size: 20, color: AppColors.brand),
              const SizedBox(width: 8),
              Text('Payment Summary', style: AppTypography.cardTitle),
            ],
          ),
          const SizedBox(height: 16),
          _buildPaymentRow('Consultation Fee', '₹${consultationFee.toInt()}'),
          _buildPaymentRow('Taxes & Fees (5%)', '₹${taxes.toInt()}'),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 12),
          _buildPaymentRow('Total Amount', '₹${total.toInt()}', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: isTotal
                ? AppTypography.bodyCopy.copyWith(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink)
                : AppTypography.bodyCopy.copyWith(fontSize: 13),
          ),
          Text(
            amount,
            style: isTotal
                ? AppTypography.cardTitle.copyWith(fontSize: 15, color: AppColors.brand)
                : AppTypography.bodyCopy.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: AppColors.cardShadow,
      ),
      child: SizedBox(
        height: AppSizes.buttonHeight,
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
            borderRadius: AppRadii.buttonAll,
            boxShadow: AppColors.brandGlow,
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: AppRadii.buttonAll,
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Appointment booked successfully!'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: const Color(0xFF22C55E),
                    duration: const Duration(seconds: 2),
                  ),
                );
                context.go('/home');
              },
              borderRadius: AppRadii.buttonAll,
              child: Center(child: Text('Confirm & Book Appointment', style: AppTypography.buttonLabel)),
            ),
          ),
        ),
      ),
    );
  }

  BookedAppointment _defaultAppointment() {
    return BookedAppointment(
      id: 'APT-DEFAULT',
      doctorName: 'Dr. Sarah Jenkins',
      doctorSpecialty: 'General Medicine',
      hospitalName: 'City General Hospital',
      hospitalAddress: '123 Main Street, City, State 12345',
      appointmentDate: DateTime.now(),
      appointmentTime: '10:30 AM',
      department: 'General Medicine',
      consultationFee: 500.0,
    );
  }
}
