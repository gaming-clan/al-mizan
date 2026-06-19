import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Al-Mizan Theme — "Digital Manuscript" aesthetic
/// Sophisticated minimalism with subtle tactility.
/// Draws from classical Islamic bookbinding and calligraphy.
class AppTheme {
  AppTheme._();

  // ══════════════════════════════════════════
  //  LIGHT THEME (Parchment)
  // ══════════════════════════════════════════

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          primaryContainer: AppColors.primaryContainer,
          onPrimary: AppColors.onPrimary,
          onPrimaryContainer: AppColors.onPrimaryContainer,
          secondary: AppColors.secondary,
          secondaryContainer: AppColors.secondaryContainer,
          onSecondary: AppColors.onSecondary,
          onSecondaryContainer: AppColors.onSecondaryContainer,
          tertiary: AppColors.tertiary,
          tertiaryContainer: AppColors.tertiaryContainer,
          onTertiary: AppColors.onTertiary,
          onTertiaryContainer: AppColors.onTertiaryContainer,
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
          onSurfaceVariant: AppColors.onSurfaceVariant,
          surfaceContainerLowest: AppColors.surfaceContainerLowest,
          surfaceContainerLow: AppColors.surfaceContainerLow,
          surfaceContainer: AppColors.surfaceContainer,
          surfaceContainerHigh: AppColors.surfaceContainerHigh,
          surfaceContainerHighest: AppColors.surfaceContainerHighest,
          outline: AppColors.outline,
          outlineVariant: AppColors.outlineVariant,
          error: AppColors.error,
          errorContainer: AppColors.errorContainer,
          onError: AppColors.onError,
          onErrorContainer: AppColors.onErrorContainer,
          inverseSurface: AppColors.inverseSurface,
          onInverseSurface: AppColors.inverseOnSurface,
          inversePrimary: AppColors.inversePrimary,
        ),
        scaffoldBackgroundColor: AppColors.surface,
        textTheme: _lightTextTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.primary,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: GoogleFonts.sourceSerif4(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
          iconTheme: const IconThemeData(color: AppColors.primary),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: AppColors.outlineVariant,
              width: 1,
            ),
          ),
          color: AppColors.surfaceContainerLowest,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.surfaceContainerLowest,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.onSurfaceVariant,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.surfaceContainerLowest,
          indicatorColor: AppColors.primaryContainer,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              );
            }
            return GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.onSurfaceVariant,
            );
          }),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryContainer,
            foregroundColor: AppColors.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primaryContainer,
            foregroundColor: AppColors.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.outlineVariant),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceContainerLow,
          selectedColor: AppColors.primaryContainer,
          labelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
          side: const BorderSide(color: AppColors.outlineVariant, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.outlineVariant,
          thickness: 1,
          space: 1,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceContainerLow,
          border: UnderlineInputBorder(
            borderSide: const BorderSide(color: AppColors.outlineVariant),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: AppColors.outlineVariant),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                const BorderSide(color: AppColors.primary, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          hintStyle: GoogleFonts.plusJakartaSans(
            color: AppColors.outline,
            fontSize: 14,
          ),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primaryContainer,
          linearTrackColor: AppColors.surfaceContainerHigh,
          circularTrackColor: AppColors.surfaceContainerHigh,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryContainer,
          foregroundColor: AppColors.onPrimary,
          elevation: 2,
        ),
      );

  // ══════════════════════════════════════════
  //  DARK THEME (Obsidian / Night)
  // ══════════════════════════════════════════

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.darkPrimary,
          primaryContainer: AppColors.darkPrimaryContainer,
          onPrimary: AppColors.darkOnPrimary,
          onPrimaryContainer: AppColors.darkOnPrimaryContainer,
          secondary: AppColors.darkSecondary,
          secondaryContainer: AppColors.darkSecondaryContainer,
          onSecondary: AppColors.darkOnSecondary,
          onSecondaryContainer: AppColors.darkOnSecondaryContainer,
          tertiary: AppColors.darkTertiary,
          tertiaryContainer: AppColors.darkTertiaryContainer,
          onTertiary: AppColors.darkOnTertiary,
          onTertiaryContainer: AppColors.darkOnTertiaryContainer,
          surface: AppColors.darkSurface,
          onSurface: AppColors.darkOnSurface,
          onSurfaceVariant: AppColors.darkOnSurfaceVariant,
          surfaceContainerLowest: AppColors.darkSurfaceContainerLowest,
          surfaceContainerLow: AppColors.darkSurfaceContainerLow,
          surfaceContainer: AppColors.darkSurfaceContainer,
          surfaceContainerHigh: AppColors.darkSurfaceContainerHigh,
          surfaceContainerHighest: AppColors.darkSurfaceContainerHighest,
          outline: AppColors.darkOutline,
          outlineVariant: AppColors.darkOutlineVariant,
          error: AppColors.darkError,
          errorContainer: AppColors.darkErrorContainer,
          onError: AppColors.darkOnError,
          onErrorContainer: AppColors.darkOnErrorContainer,
          inverseSurface: AppColors.darkInverseSurface,
          onInverseSurface: AppColors.darkInverseOnSurface,
          inversePrimary: AppColors.darkInversePrimary,
        ),
        scaffoldBackgroundColor: AppColors.darkSurface,
        textTheme: _darkTextTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.darkSurface,
          foregroundColor: AppColors.darkPrimary,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: GoogleFonts.sourceSerif4(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.darkPrimary,
          ),
          iconTheme: const IconThemeData(color: AppColors.darkPrimary),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: AppColors.darkOutlineVariant,
              width: 1,
            ),
          ),
          color: AppColors.darkSurfaceContainerLow,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkSurfaceContainerLow,
          selectedItemColor: AppColors.darkPrimary,
          unselectedItemColor: AppColors.darkOnSurfaceVariant,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkPrimaryContainer,
            foregroundColor: AppColors.darkOnPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.darkPrimaryContainer,
            foregroundColor: AppColors.darkOnPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.darkPrimary,
            side: const BorderSide(color: AppColors.darkOutlineVariant),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.darkSurfaceContainerHigh,
          selectedColor: AppColors.darkPrimaryContainer,
          labelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
          side: const BorderSide(
              color: AppColors.darkOutlineVariant, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.darkOutlineVariant,
          thickness: 1,
          space: 1,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkSurfaceContainerHigh,
          border: UnderlineInputBorder(
            borderSide:
                const BorderSide(color: AppColors.darkOutlineVariant),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                const BorderSide(color: AppColors.darkOutlineVariant),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                const BorderSide(color: AppColors.darkPrimary, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          hintStyle: GoogleFonts.plusJakartaSans(
            color: AppColors.darkOutline,
            fontSize: 14,
          ),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.darkPrimaryContainer,
          linearTrackColor: AppColors.darkSurfaceContainerHigh,
          circularTrackColor: AppColors.darkSurfaceContainerHigh,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.darkPrimaryContainer,
          foregroundColor: AppColors.darkOnPrimary,
          elevation: 2,
        ),
      );

  // ══════════════════════════════════════════
  //  TEXT THEMES
  // ══════════════════════════════════════════

  static TextTheme get _lightTextTheme => TextTheme(
        displayLarge: GoogleFonts.sourceSerif4(
          fontSize: 48, fontWeight: FontWeight.w700,
          color: AppColors.onSurface, letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.sourceSerif4(
          fontSize: 36, fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
        displaySmall: GoogleFonts.sourceSerif4(
          fontSize: 32, fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
        headlineLarge: GoogleFonts.sourceSerif4(
          fontSize: 28, fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        headlineMedium: GoogleFonts.sourceSerif4(
          fontSize: 24, fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        headlineSmall: GoogleFonts.sourceSerif4(
          fontSize: 22, fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        titleLarge: GoogleFonts.sourceSerif4(
          fontSize: 20, fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: 16, fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        titleSmall: GoogleFonts.plusJakartaSans(
          fontSize: 14, fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 16, fontWeight: FontWeight.w400,
          color: AppColors.onSurface, height: 1.6,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 14, fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceVariant, height: 1.5,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          fontSize: 12, fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceVariant, height: 1.4,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontSize: 14, fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        labelMedium: GoogleFonts.plusJakartaSans(
          fontSize: 12, fontWeight: FontWeight.w600,
          color: AppColors.onSurfaceVariant, letterSpacing: 0.8,
        ),
        labelSmall: GoogleFonts.plusJakartaSans(
          fontSize: 11, fontWeight: FontWeight.w600,
          color: AppColors.onSurfaceVariant, letterSpacing: 1.0,
        ),
      );

  static TextTheme get _darkTextTheme => TextTheme(
        displayLarge: GoogleFonts.sourceSerif4(
          fontSize: 48, fontWeight: FontWeight.w700,
          color: AppColors.darkOnSurface, letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.sourceSerif4(
          fontSize: 36, fontWeight: FontWeight.w700,
          color: AppColors.darkOnSurface,
        ),
        displaySmall: GoogleFonts.sourceSerif4(
          fontSize: 32, fontWeight: FontWeight.w700,
          color: AppColors.darkOnSurface,
        ),
        headlineLarge: GoogleFonts.sourceSerif4(
          fontSize: 28, fontWeight: FontWeight.w600,
          color: AppColors.darkOnSurface,
        ),
        headlineMedium: GoogleFonts.sourceSerif4(
          fontSize: 24, fontWeight: FontWeight.w600,
          color: AppColors.darkOnSurface,
        ),
        headlineSmall: GoogleFonts.sourceSerif4(
          fontSize: 22, fontWeight: FontWeight.w600,
          color: AppColors.darkOnSurface,
        ),
        titleLarge: GoogleFonts.sourceSerif4(
          fontSize: 20, fontWeight: FontWeight.w600,
          color: AppColors.darkOnSurface,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: 16, fontWeight: FontWeight.w600,
          color: AppColors.darkOnSurface,
        ),
        titleSmall: GoogleFonts.plusJakartaSans(
          fontSize: 14, fontWeight: FontWeight.w600,
          color: AppColors.darkOnSurface,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 16, fontWeight: FontWeight.w400,
          color: AppColors.darkOnSurface, height: 1.6,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 14, fontWeight: FontWeight.w400,
          color: AppColors.darkOnSurfaceVariant, height: 1.5,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          fontSize: 12, fontWeight: FontWeight.w400,
          color: AppColors.darkOnSurfaceVariant, height: 1.4,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontSize: 14, fontWeight: FontWeight.w600,
          color: AppColors.darkOnSurface,
        ),
        labelMedium: GoogleFonts.plusJakartaSans(
          fontSize: 12, fontWeight: FontWeight.w600,
          color: AppColors.darkOnSurfaceVariant, letterSpacing: 0.8,
        ),
        labelSmall: GoogleFonts.plusJakartaSans(
          fontSize: 11, fontWeight: FontWeight.w600,
          color: AppColors.darkOnSurfaceVariant, letterSpacing: 1.0,
        ),
      );
}
