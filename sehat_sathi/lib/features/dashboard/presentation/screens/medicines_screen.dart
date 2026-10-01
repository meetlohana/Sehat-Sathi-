import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/medicine_models.dart';
import '../providers/medicine_providers.dart';
import '../widgets/dashboard_titlebar.dart';

class MedicinesScreen extends ConsumerStatefulWidget {
  const MedicinesScreen({super.key});

  @override
  ConsumerState<MedicinesScreen> createState() => _MedicinesScreenState();
}

class _MedicinesScreenState extends ConsumerState<MedicinesScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<ActiveMedication> medications = _medications;

    return Scaffold(
      backgroundColor: const Color(0xFFEEF3FB),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // ── Title bar ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: DashboardTitleBar(
                title: 'Medicines',
                subtitle: '${medications.length} Daily Refills',
                onBack: () => context.pop(),
              ),
            ),

            // ── Segmented control ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.tile,
                  borderRadius: AppRadii.chipAll,
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: List.generate(2, (int index) {
                    final bool isActive = _selectedIndex == index;
                    final List<String> tabs = ['Active', 'History'];
                    final List<int> counts = [medications.length, 5];
                    return Expanded(
                      child: Material(
                        color: isActive ? AppColors.white : Colors.transparent,
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(index == 0 ? AppRadii.chip : 0),
                          right: Radius.circular(index == 1 ? AppRadii.chip : 0),
                        ),
                        child: InkWell(
                          onTap: () => setState(() => _selectedIndex = index),
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(index == 0 ? AppRadii.chip : 0),
                            right: Radius.circular(index == 1 ? AppRadii.chip : 0),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${tabs[index]} ',
                                  style: TextStyle(
                                    fontFamily: AppTypography.fontFamily,
                                    fontFamilyFallback: AppTypography.fontFamilyFallback,
                                    fontSize: 14,
                                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                                    color: isActive ? AppColors.brand : AppColors.body,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isActive ? AppColors.brand : AppColors.border,
                                    borderRadius: AppRadii.chipAll,
                                  ),
                                  child: Text(
                                    counts[index].toString(),
                                    style: TextStyle(
                                      fontFamily: AppTypography.fontFamily,
                                      fontFamilyFallback: AppTypography.fontFamilyFallback,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      height: 1.2,
                                      color: isActive ? AppColors.white : AppColors.muted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // ── Tab views ───────────────────────────────────────────────────
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: <Widget>[
                  // ── Active Medications ───────────────────────────────────────
                  medications.isEmpty
                      ? _EmptyMedicationsState()
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          itemCount: medications.length,
                          separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 12),
                          itemBuilder: (BuildContext context, int index) {
                            final ActiveMedication med = medications[index];
                            return _ActiveMedicationCard(medication: med);
                          },
                        ),

                  // ── Prescription History ───────────────────────────────────
                  _HistoryTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mock data fallback when provider is not available in build context
  List<ActiveMedication> get _medications {
    final now = DateTime.now();
    return [
      ActiveMedication(
        medicationId: 'MED-001',
        name: 'Metformin',
        dosage: '500mg',
        form: MedicationForm.tablet,
        frequency: MedicationFrequency.threeTimesDaily,
        doseTimes: [const TimeOfDay(hour: 8, minute: 0), const TimeOfDay(hour: 14, minute: 0), const TimeOfDay(hour: 20, minute: 0)],
        startDate: DateTime(2024, 9, 15),
        endDate: DateTime(2024, 12, 15),
        totalDurationDays: 90,
        daysCompleted: 16,
        refillsRemaining: 2,
        refillsTotal: 3,
        prescribingDoctor: 'Dr. Sarah Jenkins',
        doctorSpecialty: 'General Medicine',
        instructions: 'Take with meals to reduce stomach upset.',
        reminderEnabled: true,
        doseHistory: [
          DoseLog(id: '1', scheduledTime: now.subtract(const Duration(days: 1)), takenAt: now.subtract(const Duration(days: 1)), wasTaken: true),
          DoseLog(id: '2', scheduledTime: DateTime(now.year, now.month, now.day, 8, 0), takenAt: null, wasTaken: false),
          DoseLog(id: '3', scheduledTime: DateTime(now.year, now.month, now.day, 14, 0), takenAt: null, wasTaken: false),
          DoseLog(id: '4', scheduledTime: DateTime(now.year, now.month, now.day, 20, 0), takenAt: null, wasTaken: false),
        ],
        status: MedicationStatus.active,
      ),
      ActiveMedication(
        medicationId: 'MED-002',
        name: 'Amlodipine',
        dosage: '5mg',
        form: MedicationForm.tablet,
        frequency: MedicationFrequency.onceDaily,
        doseTimes: [const TimeOfDay(hour: 21, minute: 0)],
        startDate: DateTime(2024, 8, 28),
        endDate: DateTime(2024, 9, 28),
        totalDurationDays: 30,
        daysCompleted: 30,
        refillsRemaining: 0,
        refillsTotal: 1,
        prescribingDoctor: 'Dr. Rajesh Kumar',
        doctorSpecialty: 'Cardiology',
        instructions: 'Take at bedtime. May cause ankle swelling.',
        reminderEnabled: true,
        doseHistory: List.generate(30, (i) => DoseLog(id: 'A-$i', scheduledTime: DateTime(2024, 8, 28 + i, 21, 0), takenAt: DateTime(2024, 8, 28 + i, 21, 10), wasTaken: true)),
        status: MedicationStatus.refillNeeded,
      ),
      ActiveMedication(
        medicationId: 'MED-003',
        name: 'Atorvastatin',
        dosage: '20mg',
        form: MedicationForm.tablet,
        frequency: MedicationFrequency.onceDaily,
        doseTimes: [const TimeOfDay(hour: 21, minute: 0)],
        startDate: DateTime(2024, 9, 1),
        endDate: DateTime(2024, 11, 30),
        totalDurationDays: 90,
        daysCompleted: 30,
        refillsRemaining: 1,
        refillsTotal: 2,
        prescribingDoctor: 'Dr. Sarah Jenkins',
        doctorSpecialty: 'General Medicine',
        instructions: 'Take at night. Avoid grapefruit juice.',
        reminderEnabled: true,
        doseHistory: List.generate(30, (i) => DoseLog(id: 'AT-$i', scheduledTime: DateTime(2024, 9, 1 + i, 21, 0), takenAt: DateTime(2024, 9, 1 + i, 21, 5), wasTaken: true)),
        status: MedicationStatus.active,
      ),
    ];
  }
}

// ══════════════════════════════════════════════════════════════════
// Active Medication Card
// ══════════════════════════════════════════════════════════════════
class _ActiveMedicationCard extends StatelessWidget {
  const _ActiveMedicationCard({required this.medication});
  final ActiveMedication medication;

  @override
  Widget build(BuildContext context) {
    final bool needsRefill = medication.needsRefill;
    final bool expiringSoon = medication.isExpiringSoon;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadii.cardAll,
        border: Border.all(
          color: needsRefill ? const Color(0xFFDC2626) : (expiringSoon ? const Color(0xFFF59E0B) : AppColors.border),
          width: needsRefill || expiringSoon ? 2 : 1,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Header: medicine icon + name + status badge
          Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: medication.form.bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(medication.form.icon, size: 22, color: medication.form.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      medication.displayName,
                      style: AppTypography.cardTitle.copyWith(fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${medication.prescribingDoctor} • ${medication.doctorSpecialty}',
                      style: AppTypography.cardSubtitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: medication.status.bgColor,
                      borderRadius: AppRadii.chipAll,
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(medication.status.icon, size: 10, color: medication.status.color),
                        const SizedBox(width: 4),
                        Text(medication.status.label, style: AppTypography.badge.copyWith(color: medication.status.color, fontSize: 9)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    medication.frequency.label,
                    style: AppTypography.cardBadge.copyWith(color: AppColors.brand, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Dose times banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.tile,
              borderRadius: AppRadii.fieldAll,
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Next Dose Schedule', style: AppTypography.stepLabel.copyWith(fontSize: 11)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: medication.doseTimes.asMap().entries.map((entry) {
                    final int idx = entry.key;
                    final TimeOfDay time = entry.value;
                    final bool isTodayTaken = medication.doseHistory.any((log) =>
                      log.wasTaken &&
                      log.scheduledTime.year == DateTime.now().year &&
                      log.scheduledTime.month == DateTime.now().month &&
                      log.scheduledTime.day == DateTime.now().day &&
                      log.scheduledTime.hour == time.hour &&
                      log.scheduledTime.minute == time.minute
                    );
                    final bool isPending = time.hour > DateTime.now().hour ||
                      (time.hour == DateTime.now().hour && time.minute > DateTime.now().minute);

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isTodayTaken ? AppColors.white : (isPending ? AppColors.selectedTint : AppColors.white),
                        borderRadius: AppRadii.chipAll,
                        border: Border.all(color: isTodayTaken ? AppColors.brand : AppColors.border),
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            isTodayTaken ? Icons.check_circle_rounded : Icons.access_time_rounded,
                            size: 14,
                            color: isTodayTaken ? AppColors.brand : AppColors.muted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontFamilyFallback: AppTypography.fontFamilyFallback,
                              fontSize: 12,
                              fontWeight: isTodayTaken ? FontWeight.w700 : FontWeight.w500,
                              color: isTodayTaken ? AppColors.brand : AppColors.body,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Progress', style: AppTypography.stepLabel),
                  Text(
                    '${medication.daysCompleted}/${medication.totalDurationDays} days',
                    style: AppTypography.bodyCopy.copyWith(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Stack(
                    children: <Widget>[
                      Container(
                        height: 6,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      if (medication.progress > 0)
                        Positioned(
                          child: Container(
                            height: 6,
                            width: constraints.maxWidth * medication.progress,
                            decoration: BoxDecoration(
                              gradient: AppColors.brandGradient,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Refills info
          Row(
            children: <Widget>[
              Icon(Icons.inventory_rounded, size: 16, color: medication.refillsRemaining > 0 ? AppColors.body : const Color(0xFFDC2626)),
              const SizedBox(width: 6),
              Text(
                'Refills: ${medication.refillsRemaining}/${medication.refillsTotal}',
                style: AppTypography.bodyCopy.copyWith(
                  fontSize: 13,
                  color: medication.refillsRemaining > 0 ? AppColors.body : const Color(0xFFDC2626),
                  fontWeight: medication.refillsRemaining == 0 ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Actions
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening dose schedule for ${medication.name}')),
                    );
                  },
                  icon: const Icon(Icons.schedule_rounded, size: 18, color: AppColors.brand),
                  label: Text('Dose Schedule', style: AppTypography.bodyCopy.copyWith(color: AppColors.brand)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: AppRadii.buttonAll),
                    side: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (medication.refillsRemaining == 0)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Refill requested for ${medication.name}')),
                      );
                    },
                    icon: const Icon(Icons.local_pharmacy_rounded, size: 18),
                    label: const Text('Request Refill'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brand,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: AppRadii.buttonAll),
                    ),
                  ),
                ),
              if (medication.refillsRemaining == 0) const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Marked ${medication.name} as taken')),
                    );
                  },
                  icon: const Icon(Icons.check_circle_rounded, size: 18),
                  label: const Text('Mark Taken'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22C55E),
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: AppRadii.buttonAll),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// History Tab
// ══════════════════════════════════════════════════════════════════
class _HistoryTab extends ConsumerStatefulWidget {
  const _HistoryTab();

  @override
  ConsumerState<_HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends ConsumerState<_HistoryTab> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Completed', 'Discontinued'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<PrescriptionRecord>> historyAsync = ref.watch(prescriptionHistoryProvider);

    return Column(
      children: <Widget>[
        // Search & filters
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            children: <Widget>[
              // Search bar
              Container(
                height: AppSizes.fieldHeight,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: AppRadii.fieldAll,
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppColors.cardShadow,
                ),
                child: TextField(
                  controller: _searchController,
                  style: AppTypography.field,
                  decoration: InputDecoration(
                    hintText: 'Search medicines, doctors...',
                    hintStyle: AppTypography.fieldHint,
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.muted, size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (String value) {
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(height: 12),
              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((String filter) {
                    final bool isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Material(
                        color: isSelected ? AppColors.brand : AppColors.tile,
                        borderRadius: AppRadii.chipAll,
                        child: InkWell(
                          onTap: () => setState(() => _selectedFilter = filter),
                          borderRadius: AppRadii.chipAll,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: AppRadii.chipAll,
                              border: Border.all(
                                color: isSelected ? AppColors.brand : AppColors.border,
                              ),
                            ),
                            child: Text(
                              filter,
                              style: AppTypography.cardBadge.copyWith(
                                color: isSelected ? AppColors.white : AppColors.body,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        // Prescription list
        Expanded(
          child: historyAsync.when(
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.brand)),
            error: (Object e, StackTrace s) => Center(
              child: Text('Error loading history', style: AppTypography.bodyCopy),
            ),
            data: (List<PrescriptionRecord> allRecords) {
              final String searchQuery = _searchController.text.toLowerCase();
              final List<PrescriptionRecord> filtered = allRecords.where((record) {
                final bool matchesSearch = searchQuery.isEmpty ||
                  record.doctorName.toLowerCase().contains(searchQuery) ||
                  record.medications.any((med) => med.name.toLowerCase().contains(searchQuery));
                final bool matchesFilter = _selectedFilter == 'All' ||
                  record.status.label.toLowerCase().contains(_selectedFilter.toLowerCase());
                return matchesSearch && matchesFilter;
              }).toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Text('No prescriptions found', style: AppTypography.bodyCopy),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemCount: filtered.length,
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 12),
                itemBuilder: (BuildContext context, int index) {
                  final PrescriptionRecord record = filtered[index];
                  return _PrescriptionRecordCard(record: record);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// Prescription Record Card (Accordion)
// ══════════════════════════════════════════════════════════════════
class _PrescriptionRecordCard extends StatefulWidget {
  const _PrescriptionRecordCard({required this.record});
  final PrescriptionRecord record;

  @override
  State<_PrescriptionRecordCard> createState() => _PrescriptionRecordCardState();
}

class _PrescriptionRecordCardState extends State<_PrescriptionRecordCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _iconRotation = Tween<double>(begin: 0, end: 0.5).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadii.cardAll,
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: <Widget>[
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _controller.isCompleted ? _controller.reverse() : _controller.forward();
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  Icon(Icons.description_rounded, size: 20, color: _statusColor(widget.record.status)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.record.doctorName,
                          style: AppTypography.cardTitle.copyWith(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.record.doctorSpecialty,
                          style: AppTypography.cardSubtitle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(widget.record.prescribedDate),
                    style: AppTypography.cardSubtitle,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusBgColor(widget.record.status),
                      borderRadius: AppRadii.chipAll,
                    ),
                    child: Text(
                      '${widget.record.medicationCount} meds',
                      style: AppTypography.badge.copyWith(
                        color: _statusColor(widget.record.status),
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  RotationTransition(
                    turns: _iconRotation,
                    child: const Icon(Icons.expand_more_rounded, size: 18, color: AppColors.muted),
                  ),
                ],
              ),
            ),
          ),
          // Expanded content
          SizeTransition(
            sizeFactor: _controller,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 12),
                  // Medications list
                  ...widget.record.medications.asMap().entries.map((entry) {
                    final PrescribedMedication med = entry.value;
                    final bool isLast = entry.key == widget.record.medications.length - 1;
                    return Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: med.form.bgColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(med.form.icon, size: 16, color: med.form.color),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(med.name, style: AppTypography.cardTitle.copyWith(fontSize: 13)),
                                const SizedBox(height: 2),
                                Text('${med.dosage} • ${med.frequency.label} • ${med.durationDays} days', style: AppTypography.cardSubtitle),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  if (widget.record.notes != null && widget.record.notes!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text('Notes / नोट्स', style: AppTypography.stepLabel),
                    const SizedBox(height: 4),
                    Text(widget.record.notes!, style: AppTypography.bodyCopy.copyWith(fontSize: 12.5)),
                  ],
                  const SizedBox(height: 12),
                  // Action buttons
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: widget.record.pdfUrl != null ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Downloading ${widget.record.prescriptionId}')),
                            );
                          } : null,
                          icon: const Icon(Icons.download_rounded, size: 18),
                          label: const Text('Download PDF'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: AppRadii.buttonAll),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Refill requested for ${widget.record.prescriptionId}')),
                            );
                          },
                          icon: const Icon(Icons.local_pharmacy_rounded, size: 18),
                          label: const Text('Request Refill'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brand,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: AppRadii.buttonAll),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(PrescriptionStatus status) {
    switch (status) {
      case PrescriptionStatus.completed:
        return const Color(0xFF22C55E);
      case PrescriptionStatus.discontinued:
        return const Color(0xFFDC2626);
      case PrescriptionStatus.ongoing:
        return const Color(0xFF4A90D9);
    }
  }

  Color _statusBgColor(PrescriptionStatus status) {
    switch (status) {
      case PrescriptionStatus.completed:
        return const Color(0xFFECFDF5);
      case PrescriptionStatus.discontinued:
        return const Color(0xFFFFEBEE);
      case PrescriptionStatus.ongoing:
        return const Color(0xFFEAF2FB);
    }
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

// ══════════════════════════════════════════════════════════════════
// Empty State
// ══════════════════════════════════════════════════════════════════
class _EmptyMedicationsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.medication_rounded, size: 64, color: AppColors.muted),
          const SizedBox(height: 16),
          Text('No Active Medications', style: AppTypography.screenTitle),
          const SizedBox(height: 8),
          Text(
            'Your current medications will appear here.\nAdd a new prescription to get started.',
            style: AppTypography.bodyCopy,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}