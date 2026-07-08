import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/notification_service.dart';

class DailyNotifSettings {
  final bool enabled;
  final int hour;
  final int minute;

  const DailyNotifSettings({
    required this.enabled,
    required this.hour,
    required this.minute,
  });

  TimeOfDay get time => TimeOfDay(hour: hour, minute: minute);

  String get timeLabel =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  DailyNotifSettings copyWith({bool? enabled, int? hour, int? minute}) {
    return DailyNotifSettings(
      enabled: enabled ?? this.enabled,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }
}

final dailyNotifProvider =
    StateNotifierProvider<DailyNotifNotifier, DailyNotifSettings>((ref) {
  return DailyNotifNotifier();
});

class DailyNotifNotifier extends StateNotifier<DailyNotifSettings> {
  DailyNotifNotifier()
      : super(const DailyNotifSettings(
          enabled: true,
          hour: NotificationService.defaultHour,
          minute: NotificationService.defaultMinute,
        )) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = DailyNotifSettings(
      enabled: prefs.getBool(NotificationService.prefsEnabledKey) ?? true,
      hour: prefs.getInt(NotificationService.prefsHourKey) ??
          NotificationService.defaultHour,
      minute: prefs.getInt(NotificationService.prefsMinuteKey) ??
          NotificationService.defaultMinute,
    );
  }

  Future<void> setEnabled(bool enabled) async {
    state = state.copyWith(enabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(NotificationService.prefsEnabledKey, enabled);
    if (enabled) {
      await NotificationService.requestPermission();
      await NotificationService.scheduleDaily(
          hour: state.hour, minute: state.minute);
      await NotificationService.showInstant(
        'Njoftimi ditor u aktivizua ✅',
        'Do të marrësh një thënie dijetarësh çdo ditë në orën ${state.timeLabel}.',
      );
    } else {
      await NotificationService.cancelDaily();
    }
  }

  Future<void> setTime(TimeOfDay time) async {
    state = state.copyWith(hour: time.hour, minute: time.minute);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(NotificationService.prefsHourKey, time.hour);
    await prefs.setInt(NotificationService.prefsMinuteKey, time.minute);
    if (state.enabled) {
      await NotificationService.scheduleDaily(
          hour: time.hour, minute: time.minute);
      await NotificationService.showInstant(
        'Ora u ndryshua ✅',
        'Njoftimi ditor tani vjen çdo ditë në orën ${state.timeLabel}.',
      );
    }
  }
}

// ── Challenge reminders (daily + weekly) ──

class ChallengeNotifSettings {
  final bool dailyEnabled;
  final int dailyHour;
  final int dailyMinute;
  final bool weeklyEnabled;
  final int weeklyHour;
  final int weeklyMinute;

  const ChallengeNotifSettings({
    required this.dailyEnabled,
    required this.dailyHour,
    required this.dailyMinute,
    required this.weeklyEnabled,
    required this.weeklyHour,
    required this.weeklyMinute,
  });

  TimeOfDay get dailyTime => TimeOfDay(hour: dailyHour, minute: dailyMinute);
  TimeOfDay get weeklyTime => TimeOfDay(hour: weeklyHour, minute: weeklyMinute);

  String get dailyLabel => _fmt(dailyHour, dailyMinute);
  String get weeklyLabel => _fmt(weeklyHour, weeklyMinute);

  static String _fmt(int h, int m) =>
      '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';

  ChallengeNotifSettings copyWith({
    bool? dailyEnabled,
    int? dailyHour,
    int? dailyMinute,
    bool? weeklyEnabled,
    int? weeklyHour,
    int? weeklyMinute,
  }) {
    return ChallengeNotifSettings(
      dailyEnabled: dailyEnabled ?? this.dailyEnabled,
      dailyHour: dailyHour ?? this.dailyHour,
      dailyMinute: dailyMinute ?? this.dailyMinute,
      weeklyEnabled: weeklyEnabled ?? this.weeklyEnabled,
      weeklyHour: weeklyHour ?? this.weeklyHour,
      weeklyMinute: weeklyMinute ?? this.weeklyMinute,
    );
  }
}

final challengeNotifProvider =
    StateNotifierProvider<ChallengeNotifNotifier, ChallengeNotifSettings>((ref) {
  return ChallengeNotifNotifier();
});

class ChallengeNotifNotifier extends StateNotifier<ChallengeNotifSettings> {
  ChallengeNotifNotifier()
      : super(const ChallengeNotifSettings(
          dailyEnabled: true,
          dailyHour: NotificationService.defaultChallengeHour,
          dailyMinute: NotificationService.defaultChallengeMinute,
          weeklyEnabled: true,
          weeklyHour: NotificationService.defaultWeeklyHour,
          weeklyMinute: NotificationService.defaultWeeklyMinute,
        )) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = ChallengeNotifSettings(
      dailyEnabled:
          prefs.getBool(NotificationService.prefsChallengeEnabledKey) ?? true,
      dailyHour: prefs.getInt(NotificationService.prefsChallengeHourKey) ??
          NotificationService.defaultChallengeHour,
      dailyMinute: prefs.getInt(NotificationService.prefsChallengeMinuteKey) ??
          NotificationService.defaultChallengeMinute,
      weeklyEnabled:
          prefs.getBool(NotificationService.prefsWeeklyEnabledKey) ?? true,
      weeklyHour: prefs.getInt(NotificationService.prefsWeeklyHourKey) ??
          NotificationService.defaultWeeklyHour,
      weeklyMinute: prefs.getInt(NotificationService.prefsWeeklyMinuteKey) ??
          NotificationService.defaultWeeklyMinute,
    );
  }

  Future<void> setDailyEnabled(bool enabled) async {
    state = state.copyWith(dailyEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(NotificationService.prefsChallengeEnabledKey, enabled);
    if (enabled) {
      await NotificationService.requestPermission();
      await NotificationService.scheduleDailyChallenge(
          hour: state.dailyHour, minute: state.dailyMinute);
      await NotificationService.showInstant(
        'Kujtesa e Sfidës Ditore u aktivizua ✅',
        'Do të të kujtojmë çdo ditë në orën ${state.dailyLabel} për të bërë Sfidën Ditore.',
      );
    } else {
      await NotificationService.cancelDailyChallenge();
    }
  }

  Future<void> setDailyTime(TimeOfDay time) async {
    state = state.copyWith(dailyHour: time.hour, dailyMinute: time.minute);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(NotificationService.prefsChallengeHourKey, time.hour);
    await prefs.setInt(
        NotificationService.prefsChallengeMinuteKey, time.minute);
    if (state.dailyEnabled) {
      await NotificationService.scheduleDailyChallenge(
          hour: time.hour, minute: time.minute);
      await NotificationService.showInstant(
        'Ora u ndryshua ✅',
        'Kujtesa e Sfidës Ditore tani vjen çdo ditë në orën ${state.dailyLabel}.',
      );
    }
  }

  Future<void> setWeeklyEnabled(bool enabled) async {
    state = state.copyWith(weeklyEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(NotificationService.prefsWeeklyEnabledKey, enabled);
    if (enabled) {
      await NotificationService.requestPermission();
      await NotificationService.scheduleWeeklyChallenge(
          hour: state.weeklyHour, minute: state.weeklyMinute);
      await NotificationService.showInstant(
        'Kujtesa e Sfidës Javore u aktivizua ✅',
        'Do të të kujtojmë çdo të premte në orën ${state.weeklyLabel} për të bërë Sfidën Javore.',
      );
    } else {
      await NotificationService.cancelWeeklyChallenge();
    }
  }

  Future<void> setWeeklyTime(TimeOfDay time) async {
    state = state.copyWith(weeklyHour: time.hour, weeklyMinute: time.minute);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(NotificationService.prefsWeeklyHourKey, time.hour);
    await prefs.setInt(NotificationService.prefsWeeklyMinuteKey, time.minute);
    if (state.weeklyEnabled) {
      await NotificationService.scheduleWeeklyChallenge(
          hour: time.hour, minute: time.minute);
      await NotificationService.showInstant(
        'Ora u ndryshua ✅',
        'Kujtesa e Sfidës Javore tani vjen çdo të premte në orën ${state.weeklyLabel}.',
      );
    }
  }
}
