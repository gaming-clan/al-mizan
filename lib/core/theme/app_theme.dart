import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import '../../features/settings/providers/settings_provider.dart';

class AppTheme {
  AppTheme._();

  static ThemeData forThemeType(AppThemeType type) {
    switch (type) {
      case AppThemeType.parchment:
        return light;
      case AppThemeType.night:
        return dark;
      case AppThemeType.desertSands:
        return desertSands;
      case AppThemeType.azureMosaic:
        return azureMosaic;
      case AppThemeType.andalusianGarden:
        return andalusianGarden;
      case AppThemeType.midnightIndigo:
        return midnightIndigo;
      case AppThemeType.ebonyGold:
        return ebonyGold;
    }
  }

  // ══════════════════════════════════════════
  //  LIGHT (Parchment)
  // ══════════════════════════════════════════

  static ThemeData get light => _build(const ColorScheme.light(
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
      ));

  // ══════════════════════════════════════════
  //  DARK (Night / Obsidian)
  // ══════════════════════════════════════════

  static ThemeData get dark => _build(const ColorScheme.dark(
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
      ));

  // ══════════════════════════════════════════
  //  DESERT SANDS
  // ══════════════════════════════════════════

  static ThemeData get desertSands => _build(const ColorScheme.light(
        primary: AppColors.desertPrimary,
        primaryContainer: AppColors.desertPrimaryContainer,
        onPrimary: AppColors.desertOnPrimary,
        onPrimaryContainer: AppColors.desertOnPrimaryContainer,
        secondary: AppColors.desertSecondary,
        secondaryContainer: AppColors.desertSecondaryContainer,
        onSecondary: AppColors.desertOnSecondary,
        onSecondaryContainer: AppColors.desertOnSecondaryContainer,
        tertiary: AppColors.desertTertiary,
        tertiaryContainer: AppColors.desertTertiaryContainer,
        onTertiary: AppColors.desertOnTertiary,
        onTertiaryContainer: AppColors.desertOnTertiaryContainer,
        surface: AppColors.desertSurface,
        onSurface: AppColors.desertOnSurface,
        onSurfaceVariant: AppColors.desertOnSurfaceVariant,
        surfaceContainerLowest: AppColors.desertSurfaceContainerLowest,
        surfaceContainerLow: AppColors.desertSurfaceContainerLow,
        surfaceContainer: AppColors.desertSurfaceContainer,
        surfaceContainerHigh: AppColors.desertSurfaceContainerHigh,
        surfaceContainerHighest: AppColors.desertSurfaceContainerHighest,
        outline: AppColors.desertOutline,
        outlineVariant: AppColors.desertOutlineVariant,
        error: AppColors.error,
        errorContainer: AppColors.errorContainer,
        onError: AppColors.onError,
        onErrorContainer: AppColors.onErrorContainer,
        inverseSurface: AppColors.desertInverseSurface,
        onInverseSurface: AppColors.desertInverseOnSurface,
        inversePrimary: AppColors.desertInversePrimary,
      ));

  // ══════════════════════════════════════════
  //  AZURE MOSAIC
  // ══════════════════════════════════════════

  static ThemeData get azureMosaic => _build(const ColorScheme.light(
        primary: AppColors.azurePrimary,
        primaryContainer: AppColors.azurePrimaryContainer,
        onPrimary: AppColors.azureOnPrimary,
        onPrimaryContainer: AppColors.azureOnPrimaryContainer,
        secondary: AppColors.azureSecondary,
        secondaryContainer: AppColors.azureSecondaryContainer,
        onSecondary: AppColors.azureOnSecondary,
        onSecondaryContainer: AppColors.azureOnSecondaryContainer,
        tertiary: AppColors.azureTertiary,
        tertiaryContainer: AppColors.azureTertiaryContainer,
        onTertiary: AppColors.azureOnTertiary,
        onTertiaryContainer: AppColors.azureOnTertiaryContainer,
        surface: AppColors.azureSurface,
        onSurface: AppColors.azureOnSurface,
        onSurfaceVariant: AppColors.azureOnSurfaceVariant,
        surfaceContainerLowest: AppColors.azureSurfaceContainerLowest,
        surfaceContainerLow: AppColors.azureSurfaceContainerLow,
        surfaceContainer: AppColors.azureSurfaceContainer,
        surfaceContainerHigh: AppColors.azureSurfaceContainerHigh,
        surfaceContainerHighest: AppColors.azureSurfaceContainerHighest,
        outline: AppColors.azureOutline,
        outlineVariant: AppColors.azureOutlineVariant,
        error: AppColors.error,
        errorContainer: AppColors.errorContainer,
        onError: AppColors.onError,
        onErrorContainer: AppColors.onErrorContainer,
        inverseSurface: AppColors.azureInverseSurface,
        onInverseSurface: AppColors.azureInverseOnSurface,
        inversePrimary: AppColors.azureInversePrimary,
      ));

  // ══════════════════════════════════════════
  //  ANDALUSIAN GARDEN
  // ══════════════════════════════════════════

  static ThemeData get andalusianGarden => _build(const ColorScheme.light(
        primary: AppColors.gardenPrimary,
        primaryContainer: AppColors.gardenPrimaryContainer,
        onPrimary: AppColors.gardenOnPrimary,
        onPrimaryContainer: AppColors.gardenOnPrimaryContainer,
        secondary: AppColors.gardenSecondary,
        secondaryContainer: AppColors.gardenSecondaryContainer,
        onSecondary: AppColors.gardenOnSecondary,
        onSecondaryContainer: AppColors.gardenOnSecondaryContainer,
        tertiary: AppColors.gardenTertiary,
        tertiaryContainer: AppColors.gardenTertiaryContainer,
        onTertiary: AppColors.gardenOnTertiary,
        onTertiaryContainer: AppColors.gardenOnTertiaryContainer,
        surface: AppColors.gardenSurface,
        onSurface: AppColors.gardenOnSurface,
        onSurfaceVariant: AppColors.gardenOnSurfaceVariant,
        surfaceContainerLowest: AppColors.gardenSurfaceContainerLowest,
        surfaceContainerLow: AppColors.gardenSurfaceContainerLow,
        surfaceContainer: AppColors.gardenSurfaceContainer,
        surfaceContainerHigh: AppColors.gardenSurfaceContainerHigh,
        surfaceContainerHighest: AppColors.gardenSurfaceContainerHighest,
        outline: AppColors.gardenOutline,
        outlineVariant: AppColors.gardenOutlineVariant,
        error: AppColors.error,
        errorContainer: AppColors.errorContainer,
        onError: AppColors.onError,
        onErrorContainer: AppColors.onErrorContainer,
        inverseSurface: AppColors.gardenInverseSurface,
        onInverseSurface: AppColors.gardenInverseOnSurface,
        inversePrimary: AppColors.gardenInversePrimary,
      ));

  // ══════════════════════════════════════════
  //  MIDNIGHT INDIGO
  // ══════════════════════════════════════════

  static ThemeData get midnightIndigo => _build(const ColorScheme.dark(
        primary: AppColors.indigoPrimary,
        primaryContainer: AppColors.indigoPrimaryContainer,
        onPrimary: AppColors.indigoOnPrimary,
        onPrimaryContainer: AppColors.indigoOnPrimaryContainer,
        secondary: AppColors.indigoSecondary,
        secondaryContainer: AppColors.indigoSecondaryContainer,
        onSecondary: AppColors.indigoOnSecondary,
        onSecondaryContainer: AppColors.indigoOnSecondaryContainer,
        tertiary: AppColors.indigoTertiary,
        tertiaryContainer: AppColors.indigoTertiaryContainer,
        onTertiary: AppColors.indigoOnTertiary,
        onTertiaryContainer: AppColors.indigoOnTertiaryContainer,
        surface: AppColors.indigoSurface,
        onSurface: AppColors.indigoOnSurface,
        onSurfaceVariant: AppColors.indigoOnSurfaceVariant,
        surfaceContainerLowest: AppColors.indigoSurfaceContainerLowest,
        surfaceContainerLow: AppColors.indigoSurfaceContainerLow,
        surfaceContainer: AppColors.indigoSurfaceContainer,
        surfaceContainerHigh: AppColors.indigoSurfaceContainerHigh,
        surfaceContainerHighest: AppColors.indigoSurfaceContainerHighest,
        outline: AppColors.indigoOutline,
        outlineVariant: AppColors.indigoOutlineVariant,
        error: AppColors.indigoError,
        errorContainer: AppColors.indigoErrorContainer,
        onError: AppColors.indigoOnError,
        onErrorContainer: AppColors.indigoOnErrorContainer,
        inverseSurface: AppColors.indigoInverseSurface,
        onInverseSurface: AppColors.indigoInverseOnSurface,
        inversePrimary: AppColors.indigoInversePrimary,
      ));

  // ══════════════════════════════════════════
  //  EBONY GOLD
  // ══════════════════════════════════════════

  static ThemeData get ebonyGold => _build(const ColorScheme.dark(
        primary: AppColors.ebonyPrimary,
        primaryContainer: AppColors.ebonyPrimaryContainer,
        onPrimary: AppColors.ebonyOnPrimary,
        onPrimaryContainer: AppColors.ebonyOnPrimaryContainer,
        secondary: AppColors.ebonySecondary,
        secondaryContainer: AppColors.ebonySecondaryContainer,
        onSecondary: AppColors.ebonyOnSecondary,
        onSecondaryContainer: AppColors.ebonyOnSecondaryContainer,
        tertiary: AppColors.ebonyTertiary,
        tertiaryContainer: AppColors.ebonyTertiaryContainer,
        onTertiary: AppColors.ebonyOnTertiary,
        onTertiaryContainer: AppColors.ebonyOnTertiaryContainer,
        surface: AppColors.ebonySurface,
        onSurface: AppColors.ebonyOnSurface,
        onSurfaceVariant: AppColors.ebonyOnSurfaceVariant,
        surfaceContainerLowest: AppColors.ebonySurfaceContainerLowest,
        surfaceContainerLow: AppColors.ebonySurfaceContainerLow,
        surfaceContainer: AppColors.ebonySurfaceContainer,
        surfaceContainerHigh: AppColors.ebonySurfaceContainerHigh,
        surfaceContainerHighest: AppColors.ebonySurfaceContainerHighest,
        outline: AppColors.ebonyOutline,
        outlineVariant: AppColors.ebonyOutlineVariant,
        error: AppColors.ebonyError,
        errorContainer: AppColors.ebonyErrorContainer,
        onError: AppColors.ebonyOnError,
        onErrorContainer: AppColors.ebonyOnErrorContainer,
        inverseSurface: AppColors.ebonyInverseSurface,
        onInverseSurface: AppColors.ebonyInverseOnSurface,
        inversePrimary: AppColors.ebonyInversePrimary,
      ));

  // ══════════════════════════════════════════
  //  SHARED BUILDER
  // ══════════════════════════════════════════

  static ThemeData _build(ColorScheme cs) {
    final textColor = cs.onSurface;
    final subColor = cs.onSurfaceVariant;

    return ThemeData(
      useMaterial3: true,
      brightness: cs.brightness,
      colorScheme: cs,
      scaffoldBackgroundColor: cs.surface,
      textTheme: _textTheme(textColor, subColor),
      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        foregroundColor: cs.primary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.sourceSerif4(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: cs.primary,
        ),
        iconTheme: IconThemeData(color: cs.primary),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: cs.outlineVariant),
        ),
        color: cs.surfaceContainerLowest,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cs.surfaceContainerLowest,
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurfaceVariant,
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
        backgroundColor: cs.surfaceContainerLowest,
        indicatorColor: cs.primaryContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: cs.primary,
            );
          }
          return GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: cs.onSurfaceVariant,
          );
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primaryContainer,
          foregroundColor: cs.onPrimary,
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
          backgroundColor: cs.primaryContainer,
          foregroundColor: cs.onPrimary,
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
          foregroundColor: cs.primary,
          side: BorderSide(color: cs.outlineVariant),
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
        backgroundColor: cs.surfaceContainerLow,
        selectedColor: cs.primaryContainer,
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
        side: BorderSide(color: cs.outlineVariant, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      dividerTheme: DividerThemeData(
        color: cs.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cs.surfaceContainerLow,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: cs.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: cs.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: cs.primary, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: GoogleFonts.plusJakartaSans(
          color: cs.outline,
          fontSize: 14,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: cs.primaryContainer,
        linearTrackColor: cs.surfaceContainerHigh,
        circularTrackColor: cs.surfaceContainerHigh,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: cs.primaryContainer,
        foregroundColor: cs.onPrimary,
        elevation: 2,
      ),
    );
  }

  // ══════════════════════════════════════════
  //  TEXT THEME
  // ══════════════════════════════════════════

  static TextTheme _textTheme(Color textColor, Color subColor) => TextTheme(
        displayLarge: GoogleFonts.sourceSerif4(
          fontSize: 48, fontWeight: FontWeight.w700,
          color: textColor, letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.sourceSerif4(
          fontSize: 36, fontWeight: FontWeight.w700, color: textColor,
        ),
        displaySmall: GoogleFonts.sourceSerif4(
          fontSize: 32, fontWeight: FontWeight.w700, color: textColor,
        ),
        headlineLarge: GoogleFonts.sourceSerif4(
          fontSize: 28, fontWeight: FontWeight.w600, color: textColor,
        ),
        headlineMedium: GoogleFonts.sourceSerif4(
          fontSize: 24, fontWeight: FontWeight.w600, color: textColor,
        ),
        headlineSmall: GoogleFonts.sourceSerif4(
          fontSize: 22, fontWeight: FontWeight.w600, color: textColor,
        ),
        titleLarge: GoogleFonts.sourceSerif4(
          fontSize: 20, fontWeight: FontWeight.w600, color: textColor,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: 16, fontWeight: FontWeight.w600, color: textColor,
        ),
        titleSmall: GoogleFonts.plusJakartaSans(
          fontSize: 14, fontWeight: FontWeight.w600, color: textColor,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 16, fontWeight: FontWeight.w400, color: textColor, height: 1.6,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 14, fontWeight: FontWeight.w400, color: subColor, height: 1.5,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          fontSize: 12, fontWeight: FontWeight.w400, color: subColor, height: 1.4,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontSize: 14, fontWeight: FontWeight.w600, color: textColor,
        ),
        labelMedium: GoogleFonts.plusJakartaSans(
          fontSize: 12, fontWeight: FontWeight.w600, color: subColor, letterSpacing: 0.8,
        ),
        labelSmall: GoogleFonts.plusJakartaSans(
          fontSize: 11, fontWeight: FontWeight.w600, color: subColor, letterSpacing: 1.0,
        ),
      );
}
