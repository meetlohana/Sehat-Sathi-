import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/i18n/i18n.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Root widget of the Sehat Sathi application.
///
/// Watches [appLocaleProvider] so tapping a language card re-renders every
/// screen live in the same frame.
class SehatSathiApp extends ConsumerWidget {
  const SehatSathiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Locale locale = ref.watch(appLocaleProvider);
    return MaterialApp.router(
      title: 'Sehat Sathi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: locale,
      supportedLocales: const <Locale>[
        Locale('mr'),
        Locale('hi'),
        Locale('en'),
      ],
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: createAppRouter(),
    );
  }
}