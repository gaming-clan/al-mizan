import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/providers/settings_provider.dart';
import 'l10n/generated/app_localizations.dart';

class FikhAcademyApp extends ConsumerWidget {
  const FikhAcademyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeType = ref.watch(effectiveThemeProvider);
    final locale = ref.watch(localeProvider);
    return MaterialApp.router(
      title: 'Al Mizan - Mëso Fikhun',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.forThemeType(appThemeType),
      routerConfig: appRouter,
      locale: locale,
      supportedLocales: supportedAppLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
