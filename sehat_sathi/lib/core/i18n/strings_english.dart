import 'app_locale.dart';
import 'app_strings.dart';

const AppStrings englishStrings = AppStrings(
  locale: AppLocale.english,
  stepLabel1: 'STEP 1 OF 2',
  selectLanguageTitle: 'Select Language',
  selectLanguageSubtitle: 'भाषा निवडा • भाषा चुनें',
  selectLanguageDescription:
      'Choose your preferred language to access medical records and healthcare services.',
  searchHint: 'Search language (हिंदी, Hindi, English...)',
  continueButton: 'Continue',
  footerStep1: 'You can change your language anytime in account settings.',
  stepLabel2: 'STEP 2 OF 2',
  selectRoleTitle: 'Select Your Role',
  selectRoleSubtitle: 'तुमची भूमिका निवडा • अपनी भूमिका चुनें',
  selectRoleDescription:
      'Choose your access role to personalize your medical records, services, and operational dashboard.',
  selectRoleHeader: 'Step 2 of 2: Select Your Role',
  footerStep2:
      'You can switch or request role verification later in profile settings.',
  roles: <RoleCopy>[
    RoleCopy(
      title: 'PATIENT',
      pill: 'रुग्ण / मरीज',
      description:
          'Access digital prescriptions, doctor appointments, lab results, and personal health records.',
    ),
    RoleCopy(
      title: 'ASHA WORKER',
      pill: 'आशा सेविका',
      description:
          'Field surveys, maternal-child tracking, village health visits, and immunization drives.',
    ),
    RoleCopy(
      title: 'PHC',
      pill: 'प्राथमिक केंद्र',
      description:
          'Primary Health Centre medical officers, daily OPD records, stock supply, and rural reporting.',
    ),
    RoleCopy(
      title: 'DISTRICT\nHOSPITAL',
      pill: 'जिल्हा\nरुग्णालय',
      description:
          'Tertiary care specialists, bed management, emergency triage, and referral coordination.',
    ),
  ],
  doneEyebrow: 'ONBOARDING COMPLETE',
  doneTitle: 'You are all set',
  doneSubtitle: 'सेटअप पूर्ण',
  doneDescription:
      'Your language and role selections were captured successfully.',
  doneButton: 'Get Started',
  doneCaption: 'Onboarding complete — home lands next.',
  languageLabel: 'Language',
  roleLabel: 'Role',
  dashboardTitle: 'Home',
  dashboardContinueMessage: 'Welcome to your Sehat Sathi dashboard.',
  dashboardContinueButton: 'Continue',
  dashboardLogoutLabel: 'Logout',
  dashboardPersonalInfoTitle: 'Personal Information',
  dashboardAccountDetailsTitle: 'Account Details',

  // Login page
  loginPortalBadge: 'आरोग्य सेवा पोर्टल • Health Portal',
  loginTitle: 'लॉगिन करा (Login)',
  loginSubtitle: 'आपल्या खात्यात प्रवेश करा · Access your account',
  loginDescription:
      'Access digital health records, appointments, prescription history, and clinical triage securely.',
  loginPhoneOtpTab: 'मोबाईल OTP (Phone)',
  loginAbhaTab: 'ABHA / Health ID',
  loginMobileNumberLabel: 'मोबाईल क्रमांक (Mobile Number) *',
  loginMobileOtpHint: 'आपल्या नोंदणीकृत मोबाईल वर 6 अंकी OTP पाठवला जाईल.',
  loginOtpLabel: 'एंटर करा OTP (Enter 6-digit OTP)',
  loginResendNow: 'पुन्हा पाठवा (Resend)',
  loginResendInPrefix: 'पुन्हा पाठवा (Resend in ',
  loginResendInSuffix: ' s)',
  loginRememberMe: 'मला लक्षात ठेवा (Remember me)',
  loginForgotPassword: 'पासवर्ड विसरला?',
  loginDummyUserTitle: 'डमी युझर / Dummy User (PostgreSQL + MongoDB)',
  loginDummyUserDetail: 'राम कृष्ण शर्मा • 9823456780',
  loginQuickLogin: '1-टॅप लॉगिन',
  loginAsaTitle: 'ASHA किंवा PHC अधिकारी आहात?',
  loginAsaDesc:
      'आरोग्य कार्यकर्त्यांसाठी विशेष किंमत Health Portal व्यावसायिक ग्राही विक्री संपर्क साधा.',
  loginTrustRow: '256-Bit Encrypted • ABDM HIPAA Standards',
  loginPhoneButton: 'लॉगिन करा (Login to Portal)',
  loginAbhaButton: 'ABHA सह लॉगिन करा (Login with ABHA)',
  loginNewUserText: 'नवीन खाते उघडायचे आहे का? (New user?)',
  loginRegisterLink: 'नोंदणी करा (Register)',
  loginSelectedRoleBadge: 'Selected Role',
  loginChangeLabel: 'बदला',
  loginStepLine: 'Step 1 पूर्ण (Changeable)',
  loginRoleChangeMsg: 'भूमिका बदलण्यासाठी onboarding पूर्ण करा.',
  loginRoleTitle: 'PATIENT',
  loginRolePill: 'रुग्ण',
  loginDbSaveNotice:
      'Saved to Dual Databases, login #{count}',
  loginPhoneValidationError: 'Please enter a valid 10-digit mobile number.',
  loginOtpValidationError: 'Please enter the complete 6-digit OTP.',
  loginDummyLoginSuccessMsg: 'Demo login successful! Navigating to Home Page...',
  loginDbErrorPrefix: 'Database notice: ',

  // ABHA / Health ID card
  abhaNumberLabel: 'ABHA Number किंवा आभा पत्ता (ABHA ID) *',
  abhaNumberHint: 'उदा. 91-XXXX-XXXX-XXXX किंवा user@abdm',
  abhaVerifiedLabel: 'Ayushman Bharat Digital Mission (ABDM) द्वारे सत्यापित',
  abhaPinLabel: 'पासवर्ड / सुरक्षा पिन (Security PIN) *',
  abhaShowLabel: 'Show',
  abhaHideLabel: 'Hide',
  abhaCreateNew: 'नवीन ABHA तयार करा?',
  abhaForgotPin: 'पिन विसरलात?',
  abhaAsaTitle: 'ASHA किंवा PHC अधिकारी आहात?',
  abhaAsaDesc:
      'आपल्या बायोमेट्रिक किंवा शासकीय Health Portal क्रेडेंशियल्स द्वारे लॉगिन करू शकता.',

  // Dashboard
  dashboardHowFeeling: 'How are you feeling today?',
  dashboardNavHome: 'Home',
  dashboardNavCare: 'Care',
  dashboardNavHealth: 'Health',
  dashboardNavSchedule: 'Schedule',
  dashboardNavProfile: 'Profile',
  dashboardTileGetCare: 'GET CARE',
  dashboardTileGetCareSub: 'Wait: < 5 mins',
  dashboardTileMyHealth: 'MY HEALTH',
  dashboardTileMyHealthSub: 'Records & Vitals',
  dashboardTileMyReferral: 'MY REFERRAL',
  dashboardTileMyReferralSub: '1 Specialist Active',
  dashboardTileMedicines: 'MEDICINES',
  dashboardTileMedicinesSub: '2 Daily Refills',
  dashboardTileAppointment: 'APPOINTMENT',
  dashboardTileAppointmentSub: 'Book & Reschedule',
  dashboardTileFindNearby: 'FIND NEARBY',
  dashboardTileFindNearbySub: 'Pharmacies & Clinics',
  dashboardTodayAppointment: "TODAY'S APPOINTMENT",
  dashboardAppointmentTime: '8:30 AM • In 45m',
  dashboardDoctorName: 'Dr. Sarah Jenkins',
  dashboardDoctorDept: 'General Consultation • Room 4B',
  dashboardJoinButton: 'Join',
  dashboardSnackSuffix: ' tapped',
  dashboardJoining: 'Joining appointment...',
  dashboardLogoutAction: 'Logout / लॉगिन बाहेर पडा',
  dashboardSessionNotice: 'Session Notice / सत्र सूचना',
  dashboardLoadError: 'Could not load your dashboard. Please retry.',
  dashboardRetryAction: 'Retry / पुन्हा प्रयत्न करा',
  dashboardBackToLogin: 'Back to Login / लॉगिन पेजवर परत जा',
  dashboardProfileSheetName: 'राम कृष्ण शर्मा',
  dashboardProfileSheetPhone: '9823456780',

  // Login success screen
  loginSuccessStepLabel: 'STEP 3 • LOGIN VERIFIED',
  loginSuccessTitle: 'लॉगिन यशस्वी! (Login Successful)',
  loginSuccessSubtitle: 'तुमचे तपशील सुरक्षित साठवले आहेत · Your details are stored',
  loginSuccessDescription:
      'माहिती "SehatSathi" PostgreSQL व MongoDB डेटाबेसमधून पुनर्प्राप्त केली आहे (Fetched live from Dual Databases).',
  loginSuccessButton: 'मुख्यपृष्ठावर जा (Proceed to Home Page)',
  loginSuccessCaption: 'तपशील PostgreSQL व MongoDB मधून यशस्वीरित्या वाचले (Dual Database Verified)',
  loginSuccessDbInfo:
      'PostgreSQL: 5432 (Users & Auth) • MongoDB: 27017 (Clinical Records)\n'
      'SehatSathi Database · ABDM Compliant',
  loginSuccessRecordTitle: 'PostgreSQL नोंद (Database record)',
  loginSuccessNoRecord:
      'No record found for this mobile number.',
  loginSuccessDbError: 'Database error',
  loginSuccessVerifiedText:
      'डेटाबेसमध्ये नोंद सापडली आणि ती खाली दाखवली आहे (Record verified in PostgreSQL).',
  loginSuccessRetry: 'पुन्हा प्रयत्न करा (Retry)',
  loginSuccessMobileLabel: 'मोबाईल (Mobile)',
  loginSuccessOtpLabel: 'OTP',
  loginSuccessMethodLabel: 'पद्धत (Method)',
  loginSuccessRoleLabel: 'भूमिका (Role)',
  loginSuccessLanguageLabel: 'भाषा (Language)',
  loginSuccessRememberMeLabel: 'मला लक्षात ठेवा (Remember me)',
  loginSuccessLoginCountLabel: 'एकूण लॉगिन (Login count)',
  loginSuccessCreatedLabel: 'खाते तयार (Created)',
  loginSuccessLastLoginLabel: 'शेवटचे लॉगिन (Last login)',
  loginSuccessYes: 'Yes / होय',
  loginSuccessNo: 'No / नाही',

  // Chat bot screen
  chatSymptomFever: 'Fever',
  chatSymptomCough: 'Cough',
  chatSymptomLegPain: 'Leg pain',
  chatSymptomThroatPain: 'Throat pain',
  chatSymptomOthers: 'Others',

  // Health records QR / upload
  dashboardQrCodeLabel: 'Health ID QR Code',
  dashboardUploadButton: 'Upload Health Record',
  dashboardUploadSuccessMsg: 'Health record uploaded successfully!',
  dashboardUpcomingAppointments: 'Upcoming Appointments',
  dashboardPreviousAppointments: 'Previous Appointments',
  dashboardViewAllAppointments: 'View All',
);
