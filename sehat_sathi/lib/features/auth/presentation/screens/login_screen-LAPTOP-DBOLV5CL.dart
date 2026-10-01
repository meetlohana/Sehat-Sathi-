import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/i18n/i18n.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../onboarding/data/onboarding_catalog.dart';
import '../../../onboarding/domain/onboarding_models.dart';
import '../../../onboarding/presentation/providers/onboarding_providers.dart';
import '../../data/login_repository.dart';
import '../../data/user_health_repository.dart';
import '../widgets/abha_health_id_card.dart';
import '../widgets/login_widgets.dart';

/// Login page transcribed from the approved reference
/// (`image/login.png`): bilingual portal login with mobile OTP entry.
///
/// The OTP boxes are seeded with `4927` to match the reference state; the
/// resend link runs a live countdown from 58 seconds.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  static const int _otpLength = 6;
  static const List<String> _seededOtp = <String>['4', '9', '2', '7', '0', '0'];

  late final List<TextEditingController> _otpControllers;
  late final List<FocusNode> _otpFocusNodes;
  late final TextEditingController _phoneController;
  Timer? _resendTimer;
  int _resendSeconds = 58;
  int _methodIndex = 0;
  bool _rememberMe = true;
  bool _isSubmitting = false;
  late final UserHealthRepository _userHealthRepository = UserHealthRepository();

  @override
  void initState() {
    super.initState();
    _otpControllers = List<TextEditingController>.generate(
      _otpLength,
      (int i) => TextEditingController(text: _seededOtp[i]),
    );
    _otpFocusNodes = List<FocusNode>.generate(_otpLength, (_) => FocusNode());
    _phoneController = TextEditingController(text: '9823456780');
    _startResendCountdown();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (final TextEditingController controller in _otpControllers) {
      controller.dispose();
    }
    for (final FocusNode node in _otpFocusNodes) {
      node.dispose();
    }
    _phoneController.dispose();
    super.dispose();
  }

  void _startResendCountdown() {
    _resendTimer?.cancel();
    _resendSeconds = 58;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_resendSeconds <= 0) {
        timer.cancel();
        return;
      }
      setState(() => _resendSeconds -= 1);
    });
  }

  void _handleOtpChanged(int index, String value) {
    setState(() {});
    if (value.isNotEmpty && index < _otpLength - 1) {
      _otpFocusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.ink,
        ),
      );
  }

  /// The OTP currently typed across the six boxes.
  String get _enteredOtp =>
      _otpControllers.map((TextEditingController c) => c.text).join();

  bool get _isPhoneValid => _phoneController.text.trim().length == 10;

  /// Persists the entered login details to both PostgreSQL & MongoDB,
  /// then navigates to the success screen or home page.
  Future<void> _submitLogin() async {
    FocusScope.of(context).unfocus();
    if (_isSubmitting) return;
    final String mobile = _phoneController.text.trim();
    final AppStrings strings = ref.read(appStringsProvider);
    if (!_isPhoneValid) {
      _showSnack(strings.loginPhoneValidationError);
      return;
    }
    final String otp = _enteredOtp.isEmpty ? '492700' : _enteredOtp;
    if (otp.length < 4) {
      _showSnack(strings.loginOtpValidationError);
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await LocalePersistence.saveRememberMobile(mobile);
      final LoginRecord record = await _userHealthRepository.recordLogin(
        mobileNumber: mobile,
        otpCode: otp,
        loginMethod: _methodIndex == 0 ? 'Phone OTP' : 'ABHA / Health ID',
        role: ref.read(selectedRoleProvider),
        language: ref.read(localeIdProvider),
        rememberMe: _rememberMe,
      );
      if (!mounted) return;
      _showSnack(strings.loginDbSaveNotice.replaceAll('#{count}', record.loginCount.toString()));
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      unawaited(
        context.push('${AppRoutes.loginSuccess}?mobile=${record.mobileNumber}'),
      );
    } on Object catch (error) {
      if (!mounted) return;
      _showSnack(strings.loginDbErrorPrefix + error.toString());
      // Graceful navigation if network delay
      context.go(AppRoutes.home);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  /// 1-Tap quick demo login with dummy user -> straight to Home Page!
  Future<void> _quickDummyLogin() async {
    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);
    try {
      const String dummyMobile = UserHealthRepository.dummyMobile;
      _phoneController.text = dummyMobile;
      await LocalePersistence.saveRememberMobile(dummyMobile);
      await _userHealthRepository.recordLogin(
        mobileNumber: dummyMobile,
        otpCode: '492700',
        loginMethod: 'Phone OTP',
        role: 'patient',
        language: 'mr',
        rememberMe: true,
      );
      if (!mounted) return;
      _showSnack(ref.read(appStringsProvider).loginDummyLoginSuccessMsg);
      await Future<void>.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      context.go(AppRoutes.home);
    } catch (e) {
      if (!mounted) return;
      // If any connection error, fallback straight to home page using dummy data
      await LocalePersistence.saveRememberMobile(UserHealthRepository.dummyMobile);
      if (!mounted) return;
      context.go(AppRoutes.home);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = ref.watch(appStringsProvider);
    final String localeId = ref.watch(localeIdProvider);
    final LanguageOption? langOpt = OnboardingCatalog.languageById(localeId);
    final LanguageOption? engOpt = OnboardingCatalog.languageById('en');
    final String languageLabel = '${langOpt?.nativeName ?? ''} / ${engOpt?.monogram ?? 'EN'}';

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  AppSpacing.backTop,
                  AppSpacing.page,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    LoginTopBar(
                      languageLabel: languageLabel,
                      onBack: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(height: AppSpacing.header),
                    LoginHeader(
                      badgeLabel: strings.loginPortalBadge,
                      title: strings.loginTitle,
                      subtitle: strings.loginSubtitle,
                      description: strings.loginDescription,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    LoginMethodTabs(
                      selectedIndex: _methodIndex,
                      labels: <String>[
                        strings.loginPhoneOtpTab,
                        strings.loginAbhaTab,
                      ],
                      onChanged: (int index) => setState(() => _methodIndex = index),
                    ),
                    const SizedBox(height: AppSpacing.control),
                    if (_methodIndex == 0)
                      // ─── Phone OTP body ────────────────────────────────────
                      ...<Widget>[
                        SelectedRoleCard(
                          roleTitle: strings.loginRoleTitle,
                          rolePill: strings.loginRolePill,
                          stepLine: strings.loginStepLine,
                          selectedLabel: strings.loginSelectedRoleBadge,
                          changeLabel: strings.loginChangeLabel,
                          onChange: () =>
                              _showSnack(strings.loginRoleChangeMsg),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.tile,
                            borderRadius: AppRadii.cardAll,
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: <Widget>[
                              const Icon(Icons.bolt_rounded,
                                  color: AppColors.brand, size: 24),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      strings.loginDummyUserTitle,
                                      style: const TextStyle(
                                        fontFamily: AppTypography.fontFamily,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                    Text(
                                      strings.loginDummyUserDetail,
                                      style: const TextStyle(
                                        fontFamily: AppTypography.fontFamily,
                                        fontSize: 11,
                                        color: AppColors.muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: _isSubmitting ? null : _quickDummyLogin,
                                style: TextButton.styleFrom(
                                  backgroundColor: AppColors.brand,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  strings.loginQuickLogin,
                                  style: const TextStyle(
                                    fontFamily: AppTypography.fontFamily,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        LoginFieldLabel(
                          label: strings.loginMobileNumberLabel,
                          trailingLabel: '',
                        ),
                        const SizedBox(height: 6),
                        PhoneField(controller: _phoneController),
                        const SizedBox(height: 4),
                        Text(
                          strings.loginMobileOtpHint,
                          style: const TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontFamilyFallback: AppTypography.fontFamilyFallback,
                            fontSize: 10.5,
                            color: AppColors.muted,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        LoginFieldLabel(
                          label: strings.loginOtpLabel,
                          trailingLabel: _resendSeconds > 0
                              ? '${strings.loginResendInPrefix}$_resendSeconds${strings.loginResendInSuffix}'
                              : strings.loginResendNow,
                          onTrailingTap:
                              _resendSeconds > 0 ? null : _startResendCountdown,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        OtpBoxes(
                          controllers: _otpControllers,
                          focusNodes: _otpFocusNodes,
                          onChanged: _handleOtpChanged,
                        ),
                        const SizedBox(height: AppSpacing.control),
                        RememberRow(
                          label: strings.loginRememberMe,
                          forgotLabel: strings.loginForgotPassword,
                          value: _rememberMe,
                          onChanged: (bool value) => setState(() => _rememberMe = value),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AshaInfoCard(
                          title: strings.loginAsaTitle,
                          description: strings.loginAsaDesc,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        TrustRow(
                          label: strings.loginTrustRow,
                        ),
                      ]
                    else
                      // ─── ABHA / Health ID card ────────────────────────────
                      AbhaHealthIdCard(mobileNumber: _phoneController.text.trim()),
                  ],
                ),
              ),
            ),
            LoginFooter(
              buttonLabel: _methodIndex == 0
                  ? strings.loginPhoneButton
                  : strings.loginAbhaButton,
              captionPrefix: strings.loginNewUserText,
              captionLink: strings.loginRegisterLink,
              isBusy: _isSubmitting,
              onContinue: _methodIndex == 0 ? _submitLogin : () {},
            ),
          ],
        ),
      ),
    );
  }
}
