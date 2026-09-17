import 'app_locale.dart';
import 'strings_english.dart';
import 'strings_hindi.dart';
import 'strings_marathi.dart';

/// Localised copy for every screen: onboarding, login, ABHA card and dashboard.
class AppStrings {
  const AppStrings({
    required this.locale,
    required this.stepLabel1,
    required this.selectLanguageTitle,
    required this.selectLanguageSubtitle,
    required this.selectLanguageDescription,
    required this.searchHint,
    required this.continueButton,
    required this.footerStep1,
    required this.stepLabel2,
    required this.selectRoleTitle,
    required this.selectRoleSubtitle,
    required this.selectRoleDescription,
    required this.selectRoleHeader,
    required this.footerStep2,
    required this.roles,
    required this.doneEyebrow,
    required this.doneTitle,
    required this.doneSubtitle,
    required this.doneDescription,
    required this.doneButton,
    required this.doneCaption,
    required this.languageLabel,
    required this.roleLabel,
    required this.dashboardTitle,
    required this.dashboardContinueMessage,
    required this.dashboardContinueButton,
    required this.dashboardLogoutLabel,
    required this.dashboardPersonalInfoTitle,
    required this.dashboardAccountDetailsTitle,

    // Login page
    required this.loginPortalBadge,
    required this.loginTitle,
    required this.loginSubtitle,
    required this.loginDescription,
    required this.loginPhoneOtpTab,
    required this.loginAbhaTab,
    required this.loginMobileNumberLabel,
    required this.loginMobileOtpHint,
    required this.loginOtpLabel,
    required this.loginResendNow,
    required this.loginResendInPrefix,
    required this.loginResendInSuffix,
    required this.loginRememberMe,
    required this.loginForgotPassword,
    required this.loginDummyUserTitle,
    required this.loginDummyUserDetail,
    required this.loginQuickLogin,
    required this.loginAsaTitle,
    required this.loginAsaDesc,
    required this.loginTrustRow,
    required this.loginPhoneButton,
    required this.loginAbhaButton,
    required this.loginNewUserText,
    required this.loginRegisterLink,
    required this.loginSelectedRoleBadge,
    required this.loginChangeLabel,
    required this.loginStepLine,
    required this.loginRoleChangeMsg,
    required this.loginRoleTitle,
    required this.loginRolePill,
    required this.loginDbSaveNotice,
    required this.loginPhoneValidationError,
    required this.loginOtpValidationError,
    required this.loginDummyLoginSuccessMsg,
    required this.loginDbErrorPrefix,

    // ABHA / Health ID card
    required this.abhaNumberLabel,
    required this.abhaNumberHint,
    required this.abhaVerifiedLabel,
    required this.abhaPinLabel,
    required this.abhaShowLabel,
    required this.abhaHideLabel,
    required this.abhaCreateNew,
    required this.abhaForgotPin,
    required this.abhaAsaTitle,
    required this.abhaAsaDesc,

    // Dashboard
    required this.dashboardHowFeeling,
    required this.dashboardNavHome,
    required this.dashboardNavCare,
    required this.dashboardNavHealth,
    required this.dashboardNavSchedule,
    required this.dashboardNavProfile,
    required this.dashboardTileGetCare,
    required this.dashboardTileGetCareSub,
    required this.dashboardTileMyHealth,
    required this.dashboardTileMyHealthSub,
    required this.dashboardTileMyReferral,
    required this.dashboardTileMyReferralSub,
    required this.dashboardTileMedicines,
    required this.dashboardTileMedicinesSub,
    required this.dashboardTileAppointment,
    required this.dashboardTileAppointmentSub,
    required this.dashboardTileFindNearby,
    required this.dashboardTileFindNearbySub,
    required this.dashboardTodayAppointment,
    required this.dashboardAppointmentTime,
    required this.dashboardDoctorName,
    required this.dashboardDoctorDept,
    required this.dashboardJoinButton,
    required this.dashboardSnackSuffix,
    required this.dashboardJoining,
    required this.dashboardLogoutAction,
    required this.dashboardSessionNotice,
    required this.dashboardLoadError,
    required this.dashboardRetryAction,
    required this.dashboardBackToLogin,
    required this.dashboardProfileSheetName,
    required this.dashboardProfileSheetPhone,

    // Login success screen
    required this.loginSuccessStepLabel,
    required this.loginSuccessTitle,
    required this.loginSuccessSubtitle,
    required this.loginSuccessDescription,
    required this.loginSuccessButton,
    required this.loginSuccessCaption,
    required this.loginSuccessDbInfo,
    required this.loginSuccessRecordTitle,
    required this.loginSuccessNoRecord,
    required this.loginSuccessDbError,
    required this.loginSuccessVerifiedText,
    required this.loginSuccessRetry,
    required this.loginSuccessMobileLabel,
    required this.loginSuccessOtpLabel,
    required this.loginSuccessMethodLabel,
    required this.loginSuccessRoleLabel,
    required this.loginSuccessLanguageLabel,
    required this.loginSuccessRememberMeLabel,
    required this.loginSuccessLoginCountLabel,
    required this.loginSuccessCreatedLabel,
    required this.loginSuccessLastLoginLabel,
    required this.loginSuccessYes,
    required this.loginSuccessNo,

    // Chat bot screen
    required this.chatSymptomFever,
    required this.chatSymptomCough,
    required this.chatSymptomLegPain,
    required this.chatSymptomThroatPain,
    required this.chatSymptomOthers,

    // Health records QR / upload
    required this.dashboardQrCodeLabel,
    required this.dashboardUploadButton,
    required this.dashboardUploadSuccessMsg,
    required this.dashboardUpcomingAppointments,
    required this.dashboardPreviousAppointments,
    required this.dashboardViewAllAppointments,
  });

  final AppLocale locale;
  final String stepLabel1;
  final String selectLanguageTitle;
  final String selectLanguageSubtitle;
  final String selectLanguageDescription;
  final String searchHint;
  final String continueButton;
  final String footerStep1;
  final String stepLabel2;
  final String selectRoleTitle;
  final String selectRoleSubtitle;
  final String selectRoleDescription;
  final String selectRoleHeader;
  final String footerStep2;
  final List<RoleCopy> roles;
  final String doneEyebrow;
  final String doneTitle;
  final String doneSubtitle;
  final String doneDescription;
  final String doneButton;
  final String doneCaption;
  final String languageLabel;
  final String roleLabel;
  final String dashboardTitle;
  final String dashboardContinueMessage;
  final String dashboardContinueButton;
  final String dashboardLogoutLabel;
  final String dashboardPersonalInfoTitle;
  final String dashboardAccountDetailsTitle;

  // Login page
  final String loginPortalBadge;
  final String loginTitle;
  final String loginSubtitle;
  final String loginDescription;
  final String loginPhoneOtpTab;
  final String loginAbhaTab;
  final String loginMobileNumberLabel;
  final String loginMobileOtpHint;
  final String loginOtpLabel;
  final String loginResendNow;
  final String loginResendInPrefix;
  final String loginResendInSuffix;
  final String loginRememberMe;
  final String loginForgotPassword;
  final String loginDummyUserTitle;
  final String loginDummyUserDetail;
  final String loginQuickLogin;
  final String loginAsaTitle;
  final String loginAsaDesc;
  final String loginTrustRow;
  final String loginPhoneButton;
  final String loginAbhaButton;
  final String loginNewUserText;
  final String loginRegisterLink;
  final String loginSelectedRoleBadge;
  final String loginChangeLabel;
  final String loginStepLine;
  final String loginRoleChangeMsg;
  final String loginRoleTitle;
  final String loginRolePill;
  final String loginDbSaveNotice;
  final String loginPhoneValidationError;
  final String loginOtpValidationError;
  final String loginDummyLoginSuccessMsg;
  final String loginDbErrorPrefix;

  // ABHA / Health ID card
  final String abhaNumberLabel;
  final String abhaNumberHint;
  final String abhaVerifiedLabel;
  final String abhaPinLabel;
  final String abhaShowLabel;
  final String abhaHideLabel;
  final String abhaCreateNew;
  final String abhaForgotPin;
  final String abhaAsaTitle;
  final String abhaAsaDesc;

  // Dashboard
  final String dashboardHowFeeling;
  final String dashboardNavHome;
  final String dashboardNavCare;
  final String dashboardNavHealth;
  final String dashboardNavSchedule;
  final String dashboardNavProfile;
  final String dashboardTileGetCare;
  final String dashboardTileGetCareSub;
  final String dashboardTileMyHealth;
  final String dashboardTileMyHealthSub;
  final String dashboardTileMyReferral;
  final String dashboardTileMyReferralSub;
  final String dashboardTileMedicines;
  final String dashboardTileMedicinesSub;
  final String dashboardTileAppointment;
  final String dashboardTileAppointmentSub;
  final String dashboardTileFindNearby;
  final String dashboardTileFindNearbySub;
  final String dashboardTodayAppointment;
  final String dashboardAppointmentTime;
  final String dashboardDoctorName;
  final String dashboardDoctorDept;
  final String dashboardJoinButton;
  final String dashboardSnackSuffix;
  final String dashboardJoining;
  final String dashboardLogoutAction;
  final String dashboardSessionNotice;
  final String dashboardLoadError;
  final String dashboardRetryAction;
  final String dashboardBackToLogin;
  final String dashboardProfileSheetName;
  final String dashboardProfileSheetPhone;

  // Login success screen
  final String loginSuccessStepLabel;
  final String loginSuccessTitle;
  final String loginSuccessSubtitle;
  final String loginSuccessDescription;
  final String loginSuccessButton;
  final String loginSuccessCaption;
  final String loginSuccessDbInfo;
  final String loginSuccessRecordTitle;
  final String loginSuccessNoRecord;
  final String loginSuccessDbError;
  final String loginSuccessVerifiedText;
  final String loginSuccessRetry;
  final String loginSuccessMobileLabel;
  final String loginSuccessOtpLabel;
  final String loginSuccessMethodLabel;
  final String loginSuccessRoleLabel;
  final String loginSuccessLanguageLabel;
  final String loginSuccessRememberMeLabel;
  final String loginSuccessLoginCountLabel;
  final String loginSuccessCreatedLabel;
  final String loginSuccessLastLoginLabel;
  final String loginSuccessYes;
  final String loginSuccessNo;

  // Chat bot screen
  final String chatSymptomFever;
  final String chatSymptomCough;
  final String chatSymptomLegPain;
  final String chatSymptomThroatPain;
  final String chatSymptomOthers;

  // Health records QR / upload
  final String dashboardQrCodeLabel;
  final String dashboardUploadButton;
  final String dashboardUploadSuccessMsg;
  final String dashboardUpcomingAppointments;
  final String dashboardPreviousAppointments;
  final String dashboardViewAllAppointments;

  static AppStrings ofId(String? id) {
    switch (AppLocale.fromId(id)) {
      case AppLocale.hindi:
        return hindiStrings;
      case AppLocale.english:
        return englishStrings;
      case AppLocale.marathi:
        return marathiStrings;
    }
  }
}
