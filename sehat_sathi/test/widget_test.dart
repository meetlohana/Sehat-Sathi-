import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sehat_sathi/app.dart';
import 'package:sehat_sathi/core/i18n/i18n.dart';
import 'package:sehat_sathi/features/onboarding/presentation/providers/onboarding_providers.dart';

void main() {
  testWidgets('step 1 boots in Marathi by default', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: SehatSathiApp()));
    await tester.pumpAndSettle();

    expect(find.text('STEP 1 OF 2'), findsOneWidget);
    expect(find.text(marathiStrings.selectLanguageTitle), findsOneWidget);
    expect(find.text('Marathi'), findsOneWidget);
  });

  testWidgets('tapping Hindi flips step 1 copy live', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: SehatSathiApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Hindi'));
    await tester.pumpAndSettle();

    expect(find.text(hindiStrings.selectLanguageTitle), findsOneWidget);
    expect(find.text(hindiStrings.continueButton), findsOneWidget);
    expect(find.text(hindiStrings.footerStep1), findsOneWidget);
  });

  testWidgets('tapping English flips step 1 copy live', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: SehatSathiApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('EN').first);
    await tester.pumpAndSettle();

    expect(find.text(englishStrings.selectLanguageTitle), findsOneWidget);
    expect(find.text(englishStrings.footerStep1), findsOneWidget);
  });

  testWidgets('step 2 role cards follow the selected language', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: SehatSathiApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Hindi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(hindiStrings.continueButton));
    await tester.pumpAndSettle();

    expect(find.text(hindiStrings.selectRoleHeader), findsOneWidget);
    expect(find.text(hindiStrings.roles.first.title), findsOneWidget);
  });

  test('locale selection persists the normalized id', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(localeIdProvider.notifier).select('hi');
    expect(container.read(localeIdProvider), 'hi');
    expect(container.read(appStringsProvider).locale, AppLocale.hindi);
    expect(
      container.read(languageQueryProvider),
      '',
    );
  });
}
