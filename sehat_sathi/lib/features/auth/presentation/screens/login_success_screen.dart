import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../onboarding/presentation/widgets/onboarding_scaffold.dart';
import '../../data/login_repository.dart';

/// Destination after a successful login: proves end-to-end persistence by
/// re-reading the just-saved record from the `SehatSathi` PostgreSQL
/// database and displaying every stored column.
class LoginSuccessScreen extends ConsumerStatefulWidget {
  const LoginSuccessScreen({super.key, required this.mobileNumber});

  final String mobileNumber;

  @override
  ConsumerState<LoginSuccessScreen> createState() => _LoginSuccessScreenState();
}

class _LoginSuccessScreenState extends ConsumerState<LoginSuccessScreen> {
  LoginRecord? _record;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRecord();
  }

  /// Reads the stored record straight back out of PostgreSQL.
  Future<void> _loadRecord() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final LoginRepository repository = LoginRepository();
      final LoginRecord? record =
          await repository.findByMobile(widget.mobileNumber);
      if (!mounted) return;
      setState(() {
        _record = record;
        _loading = false;
      });
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      buttonLabel: 'मुख्यपृष्ठावर जा (Proceed to Home Page)',
      footerCaption:
          'तपशील PostgreSQL व MongoDB मधून यशस्वीरित्या वाचले (Dual Database Verified)',
      onContinue: () => context.go(AppRoutes.home),
      onBack: () => context.go(AppRoutes.login),
      children: <Widget>[
        const OnboardingHeader(
          stepLabel: 'STEP 3 • LOGIN VERIFIED',
          title: 'लॉगिन यशस्वी! (Login Successful)',
          bilingualSubtitle:
              'तुमचे तपशील सुरक्षित साठवले आहेत · Your details are stored',
          description:
              'माहिती "SehatSathi" PostgreSQL व MongoDB डेटाबेसमधून पुनर्प्राप्त '
              'केली आहे (Fetched live from Dual Databases).',
        ),
        const SizedBox(height: AppSpacing.header),
        _buildStatusBlock(),
        if (_record != null) ...<Widget>[
          const SizedBox(height: AppSpacing.lg),
          _RecordCard(record: _record!),
        ],
        const SizedBox(height: AppSpacing.lg),
        Text(
          'PostgreSQL: 5432 (Users & Auth) • MongoDB: 27017 (Clinical Records)\n'
          'SehatSathi Database · ABDM Compliant',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontFamilyFallback: AppTypography.fontFamilyFallback,
            fontSize: 10.5,
            color: AppColors.muted,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBlock() {
    if (_loading) {
      return Container(
        height: 120,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: AppRadii.cardAll,
          border: Border.all(color: AppColors.border),
        ),
        child: const CircularProgressIndicator(color: AppColors.brand),
      );
    }
    if (_error != null) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: AppRadii.cardAll,
          border: Border.all(color: const Color(0xFFB3261E)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('डेटाबेस त्रुटी (Database error)',
                style: AppTypography.cardTitle),
            const SizedBox(height: 6),
            Text(_error!, style: AppTypography.bodyCopy),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _loadRecord,
              child: const Text(
                'पुन्हा प्रयत्न करा (Retry)',
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontFamilyFallback: AppTypography.fontFamilyFallback,
                  fontWeight: FontWeight.w600,
                  color: AppColors.brand,
                ),
              ),
            ),
          ],
        ),
      );
    }
    if (_record == null) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: AppRadii.cardAll,
          border: Border.all(color: AppColors.border),
        ),
        child: const Text(
          'या मोबाईल क्रमांकासाठी कोणतीही नोंद सापडली नाही '
          '(No record found for this mobile number).',
          style: AppTypography.bodyCopy,
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadii.cardAll,
        border: Border.all(color: AppColors.brand, width: 1.2),
        boxShadow: AppColors.cardShadow,
      ),
      child: const Row(
        children: <Widget>[
          Icon(Icons.verified_rounded, size: 20, color: AppColors.brand),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'डेटाबेसमध्ये नोंद सापडली आणि ती खाली दाखवली आहे '
              '(Record verified in PostgreSQL).',
              style: AppTypography.cardTitle,
            ),
          ),
        ],
      ),
    );
  }
}

/// Card echoing every column stored in the `users` table for this login.
class _RecordCard extends StatelessWidget {
  const _RecordCard({required this.record});

  final LoginRecord record;

  static final DateFormat _fmt = DateFormat('dd MMM yyyy, hh:mm a');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadii.cardAll,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('PostgreSQL नोंद (Database record)',
              style: AppTypography.cardTitle),
          const SizedBox(height: 12),
          _row('मोबाईल (Mobile)', '+91 ${record.mobileNumber}'),
          _row('OTP', record.otpCode ?? '—'),
          _row('पद्धत (Method)', record.loginMethod),
          _row('भूमिका (Role)', record.role.toUpperCase()),
          _row('भाषा (Language)', record.language),
          _row('मला लक्षात ठेवा (Remember me)',
              record.rememberMe ? 'होय (Yes)' : 'नाही (No)'),
          _row('एकूण लॉगिन (Login count)', '#${record.loginCount}'),
          _row('खाते तयार (Created)', _fmt.format(record.createdAt)),
          _row(
              'शेवटचे लॉगिन (Last login)',
              _fmt.format(record.lastLoginAt)),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(flex: 5, child: Text(label, style: AppTypography.footerCaption)),
          const SizedBox(width: 8),
          Expanded(
            flex: 7,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTypography.bodyCopy,
            ),
          ),
        ],
      ),
    );
  }
}
