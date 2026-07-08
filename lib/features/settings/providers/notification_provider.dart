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
  final bool weeklyEnabled;

  const ChallengeNotifSettings({
    required this.dailyEnabled,
    required this.weeklyEnabled,
  });

  ChallengeNotifSettings copyWith({bool? dailyEnabled, bool? weeklyEnabled}) {
    return ChallengeNotifSettings(
      dailyEnabled: dailyEnabled ?? this.dailyEnabled,
      weeklyEnabled: weeklyEnabled ?? this.weeklyEnabled,
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
          weeklyEnabled: true,
        )) {
    _load();
  }

  static String _hm(int h, int m) =>
      '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = ChallengeNotifSettings(
      dailyEnabled:
          prefs.getBool(NotificationService.prefsChallengeEnabledKey) ?? true,
      weeklyEnabled:
          prefs.getBool(NotificationService.prefsWeeklyEnabledKey) ?? true,
    );
  }

  Future<void> setDailyEnabled(bool enabled) async {
    state = state.copyWith(dailyEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(NotificationService.prefsChallengeEnabledKey, enabled);
    if (enabled) {
      await NotificationService.requestPermission();
      await NotificationService.scheduleDailyChallenge();
      await NotificationService.showInstant(
        'Kujtesa e Sfidës Ditore u aktivizua ✅',
        'Do të të kujtojmë çdo ditë në orën '
            '${_hm(NotificationService.challengeHour, NotificationService.challengeMinute)} '
            'për të bërë Sfidën Ditore.',
      );
    } else {
      await NotificationService.cancelDailyChallenge();
    }
  }

  Future<void> setWeeklyEnabled(bool enabled) async {
    state = state.copyWith(weeklyEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(NotificationService.prefsWeeklyEnabledKey, enabled);
    if (enabled) {
      await NotificationService.requestPermission();
      await NotificationService.scheduleWeeklyChallenge();
      await NotificationService.showInstant(
        'Kujtesa e Sfidës Javore u aktivizua ✅',
        'Do të të kujtojmë çdo të premte për të bërë Sfidën Javore.',
      );
    } else {
      await NotificationService.cancelWeeklyChallenge();
    }
  }
}
