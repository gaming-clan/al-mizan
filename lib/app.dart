import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/providers/settings_provider.dart';

class FikhAcademyApp extends ConsumerWidget {
  const FikhAcademyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeType = ref.watch(effectiveThemeProvider);
    return MaterialApp.router(
      title: 'Al Mizan - Mëso Fikhun',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.forThemeType(appThemeType),
      routerConfig: appRouter,
    );
  }
}
