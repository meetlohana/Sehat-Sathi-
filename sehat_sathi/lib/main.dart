import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/i18n/i18n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);
  final String? savedLocaleId = await LocalePersistence.loadLocaleId();
  LocaleBoot.savedId = savedLocaleId;
  runApp(const ProviderScope(child: SehatSathiApp()));
}
