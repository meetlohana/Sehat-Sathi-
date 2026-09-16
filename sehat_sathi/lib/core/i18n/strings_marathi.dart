import 'app_locale.dart';
import 'app_strings.dart';

const AppStrings marathiStrings = AppStrings(
  locale: AppLocale.marathi,
  stepLabel1: 'STEP 1 OF 2',
  selectLanguageTitle: 'भाषा निवडा',
  selectLanguageSubtitle: 'भाषा निवडा • भाषा चुनें',
  selectLanguageDescription:
      'वैद्यकीय नोंदी आणि आरोग्य सेवा मिळवण्यासाठी तुमची पसंतीची भाषा निवडा.',
  searchHint: 'भाषा शोधा (हिंदी, Hindi, English...)',
  continueButton: 'पुढे जाऊ (Continue)',
  footerStep1: 'तुम्ही खाते सेटिंग्जमध्ये कधीही भाषा बदलू शकता.',
  stepLabel2: 'STEP 2 OF 2',
  selectRoleTitle: 'तुमची भूमिका निवडा',
  selectRoleSubtitle: 'तुमची भूमिका निवडा • अपनी भूमिका चुनें',
  selectRoleDescription:
      'वैद्यकीय नोंदी, सेवा आणि डॅशबोर्ड वैयक्तिकृत करण्यासाठी तुमची भूमिका निवडा.',
  selectRoleHeader: 'Step 2 of 2: तुमची भूमिका निवडा',
  footerStep2:
      'तुम्ही प्रोफाइल सेटिंग्जमध्ये नंतर भूमिका बदलू शकता.',
  roles: <RoleCopy>[
    RoleCopy(
      title: 'PATIENT',
      pill: 'रुग्ण / मरीज',
      description:
          'डिजिटल प्रिस्क्रिप्शन, डॉक्टर अपॉइंटमेंट, लॅब अहवाल आणि वैयक्तिक आरोग्य नोंदी मिळवा.',
    ),
    RoleCopy(
      title: 'ASHA WORKER',
      pill: 'आशा सेविका',
      description:
          'क्षेत्र सर्वेक्षण, माता-बाल ट्रॅकिंग, गाव आरोग्य भेटी आणि टीकाकरण मोहीमा.',
    ),
    RoleCopy(
      title: 'PHC',
      pill: 'प्राथमिक केंद्र',
      description:
          'प्राथमिक आरोग्य केंद्र चे चिकित्सक अधिकारी, दैनंदिन OPD नोंदी, स्टॉक आपूर्ती आणि ग्रामीण अहवाल.',
    ),
    RoleCopy(
      title: 'DISTRICT\nHOSPITAL',
      pill: 'जिल्हा\nरुग्णालय',
      description:
          'तृतीय श्रेणी विशेषज्ञ, बेड व्यवस्थापन, आपत्कालीन ट्रायेज और रेफरल समन्वय.',
    ),
  ],
  doneEyebrow: 'नोंदणी पूर्ण',
  doneTitle: 'तुम्ही तयार आहात',
  doneSubtitle: 'सेटअप पूर्ण',
  doneDescription: 'तुमची भाषा आणि भूमिका यशस्वीरित्या जतन केली आहे.',
  doneButton: 'पूर्ण झाले',
  doneCaption: 'नोंदणी पूर्ण — मुख्यपृष्ठ लवकरच येत आहे.',
  languageLabel: 'भाषा',
  roleLabel: 'भूमिका',
  dashboardTitle: 'मुख्यपृष्ठ',
  dashboardContinueMessage: 'तुमच्या Sehat Sathi डॅशबोर्डवर आपका स्वागत आहे.',
  dashboardContinueButton: 'पुढे जाऊ (Continue)',
  dashboardLogoutLabel: 'लॉग आउट',
  dashboardPersonalInfoTitle: 'वैयक्तिक माहिती',
  dashboardAccountDetailsTitle: 'खाते तप्रीतीकरण',

  // Login page
  loginPortalBadge: 'आरोग्य सेवा पोर्टल • Health Portal',
  loginTitle: 'लॉगिन करा (Login)',
  loginSubtitle: 'आपल्या खात्यात प्रवेश करा · Access your account',
  loginDescription:
      'डिजिटल स्वास्थ्य रेकॉर्ड, अपॉइंटमेंट, प्रिस्क्रिप्शन इतिहास आणि क्लिनिकल ट्रायझ को सुरक्षितपणे एक्सेस करा.',
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
  loginDummyUserDetail: 'Ram Krishan Sharma • 9823456780',
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
      'Dual Database मध्ये साठवले गेले, लॉगिन #{count}',

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
  dashboardNavHome: 'मुख्यपृष्ठ',
  dashboardNavCare: 'देखभाल',
  dashboardNavHealth: 'आरोग्य',
  dashboardNavSchedule: 'शेड्यूल',
  dashboardNavProfile: 'प्रोफ़ाइल',
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
  dashboardSnackSuffix: ' वर क्लिक केले',
  dashboardJoining: 'Joining appointment...',
  dashboardLogoutAction: 'Logout / लॉगिन बाहेर पडा',
  dashboardSessionNotice: 'Session Notice / सत्र सूचना',
  dashboardLoadError: 'Could not load your dashboard. Please retry.',
  dashboardRetryAction: 'Retry / पुन्हा प्रयत्न करा',
  dashboardBackToLogin: 'Back to Login / लॉगिन पेजवर परत जा',
  dashboardProfileSheetName: 'Ram Krishan Sharma',
  dashboardProfileSheetPhone: '9823456780',

  // Login success screen
  loginSuccessStepLabel: 'STEP 3 • LOGIN VERIFIED',
  loginSuccessTitle: 'लॉगिन यशस्वी! (Login Successful)',
  loginSuccessSubtitle: 'तुमचे तपशील सुरक्षित साठवले आहेत · Your details are stored',
  loginSuccessDescription:
      'माहिती "SehatSathi" PostgreSQL व MongoDB डेटाबेसमधून पुनर्प्राप्त केली आहे (Fetched live from Dual Databases).',
  loginSuccessButton: 'मुख्यपृष्ठावर जा (Proceed to Home Page)',
  loginSuccessCaption:
      'तपशील PostgreSQL व MongoDB मधून यशस्वीरित्या वाचले (Dual Database Verified)',
  loginSuccessDbInfo:
      'PostgreSQL: 5432 (Users & Auth) • MongoDB: 27017 (Clinical Records)\n'
      'SehatSathi Database · ABDM Compliant',
  loginSuccessRecordTitle: 'PostgreSQL नोंद (Database record)',
  loginSuccessNoRecord:
      'या मोबाईल क्रमांकासाठी कोणतीही नोंद सापडली नाही (No record found for this mobile number).',
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
  loginSuccessYes: 'होय (Yes)',
  loginSuccessNo: 'नाही (No)',
);
