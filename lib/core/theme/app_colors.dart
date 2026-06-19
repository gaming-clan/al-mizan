import 'package:flutter/material.dart';

/// Al-Mizan Design System Colors
/// Inspired by classical Islamic bookbinding and calligraphy.
/// "Digital Manuscript" aesthetic — scholarly, reverent, timeless.
class AppColors {
  AppColors._();

  // ══════════════════════════════════════════
  //  AL-MIZAN LIGHT (Parchment)
  // ══════════════════════════════════════════

  // Primary — Deep Emerald (Islamic tradition)
  static const primary = Color(0xFF003527);
  static const primaryContainer = Color(0xFF064E3B);
  static const onPrimary = Color(0xFFFFFFFF);
  static const onPrimaryContainer = Color(0xFF80BEA6);

  // Secondary — Burnished Gold (illumination accent)
  static const secondary = Color(0xFF9B4500);
  static const secondaryContainer = Color(0xFFFD8A42);
  static const onSecondary = Color(0xFFFFFFFF);
  static const onSecondaryContainer = Color(0xFF682C00);

  // Tertiary — Warm amber
  static const tertiary = Color(0xFF4A2400);
  static const tertiaryContainer = Color(0xFF6A3700);
  static const onTertiary = Color(0xFFFFFFFF);
  static const onTertiaryContainer = Color(0xFFFF9939);

  // Surface — Warm parchment
  static const surface = Color(0xFFFBF9F5);
  static const surfaceDim = Color(0xFFDBDAD6);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF5F3EF);
  static const surfaceContainer = Color(0xFFEFEEEA);
  static const surfaceContainerHigh = Color(0xFFEAE8E4);
  static const surfaceContainerHighest = Color(0xFFE4E2DE);
  static const onSurface = Color(0xFF1B1C1A);
  static const onSurfaceVariant = Color(0xFF404944);

  // Outline
  static const outline = Color(0xFF707974);
  static const outlineVariant = Color(0xFFBFC9C3);

  // Error
  static const error = Color(0xFFBA1A1A);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onError = Color(0xFFFFFFFF);
  static const onErrorContainer = Color(0xFF93000A);

  // Inverse
  static const inverseSurface = Color(0xFF30312E);
  static const inverseOnSurface = Color(0xFFF2F0ED);
  static const inversePrimary = Color(0xFF95D3BA);

  // Fixed
  static const primaryFixed = Color(0xFFB0F0D6);
  static const primaryFixedDim = Color(0xFF95D3BA);
  static const secondaryFixed = Color(0xFFFFDBCA);
  static const secondaryFixedDim = Color(0xFFFFB68E);

  // ══════════════════════════════════════════
  //  AL-MIZAN NIGHT (Obsidian)
  // ══════════════════════════════════════════

  static const darkPrimary = Color(0xFF4EDEA3);
  static const darkOnPrimary = Color(0xFF003824);
  static const darkPrimaryContainer = Color(0xFF10B981);
  static const darkOnPrimaryContainer = Color(0xFF00422B);

  static const darkSecondary = Color(0xFFE9C349);
  static const darkOnSecondary = Color(0xFF3C2F00);
  static const darkSecondaryContainer = Color(0xFFAF8D11);
  static const darkOnSecondaryContainer = Color(0xFF342800);

  static const darkTertiary = Color(0xFFC9C7BA);
  static const darkOnTertiary = Color(0xFF313128);
  static const darkTertiaryContainer = Color(0xFFA5A397);
  static const darkOnTertiaryContainer = Color(0xFF3A3A30);

  static const darkSurface = Color(0xFF131313);
  static const darkSurfaceDim = Color(0xFF131313);
  static const darkSurfaceContainerLowest = Color(0xFF0E0E0E);
  static const darkSurfaceContainerLow = Color(0xFF1C1B1B);
  static const darkSurfaceContainer = Color(0xFF201F1F);
  static const darkSurfaceContainerHigh = Color(0xFF2A2A2A);
  static const darkSurfaceContainerHighest = Color(0xFF353534);
  static const darkOnSurface = Color(0xFFE5E2E1);
  static const darkOnSurfaceVariant = Color(0xFFBBCABF);

  static const darkOutline = Color(0xFF86948A);
  static const darkOutlineVariant = Color(0xFF3C4A42);

  static const darkError = Color(0xFFFFB4AB);
  static const darkErrorContainer = Color(0xFF93000A);
  static const darkOnError = Color(0xFF690005);
  static const darkOnErrorContainer = Color(0xFFFFDAD6);

  static const darkInverseSurface = Color(0xFFE5E2E1);
  static const darkInverseOnSurface = Color(0xFF313030);
  static const darkInversePrimary = Color(0xFF006C49);

  // ══════════════════════════════════════════
  //  SPECIAL CARD BACKGROUNDS
  // ══════════════════════════════════════════

  // Quran evidence card
  static const quranCardBg = Color(0xFFEDF5F0);
  static const quranCardBgDark = Color(0xFF1A2E22);

  // Hadith evidence card
  static const hadithCardBg = Color(0xFFFFF8E1);
  static const hadithCardBgDark = Color(0xFF2E2A1A);

  // ══════════════════════════════════════════
  //  MADHAB SCHOOL COLORS
  // ══════════════════════════════════════════

  static const hanafiColor = Color(0xFF2E7D32);
  static const malikiColor = Color(0xFF1565C0);
  static const shafiiColor = Color(0xFF6A1B9A);
  static const hanbaliColor = Color(0xFFE65100);
  static const consensusColor = Color(0xFF00838F);

  // ══════════════════════════════════════════
  //  SEMANTIC
  // ══════════════════════════════════════════

  static const success = Color(0xFF2E7D32);
  static const warning = Color(0xFFE65100);
  static const info = Color(0xFF1565C0);

  // ══════════════════════════════════════════
  //  BACKWARD COMPAT ALIASES
  // ══════════════════════════════════════════

  static const accent = secondary;
  static const primaryDark = primaryContainer;
  static const accentLight = secondaryFixed;
  static const textSecondary = onSurfaceVariant;

  static Color madhabColor(String madhab) {
    switch (madhab.toLowerCase()) {
      case 'hanafi':
        return hanafiColor;
      case 'maliki':
        return malikiColor;
      case 'shafii':
      case "shafi'i":
        return shafiiColor;
      case 'hanbali':
        return hanbaliColor;
      default:
        return primary;
    }
  }
}
