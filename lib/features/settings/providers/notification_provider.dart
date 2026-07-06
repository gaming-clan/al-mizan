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
    } else {
      await NotificationService.cancelAll();
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
    }
  }
}
