/// Locale ids and per-role copy shared by all localised tables.
enum AppLocale {
  marathi('mr'),
  hindi('hi'),
  english('en');

  const AppLocale(this.id);
  final String id;

  static AppLocale fromId(String? id) {
    switch (id) {
      case 'hi':
        return AppLocale.hindi;
      case 'en':
        return AppLocale.english;
      case 'mr':
      default:
        return AppLocale.marathi;
    }
  }
}

/// Per-role display copy for one locale.
class RoleCopy {
  const RoleCopy({
    required this.title,
    required this.pill,
    required this.description,
  });
  final String title;
  final String pill;
  final String description;
}
