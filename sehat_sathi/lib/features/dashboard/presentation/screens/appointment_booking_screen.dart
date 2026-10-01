import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/appointment_models.dart';
import '../providers/appointment_providers.dart';
import '../widgets/dashboard_titlebar.dart';

class AppointmentBookingScreen extends ConsumerStatefulWidget {
  const AppointmentBookingScreen({super.key});

  @override
  ConsumerState<AppointmentBookingScreen> createState() => _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends ConsumerState<AppointmentBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _medicalHistoryController = TextEditingController();
  final _currentMedicationsController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _reasonController = TextEditingController();

  String _selectedBloodGroup = '';
  String _selectedGender = '';

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _medicalHistoryController.dispose();
    _currentMedicationsController.dispose();
    _allergiesController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Department> deptList = ref.watch(departmentsProvider);
    final List<Doctor> doctorList = ref.watch(doctorsProvider);
    final List<DateTime> dates = ref.watch(appointmentDatesProvider);
    final String? selectedDoctorId = ref.watch(selectedDoctorProvider);
    final String? selectedDeptId = ref.watch(selectedDepartmentProvider);
    final String? selectedDate = ref.watch(selectedDateProvider);
    final String? selectedTime = ref.watch(selectedTimeProvider);

    final List<Doctor> filteredDoctors = selectedDeptId != null
        ? doctorList.where((Doctor d) => d.specialty.toLowerCase().contains(
            deptList.firstWhere((Department d) => d.id == selectedDeptId).name.toLowerCase())).toList()
        : doctorList;

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
                      title: 'Book Appointment',
                      subtitle: 'Enter patient details and select doctor',
                      onBack: () => context.pop(),
                    ),
                    const SizedBox(height: 16),
                    Text('STEP 1 OF 2', style: AppTypography.stepLabel),
                    const SizedBox(height: 16),
                    _buildPatientDetailsForm(),
                    const SizedBox(height: 24),
                    _buildDepartmentSection(deptList, selectedDeptId),
                    const SizedBox(height: 24),
                    _buildDoctorSection(filteredDoctors, selectedDoctorId),
                    const SizedBox(height: 24),
                    _buildDateTimeSection(dates, selectedDate, selectedTime),
                  ],
                ),
              ),
            ),
            _buildConfirmButton(selectedDoctorId, selectedDate, selectedTime),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientDetailsForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadii.cardAll,
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Patient Details', style: AppTypography.cardTitle),
            const SizedBox(height: 16),
            _buildTextField(_nameController, 'Full Name', Icons.person_outline_rounded, 'Please enter full name'),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(child: _buildTextField(_ageController, 'Age', Icons.calendar_today_rounded, 'Enter age')),
                const SizedBox(width: 12),
                Expanded(child: _buildBloodGroupDropdown()),
              ],
            ),
            const SizedBox(height: 12),
            _buildGenderDropdown(),
            const SizedBox(height: 12),
            _buildTextField(_contactController, 'Contact Number', Icons.phone_rounded, 'Enter contact number'),
            const SizedBox(height: 12),
            _buildTextField(_emailController, 'Email Address', Icons.email_outlined, 'Enter email address', isEmail: true),
            const SizedBox(height: 12),
            _buildTextField(_addressController, 'Address', Icons.location_on_rounded, 'Enter full address', maxLines: 3),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(child: _buildTextField(_heightController, 'Height (cm)', Icons.height_rounded, 'Enter height in cm')),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField(_weightController, 'Weight (kg)', Icons.monitor_weight_rounded, 'Enter weight in kg')),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField(_medicalHistoryController, 'Medical History', Icons.history_rounded, 'Enter any known medical conditions', maxLines: 3),
            const SizedBox(height: 12),
            _buildTextField(_currentMedicationsController, 'Current Medications', Icons.medication_rounded, 'List current medications if any', maxLines: 3),
            const SizedBox(height: 12),
            _buildTextField(_allergiesController, 'Allergies', Icons.warning_rounded, 'List any known allergies', maxLines: 2),
            const SizedBox(height: 12),
            _buildTextField(_reasonController, 'Reason for Visit', Icons.local_hospital_rounded, 'Describe the reason for this appointment', maxLines: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    String errorText, {
    bool isEmail = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isEmail
          ? TextInputType.emailAddress
          : (label.contains('Age') || label.contains('Height') || label.contains('Weight')
              ? TextInputType.number
              : maxLines > 1
                  ? TextInputType.multiline
                  : TextInputType.text),
      maxLines: maxLines,
      style: AppTypography.field,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.fieldHint,
        prefixIcon: Icon(icon, size: 20, color: AppColors.body),
        border: OutlineInputBorder(
          borderRadius: AppRadii.fieldAll,
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.fieldAll,
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.fieldAll,
          borderSide: BorderSide(color: AppColors.brand, width: 2),
        ),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: maxLines > 1 ? 12 : 14),
      ),
      validator: (String? value) {
        if (label.contains('Full Name') || label.contains('Contact Number') || label.contains('Address') || label.contains('Age')) {
          if (value == null || value.isEmpty) {
            return errorText;
          }
        }
        return null;
      },
    );
  }

  Widget _buildBloodGroupDropdown() {
    final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
    return Expanded(
      child: DropdownButtonFormField<String>(
        value: _selectedBloodGroup.isEmpty ? null : _selectedBloodGroup,
        decoration: InputDecoration(
          labelText: 'Blood Group',
          labelStyle: AppTypography.fieldHint,
          prefixIcon: const Icon(Icons.bloodtype_rounded, size: 20, color: AppColors.body),
          border: OutlineInputBorder(
            borderRadius: AppRadii.fieldAll,
            borderSide: BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadii.fieldAll,
            borderSide: BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadii.fieldAll,
            borderSide: BorderSide(color: AppColors.brand, width: 2),
          ),
          filled: true,
          fillColor: AppColors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        items: bloodGroups.map((String bg) => DropdownMenuItem<String>(value: bg, child: Text(bg, style: AppTypography.field))).toList(),
        onChanged: (String? value) => setState(() => _selectedBloodGroup = value ?? ''),
        validator: (String? value) {
          if (value == null || value.isEmpty) return 'Please select blood group';
          return null;
        },
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGender.isEmpty ? null : _selectedGender,
      decoration: InputDecoration(
        labelText: 'Gender',
        labelStyle: AppTypography.fieldHint,
        prefixIcon: const Icon(Icons.person_rounded, size: 20, color: AppColors.body),
        border: OutlineInputBorder(
          borderRadius: AppRadii.fieldAll,
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.fieldAll,
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.fieldAll,
          borderSide: BorderSide(color: AppColors.brand, width: 2),
        ),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      items: const <String>['Male', 'Female', 'Other'].map((String g) => DropdownMenuItem<String>(value: g, child: Text(g))).toList(),
      onChanged: (String? value) => setState(() => _selectedGender = value ?? ''),
      validator: (String? value) {
        if (value == null || value.isEmpty) return 'Please select gender';
        return null;
      },
    );
  }

  Widget _buildDepartmentSection(List<Department> deptList, String? selectedDeptId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Select Department', style: AppTypography.cardTitle.copyWith(fontSize: 16)),
        const SizedBox(height: 4),
        Text('Choose a medical department', style: AppTypography.cardSubtitle),
        const SizedBox(height: 12),
        SizedBox(
          height: 70,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: deptList.length,
            separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 12),
            itemBuilder: (BuildContext context, int index) {
              final Department dept = deptList[index];
              final bool isSelected = selectedDeptId == dept.id;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => ref.read(selectedDepartmentProvider.notifier).state = dept.id,
                  borderRadius: AppRadii.chipAll,
                  child: Container(
                    width: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.selectedTint : AppColors.white,
                      borderRadius: AppRadii.chipAll,
                      border: Border.all(color: isSelected ? AppColors.brand : AppColors.border),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A90D9).withValues(alpha: 0.1),
                            borderRadius: AppRadii.chipAll,
                          ),
                          child: Icon(dept.icon, size: 16, color: const Color(0xFF4A90D9)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dept.name,
                          style: TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontFamilyFallback: AppTypography.fontFamilyFallback,
                            fontSize: 10,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? AppColors.brand : AppColors.ink,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorSection(List<Doctor> doctors, String? selectedDoctorId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Select Doctor', style: AppTypography.cardTitle.copyWith(fontSize: 16)),
        const SizedBox(height: 4),
        Text('Choose a doctor from the list', style: AppTypography.cardSubtitle),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: doctors.length,
          separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 12),
          itemBuilder: (BuildContext context, int index) {
            final Doctor doctor = doctors[index];
            final bool isSelected = selectedDoctorId == doctor.id;
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => ref.read(selectedDoctorProvider.notifier).state = doctor.id,
                borderRadius: AppRadii.cardAll,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.selectedTint : AppColors.white,
                    borderRadius: AppRadii.cardAll,
                    border: Border.all(
                      color: isSelected ? AppColors.brand : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: AppColors.brandGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person_rounded, size: 28, color: AppColors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(doctor.name, style: AppTypography.cardTitle.copyWith(fontSize: 15)),
                            const SizedBox(height: 2),
                            Text('${doctor.specialty} • ${doctor.hospital}', style: AppTypography.cardSubtitle),
                            const SizedBox(height: 6),
                            Row(
                              children: <Widget>[
                                const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                                const SizedBox(width: 4),
                                Text('${doctor.rating}', style: AppTypography.cardBadge.copyWith(color: AppColors.ink, fontSize: 11)),
                                const SizedBox(width: 12),
                                Text('${doctor.yearsOfExperience} yrs experience', style: AppTypography.cardBadge.copyWith(color: AppColors.muted, fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (isSelected)
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            gradient: AppColors.brandGradient,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check_rounded, size: 14, color: AppColors.white),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDateTimeSection(List<DateTime> dates, String? selectedDate, String? selectedTime) {
    final List<String> dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final List<String> monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final List<String> times = ['08:00 AM', '09:00 AM', '10:30 AM', '11:30 AM', '02:00 PM', '03:00 PM', '04:30 PM', '05:30 PM'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Select Date & Time', style: AppTypography.cardTitle.copyWith(fontSize: 16)),
        const SizedBox(height: 4),
        Text('Choose your preferred date and time slot', style: AppTypography.cardSubtitle),
        const SizedBox(height: 12),
        SizedBox(
          height: 70,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 12),
            itemBuilder: (BuildContext context, int index) {
              final DateTime date = dates[index];
              final String dateStr = '${date.day} ${monthNames[date.month - 1]}';
              final bool isSelected = selectedDate == dateStr;
              final Color bgColor = isSelected ? AppColors.brand : AppColors.white;
              final Color textColor = isSelected ? AppColors.white : AppColors.ink;
              final Color subTextColor = isSelected ? AppColors.white.withValues(alpha: 0.8) : AppColors.body;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => ref.read(selectedDateProvider.notifier).state = dateStr,
                  borderRadius: AppRadii.cardAll,
                  child: Container(
                    width: 56,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: AppRadii.cardAll,
                      border: Border.all(color: isSelected ? AppColors.brand : AppColors.border, width: isSelected ? 2 : 1),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(dayNames[date.weekday - 1], style: TextStyle(fontFamily: AppTypography.fontFamily, fontFamilyFallback: AppTypography.fontFamilyFallback, fontSize: 11, fontWeight: FontWeight.w600, color: subTextColor)),
                        const SizedBox(height: 2),
                        Text(date.day.toString(), style: TextStyle(fontFamily: AppTypography.fontFamily, fontFamilyFallback: AppTypography.fontFamilyFallback, fontSize: 16, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600, color: textColor)),
                        Text(monthNames[date.month - 1], style: TextStyle(fontFamily: AppTypography.fontFamily, fontFamilyFallback: AppTypography.fontFamilyFallback, fontSize: 10, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500, color: subTextColor)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        if (selectedDate != null) ...<Widget>[
          Text('Available Time Slots', style: AppTypography.cardBadge.copyWith(color: AppColors.body, fontSize: 11)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: times.map((String time) {
              final bool isSelected = selectedTime == time;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => ref.read(selectedTimeProvider.notifier).state = time,
                  borderRadius: AppRadii.chipAll,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.brand : AppColors.white,
                      borderRadius: AppRadii.chipAll,
                      border: Border.all(color: isSelected ? AppColors.brand : AppColors.border, width: isSelected ? 2 : 1),
                    ),
                    child: Text(
                      time,
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontFamilyFallback: AppTypography.fontFamilyFallback,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? AppColors.white : AppColors.ink,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ] else ...<Widget>[
          Text('Select a date to see available time slots', style: AppTypography.cardSubtitle.copyWith(color: AppColors.muted)),
        ],
      ],
    );
  }

  Widget _buildConfirmButton(String? selectedDoctorId, String? selectedDate, String? selectedTime) {
    final bool canProceed = selectedDoctorId != null && selectedDate != null && selectedTime != null;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: AppColors.cardShadow,
      ),
      child: SizedBox(
        height: AppSizes.buttonHeight,
        child: canProceed
            ? Container(
                decoration: BoxDecoration(gradient: AppColors.brandGradient, borderRadius: AppRadii.buttonAll, boxShadow: AppColors.brandGlow),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: AppRadii.buttonAll,
                  child: InkWell(
                    onTap: _savePatientAndProceed,
                    borderRadius: AppRadii.buttonAll,
                    child: Center(child: Text('Confirm Appointment Slot', style: AppTypography.buttonLabel)),
                  ),
                ),
              )
            : Container(
                decoration: BoxDecoration(color: AppColors.muted.withValues(alpha: 0.15), borderRadius: AppRadii.buttonAll),
                child: const Center(
                  child: Text(
                    'Confirm Appointment Slot',
                    style: TextStyle(fontFamily: AppTypography.fontFamily, fontFamilyFallback: AppTypography.fontFamilyFallback, fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.muted),
                  ),
                ),
              ),
      ),
    );
  }

  void _savePatientAndProceed() {
    if (_formKey.currentState!.validate()) {
      final AppointmentPatientDetails details = AppointmentPatientDetails(
        fullName: _nameController.text,
        age: _ageController.text,
        bloodGroup: _selectedBloodGroup,
        address: _addressController.text,
        contactNumber: _contactController.text,
        email: _emailController.text,
        gender: _selectedGender,
        height: _heightController.text,
        weight: _weightController.text,
        medicalHistory: _medicalHistoryController.text,
        currentMedications: _currentMedicationsController.text,
        allergies: _allergiesController.text,
        reasonForVisit: _reasonController.text,
      );
      ref.read(patientDetailsProvider.notifier).state = details;

      final String? doctorId = ref.read(selectedDoctorProvider);
      final String? date = ref.read(selectedDateProvider);
      final String? time = ref.read(selectedTimeProvider);
      final List<Doctor> allDoctors = ref.read(doctorsProvider);
      final Doctor doctor = allDoctors.firstWhere(
        (Doctor d) => d.id == doctorId,
        orElse: () => allDoctors.first,
      );

      final BookedAppointment appointment = BookedAppointment(
        id: 'APT-${DateTime.now().millisecondsSinceEpoch}',
        doctorName: doctor.name,
        doctorSpecialty: doctor.specialty,
        hospitalName: doctor.hospital,
        hospitalAddress: '123 Main Street, City, State 12345',
        appointmentDate: DateTime.now(),
        appointmentTime: time ?? '10:30 AM',
        department: doctor.specialty,
        consultationFee: 500.0,
        patientName: details.fullName,
        patientAge: int.tryParse(details.age),
        reason: details.reasonForVisit,
      );

      ref.read(bookedAppointmentProvider.notifier).state = appointment;
      context.push('/appointment-confirmation');
    }
  }
}
