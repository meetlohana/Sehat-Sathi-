/// All spoken/visible strings in one place (Hindi in Roman script + English).
/// Edit freely. Tip: if your device's hi-IN TTS voice reads Roman Hindi badly,
/// replace the 'hi' strings with Devanagari here - nothing else needs to change.
class VoiceTexts {
  static String get(String key, String lang) =>
      _t[key]?[lang] ?? _t[key]?['hi'] ?? '';

  static const Map<String, Map<String, String>> _t = {
    // ---- UI labels ----
    'title': {'hi': 'Sehat Sathi Voice Guide', 'en': 'Sehat Sathi Voice Guide'},
    'tap_to_speak': {'hi': 'Bolne ke liye dabayein', 'en': 'Tap to speak'},
    'listening': {'hi': 'Sun rahi hoon... Bolkar batayein, aapko kya chahiye?', 'en': 'Listening... Tell me what you need.'},
    'processing': {'hi': 'Samajh rahi hoon...', 'en': 'Understanding...'},
    'btn_repeat': {'hi': '🔊 Dobara sunayein', 'en': '🔊 Hear again'},
    'btn_cancel': {'hi': 'Cancel', 'en': 'Cancel'},
    'btn_yes': {'hi': 'Haan, Confirm', 'en': 'Yes, Confirm'},
    'btn_no': {'hi': 'Nahi, Cancel', 'en': 'No, Cancel'},
    'fab_label': {'hi': 'Baat Kariye', 'en': 'Voice Guide'},

    // ---- Greetings / errors ----
    'greeting': {
      'hi': 'Namaste. Main Sehat Sathi Voice Guide hoon. Aap mujhse bolkar app use kar sakte hain.',
      'en': 'Hello. I am the Sehat Sathi Voice Guide. You can use the app by speaking to me.'
    },
    'error_not_understood': {'hi': 'Mujhe samajh nahi aaya. Kripya dobara boliye.', 'en': 'I did not understand. Please say it again.'},
    'error_mic': {'hi': 'Microphone permission required hai. Settings mein microphone permission allow karein.', 'en': 'Microphone permission is required. Please allow it in Settings.'},
    'error_backend': {'hi': 'Abhi service available nahi hai. Kripya thodi der baad try karein.', 'en': 'The service is not available right now. Please try again later.'},
    'error_unrelated': {'hi': 'Main Sehat Sathi app use karne mein aapki help kar sakti hoon. Aap appointment, reports, medicines ya referral ke baare mein pooch sakte hain.', 'en': 'I can help you use the Sehat Sathi app. You can ask about appointments, reports, medicines or referral.'},
    'error_login': {'hi': 'Yeh jankari dekhne ke liye kripya pehle login karein.', 'en': 'Please log in first to see this information.'},
    'offline': {'hi': 'Internet connection available nahi hai. Main basic app guidance mein help kar sakti hoon.', 'en': 'No internet connection. I can still help with basic app guidance.'},
    'offline_data': {'hi': 'Is jankari ke liye internet connection chahiye.', 'en': 'Internet connection is required for this information.'},
    'cancelled': {'hi': 'Theek hai, cancel kar diya.', 'en': 'Okay, cancelled.'},
    'nothing_to_repeat': {'hi': 'Abhi sunane ke liye kuch nahi hai.', 'en': 'There is nothing to repeat yet.'},

    // ---- Navigation responses ----
    'open_home': {'hi': 'Bilkul. Main aapko Home par le ja rahi hoon.', 'en': 'Sure. Taking you to Home.'},
    'open_appointment': {'hi': 'Bilkul. Main aapko appointment ke liye guide karti hoon.', 'en': 'Sure. I will guide you to book an appointment.'},
    'open_appointments': {'hi': 'Bilkul. Main aapki appointments dikha rahi hoon.', 'en': 'Sure. Showing your appointments.'},
    'open_records': {'hi': 'Bilkul. Main aapki health reports khol rahi hoon.', 'en': 'Sure. Opening your health reports.'},
    'open_referral': {'hi': 'Bilkul. Main aapko referral status dikha rahi hoon.', 'en': 'Sure. Showing your referral status.'},
    'open_medicines': {'hi': 'Bilkul. Main aapki medicines dikha rahi hoon.', 'en': 'Sure. Showing your medicines.'},
    'start_consultation': {'hi': 'Bilkul. Main aapko doctor se baat karne ke liye le ja rahi hoon.', 'en': 'Sure. Taking you to talk to a doctor.'},
    'open_emergency': {'hi': 'Main aapko Emergency section par le ja rahi hoon. Kripya wahan diye gaye option dabayein.', 'en': 'Opening the Emergency section. Please use the options shown there.'},
    'go_back': {'hi': 'Theek hai, peeche ja rahi hoon.', 'en': 'Going back.'},
    'guide_app_start': {'hi': 'Koi baat nahi. Main aapko step-by-step guide karungi.', 'en': 'No problem. I will guide you step by step.'},
    'guide_app_followup': {'hi': 'Home screen par aapko Doctor Appointment, Health Records aur Referral ke options milenge. Aap mujhse directly bolkar bhi in sections ko open kar sakte hain.', 'en': 'On the Home screen you will find Doctor Appointment, Health Records and Referral. You can also open them just by speaking to me.'},
    'help_text': {'hi': 'Aap bol sakte hain: Home jao. Appointment leni hai. Meri report dikhao. Referral status. Meri medicines. Doctor se baat karni hai. Emergency. Ya Back jao.', 'en': 'You can say: Go home. Book appointment. Show my reports. Referral status. My medicines. Talk to doctor. Emergency. Or Go back.'},
    'medical_refusal': {'hi': 'Main kisi bimari ki jaanch ya dawai ke baare mein salah nahi de sakti. Main aapko doctor se jodne mein madad kar sakti hoon.', 'en': "I can't diagnose a medical condition or advise on medicines. I can help you connect with a healthcare professional."},
    'serious_symptom': {'hi': 'Yeh gambhir ho sakta hai. Main aapko Emergency section par le ja rahi hoon.', 'en': 'This may be serious. Opening the Emergency section.'},
    'confirm_booking': {'hi': 'Appointment confirm kar doon?', 'en': 'Shall I confirm the appointment?'},

    // ---- Screen explanations ("Yahan kya hai?") ----
    'screen_home': {'hi': 'Yahan se aap appointment book kar sakte hain, health records dekh sakte hain aur referral status check kar sakte hain.', 'en': 'From here you can book an appointment, see health records and check referral status.'},
    'screen_appointment': {'hi': 'Yahan aap doctor ki appointment book kar sakte hain.', 'en': 'Here you can book a doctor appointment.'},
    'screen_appointments': {'hi': 'Yahan aap apni appointments dekh sakte hain.', 'en': 'Here you can see your appointments.'},
    'screen_records': {'hi': 'Yahan aap apni health reports aur medical records dekh sakte hain.', 'en': 'Here you can see your health reports and medical records.'},
    'screen_referral': {'hi': 'Yahan aap apne referral ka status dekh sakte hain.', 'en': 'Here you can see your referral status.'},
    'screen_medicines': {'hi': 'Yahan aap apni medicines ki list dekh sakte hain.', 'en': 'Here you can see your medicine list.'},
    'screen_consultation': {'hi': 'Yahan aap doctor se baat kar sakte hain.', 'en': 'Here you can talk to a doctor.'},
    'screen_emergency': {'hi': 'Yeh Emergency section hai. Kripya screen par diye gaye option dabayein.', 'en': 'This is the Emergency section. Please use the options on screen.'},
    'screen_unknown': {'hi': 'Aap mujhse bolkar app ke kisi bhi section par ja sakte hain.', 'en': 'You can go to any section of the app by speaking to me.'},

    // ---- Appointment guidance steps (ONE at a time) ----
    'step_doctor_selection': {'hi': 'Ab doctor select karein.', 'en': 'Now select a doctor.'},
    'step_date_selection': {'hi': 'Ab available date select karein.', 'en': 'Now select an available date.'},
    'step_time_selection': {'hi': 'Ab available time select karein.', 'en': 'Now select an available time.'},
    'step_confirm': {'hi': 'Appointment confirm karne ke liye Confirm button dabayein.', 'en': 'Press the Confirm button to confirm the appointment.'},
    'step_done': {'hi': 'Appointment successfully book ho gayi hai.', 'en': 'Your appointment has been booked successfully.'},
  };
}
