import 'package:shared_preferences/shared_preferences.dart';

import 'app_locale.dart';

/// Loads / saves the selected language id. `shared_preferences` is enough
/// here — this is a UI preference, not a secret (auth tokens stay in
/// `flutter_secure_storage`).
abstract final class LocalePersistence {
  static const String key = 'sehat_sathi.locale_id';

  static Future<String?> loadLocaleId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? stored = prefs.getString(key);
    if (stored == null) {
      return null;
    }
    return AppLocale.fromId(stored).id;
  }

  static Future<void> saveLocaleId(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, AppLocale.fromId(id).id);
  }

  /// Key for persisting the "remember me" mobile number.
  static const String rememberMeKey = 'sehat_sathi.remember_mobile';

  /// Loads the last mobile number saved when "Remember me" was checked.
  static Future<String?> loadRememberMobile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(rememberMeKey);
  }

  /// Persists [mobileNumber] so the dashboard can restore the session.
  static Future<void> saveRememberMobile(String mobileNumber) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(rememberMeKey, mobileNumber);
  }
}
