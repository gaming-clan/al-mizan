import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ══════════════════════════════════════════
//  THEME TYPE
// ══════════════════════════════════════════

enum AppThemeType {
  parchment,
  night,
  desertSands,
  azureMosaic,
  andalusianGarden,
  midnightIndigo,
  ebonyGold;

  bool get isDark =>
      this == night || this == midnightIndigo || this == ebonyGold;

  String get displayName {
    switch (this) {
      case AppThemeType.parchment:
        return 'Parchment';
      case AppThemeType.night:
        return 'Night';
      case AppThemeType.desertSands:
        return 'Desert Sands';
      case AppThemeType.azureMosaic:
        return 'Azure Mosaic';
      case AppThemeType.andalusianGarden:
        return 'Andalusian Garden';
      case AppThemeType.midnightIndigo:
        return 'Midnight Indigo';
      case AppThemeType.ebonyGold:
        return 'Ebony Gold';
    }
  }

  Color get swatchPrimary {
    switch (this) {
      case AppThemeType.parchment:
        return const Color(0xFF003527);
      case AppThemeType.night:
        return const Color(0xFF4EDEA3);
      case AppThemeType.desertSands:
        return const Color(0xFF94451D);
      case AppThemeType.azureMosaic:
        return const Color(0xFF091426);
      case AppThemeType.andalusianGarden:
        return const Color(0xFF8F4953);
      case AppThemeType.midnightIndigo:
        return const Color(0xFF57F1DB);
      case AppThemeType.ebonyGold:
        return const Color(0xFFF2CA50);
    }
  }

  Color get swatchSurface {
    switch (this) {
      case AppThemeType.parchment:
        return const Color(0xFFFBF9F5);
      case AppThemeType.night:
        return const Color(0xFF131313);
      case AppThemeType.desertSands:
        return const Color(0xFFFFF8F0);
      case AppThemeType.azureMosaic:
        return const Color(0xFFF7F9FB);
      case AppThemeType.andalusianGarden:
        return const Color(0xFFF8FAF6);
      case AppThemeType.midnightIndigo:
        return const Color(0xFF0B1326);
      case AppThemeType.ebonyGold:
        return const Color(0xFF131313);
    }
  }
}

// ══════════════════════════════════════════
//  THEME PROVIDER
// ══════════════════════════════════════════

final themeProvider =
    StateNotifierProvider<ThemeNotifier, AppThemeType>((ref) {
  return ThemeNotifier();
});

// Backward-compat derived provider (read-only)
final darkModeProvider = Provider<bool>((ref) => ref.watch(themeProvider).isDark);

class ThemeNotifier extends StateNotifier<AppThemeType> {
  ThemeNotifier() : super(AppThemeType.parchment) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString('app_theme');
    if (themeName != null) {
      state = AppThemeType.values.firstWhere(
        (t) => t.name == themeName,
        orElse: () => AppThemeType.parchment,
      );
      return;
    }
    // Backward compat: old dark_mode flag
    if (prefs.getBool('dark_mode') == true) {
      state = AppThemeType.night;
    }
  }

  Future<void> setTheme(AppThemeType theme) async {
    state = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_theme', theme.name);
  }
}

// ══════════════════════════════════════════
//  USER NAME PROVIDER
// ══════════════════════════════════════════

final userNameProvider =
    StateNotifierProvider<UserNameNotifier, String>((ref) {
  return UserNameNotifier();
});

class UserNameNotifier extends StateNotifier<String> {
  UserNameNotifier() : super('') {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('user_name') ?? '';
  }

  Future<void> setName(String name) async {
    state = name.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', state);
  }
}
