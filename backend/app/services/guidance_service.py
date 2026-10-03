"""Static guidance text (hi/en) + step-by-step flows. Cached, no AI needed."""
from functools import lru_cache

# Keep in sync with Flutter voice_texts.dart (only what the backend returns).
TEXTS: dict[str, dict[str, str]] = {
    "open_home": {"hi": "Bilkul. Main aapko Home par le ja rahi hoon.", "en": "Sure. Taking you to Home."},
    "open_appointment": {"hi": "Bilkul. Main aapko appointment ke liye guide karti hoon.", "en": "Sure. I will guide you to book an appointment."},
    "open_appointments": {"hi": "Bilkul. Main aapki appointments dikha rahi hoon.", "en": "Sure. Showing your appointments."},
    "open_records": {"hi": "Bilkul. Main aapki health reports khol rahi hoon.", "en": "Sure. Opening your health reports."},
    "open_referral": {"hi": "Bilkul. Main aapko referral status dikha rahi hoon.", "en": "Sure. Showing your referral status."},
    "open_medicines": {"hi": "Bilkul. Main aapki medicines dikha rahi hoon.", "en": "Sure. Showing your medicines."},
    "start_consultation": {"hi": "Bilkul. Main aapko doctor se baat karne ke liye le ja rahi hoon.", "en": "Sure. Taking you to talk to a doctor."},
    "open_emergency": {"hi": "Main aapko Emergency section par le ja rahi hoon. Kripya wahan diye gaye option dabayein.", "en": "Opening the Emergency section. Please use the options shown there."},
    "serious_symptom": {"hi": "Yeh gambhir ho sakta hai. Main aapko Emergency section par le ja rahi hoon.", "en": "This may be serious. Opening the Emergency section."},
    "go_back": {"hi": "Theek hai, peeche ja rahi hoon.", "en": "Going back."},
    "guide_app_start": {"hi": "Koi baat nahi. Main aapko step-by-step guide karungi.", "en": "No problem. I will guide you step by step."},
    "help_text": {"hi": "Aap bol sakte hain: Home jao. Appointment leni hai. Meri report dikhao. Referral status. Meri medicines. Doctor se baat karni hai. Emergency. Ya Back jao.", "en": "You can say: Go home. Book appointment. Show my reports. Referral status. My medicines. Talk to doctor. Emergency. Or Go back."},
    "medical_refusal": {"hi": "Main kisi bimari ki jaanch ya dawai ke baare mein salah nahi de sakti. Main aapko doctor se jodne mein madad kar sakti hoon.", "en": "I can't diagnose a medical condition or advise on medicines. I can help you connect with a healthcare professional."},
    "error_unrelated": {"hi": "Main Sehat Sathi app use karne mein aapki help kar sakti hoon. Aap appointment, reports, medicines ya referral ke baare mein pooch sakte hain.", "en": "I can help you use the Sehat Sathi app. You can ask about appointments, reports, medicines or referral."},
    # Handled on-device from the current screen; backend just echoes a short line.
    "client_side": {"hi": "Theek hai.", "en": "Okay."},
    # Patient-data templates (facts inserted by the BACKEND, never by an AI model)
    "appt_next": {"hi": "Aapki next appointment {date} ko hai.", "en": "Your next appointment is on {date}."},
    "appt_none": {"hi": "Aapki koi upcoming appointment nahi hai.", "en": "You have no upcoming appointments."},
    "meds_count": {"hi": "Aapki list mein {n} medicines hain. Main list dikha rahi hoon.", "en": "You have {n} medicines on your list. Showing the list."},
    "meds_none": {"hi": "Aapki list mein abhi koi medicine nahi hai.", "en": "You have no medicines on your list right now."},
    "referral_status": {"hi": "Aapka referral status: {status}.", "en": "Your referral status: {status}."},
    "referral_none": {"hi": "Aapka koi referral nahi mila.", "en": "No referral was found."},
}

REFERRAL_STATUS_WORDS = {
    "pending": {"hi": "Pending", "en": "Pending"},
    "accepted": {"hi": "Accept ho gaya hai", "en": "Accepted"},
    "completed": {"hi": "Poora ho gaya hai", "en": "Completed"},
}

SCREEN_EXPLANATIONS: dict[str, dict[str, str]] = {
    "home": {"hi": "Yahan se aap appointment book kar sakte hain, health records dekh sakte hain aur referral status check kar sakte hain.", "en": "From here you can book an appointment, see health records and check referral status."},
    "appointment": {"hi": "Yahan aap doctor ki appointment book kar sakte hain.", "en": "Here you can book a doctor appointment."},
    "appointments": {"hi": "Yahan aap apni appointments dekh sakte hain.", "en": "Here you can see your appointments."},
    "records": {"hi": "Yahan aap apni health reports aur medical records dekh sakte hain.", "en": "Here you can see your health reports and medical records."},
    "referral": {"hi": "Yahan aap apne referral ka status dekh sakte hain.", "en": "Here you can see your referral status."},
    "medicines": {"hi": "Yahan aap apni medicines ki list dekh sakte hain.", "en": "Here you can see your medicine list."},
    "consultation": {"hi": "Yahan aap doctor se baat kar sakte hain.", "en": "Here you can talk to a doctor."},
    "emergency": {"hi": "Yeh Emergency section hai. Kripya screen par diye gaye option dabayein.", "en": "This is the Emergency section. Please use the options on screen."},
}

FLOWS: dict[str, dict[str, dict[str, str]]] = {
    "appointment": {
        "doctor_selection": {"hi": "Ab doctor select karein.", "en": "Now select a doctor."},
        "date_selection": {"hi": "Ab available date select karein.", "en": "Now select an available date."},
        "time_selection": {"hi": "Ab available time select karein.", "en": "Now select an available time."},
        "confirm": {"hi": "Appointment confirm karne ke liye Confirm button dabayein.", "en": "Press the Confirm button to confirm the appointment."},
        "done": {"hi": "Appointment successfully book ho gayi hai.", "en": "Your appointment has been booked successfully."},
    }
}


def text(key: str, lang: str, **fmt: str) -> str:
    return TEXTS[key][lang].format(**fmt)


@lru_cache(maxsize=256)
def explain_screen(screen: str, lang: str) -> str:
    item = SCREEN_EXPLANATIONS.get(screen) or SCREEN_EXPLANATIONS["home"]
    return item[lang]


@lru_cache(maxsize=64)
def steps_for(screen: str, lang: str) -> tuple[str, ...]:
    flow = FLOWS.get(screen, {})
    return tuple(s[lang] for s in flow.values())
