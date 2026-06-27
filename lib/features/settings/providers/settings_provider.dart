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

  /// Returns the theme appropriate for the given hour (0–23).
  ///   04:00–06:59  →  Andalusian Garden  (agim i freskët)
  ///   07:00–16:59  →  Parchment          (ditë e pastër)
  ///   17:00–20:59  →  Desert Sands       (perëndim i ngrohtë)
  ///   21:00–03:59  →  Midnight Indigo    (natë e thellë)
  static AppThemeType forHour(int hour) {
    if (hour >= 4 && hour < 7) return AppThemeType.andalusianGarden;
    if (hour >= 7 && hour < 17) return AppThemeType.parchment;
    if (hour >= 17 && hour < 21) return AppThemeType.desertSands;
    return AppThemeType.midnightIndigo;
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
//  AUTO-THEME PROVIDER
// ══════════════════════════════════════════

final autoThemeProvider =
    StateNotifierProvider<AutoThemeNotifier, bool>((ref) {
  return AutoThemeNotifier();
});

class AutoThemeNotifier extends StateNotifier<bool> {
  AutoThemeNotifier() : super(false) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('auto_theme') ?? false;
  }

  Future<void> setAuto(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_theme', value);
  }
}

// Ticks every minute so effectiveThemeProvider rebuilds automatically.
final _autoClockProvider = StreamProvider<int>((ref) async* {
  yield 0;
  yield* Stream.periodic(const Duration(minutes: 1), (i) => i + 1);
});

/// The theme that should actually be applied to the app.
/// When auto-theme is on, it follows the time of day; otherwise the manual pick.
final effectiveThemeProvider = Provider<AppThemeType>((ref) {
  final isAuto = ref.watch(autoThemeProvider);
  if (!isAuto) return ref.watch(themeProvider);
  ref.watch(_autoClockProvider); // rebuild every minute
  return AppThemeType.forHour(DateTime.now().hour);
});

// ══════════════════════════════════════════
//  AVATAR PROVIDER
// ══════════════════════════════════════════

final avatarPathProvider =
    StateNotifierProvider<AvatarPathNotifier, String?>((ref) {
  return AvatarPathNotifier();
});

class AvatarPathNotifier extends StateNotifier<String?> {
  AvatarPathNotifier() : super(null) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('avatar_path');
  }

  Future<void> setPath(String? path) async {
    state = path;
    final prefs = await SharedPreferences.getInstance();
    if (path == null) {
      await prefs.remove('avatar_path');
    } else {
      await prefs.setString('avatar_path', path);
    }
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
