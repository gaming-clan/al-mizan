import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import '../constants/daily_quotes.dart';

/// Daily scholar-quote notification.
///
/// Schedules a rolling window of the next [_daysAhead] notifications
/// (one per day, each with that day's quote). The window is refreshed
/// on every app launch and whenever the user changes the settings.
class NotificationService {
  NotificationService._();

  static const _daysAhead = 14;
  static const _baseId = 100;

  static const prefsEnabledKey = 'daily_notif_enabled';
  static const prefsHourKey = 'daily_notif_hour';
  static const prefsMinuteKey = 'daily_notif_minute';

  static const defaultHour = 8;
  static const defaultMinute = 0;

  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    try {
      final name = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(name));
    } catch (_) {
      // Fall back to the default location (UTC) if lookup fails.
    }
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    _initialized = true;
  }

  /// Asks for the POST_NOTIFICATIONS runtime permission (Android 13+)
  /// and the exact-alarm permission (Android 12+).
  static Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final granted = await android?.requestNotificationsPermission();
    try {
      await android?.requestExactAlarmsPermission();
    } catch (_) {}
    return granted ?? true;
  }

  /// Shows an immediate notification (used to confirm settings changes).
  static Future<void> showInstant(String title, String body) async {
    await init();
    await _plugin.show(
      99,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_quote',
          'Thënia e Ditës',
          channelDescription:
              'Njoftim ditor me thënie të dijetarëve të Islamit',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          styleInformation: BigTextStyleInformation(body),
        ),
      ),
    );
  }

  /// Reads the saved settings and (re)schedules accordingly.
  /// Called on every app launch so the rolling window stays fresh.
  static Future<void> rescheduleFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(prefsEnabledKey) ?? true;
    final hour = prefs.getInt(prefsHourKey) ?? defaultHour;
    final minute = prefs.getInt(prefsMinuteKey) ?? defaultMinute;
    if (enabled) {
      await scheduleDaily(hour: hour, minute: minute);
    } else {
      await cancelAll();
    }
  }

  /// Schedules the next [_daysAhead] daily quote notifications.
  ///
  /// The target instants are computed with Dart's device-local [DateTime]
  /// (whose epoch is always correct for the device clock) and then converted
  /// to [tz.TZDateTime] preserving the same instant — so the schedule is
  /// correct even if the tz-database lookup of the local zone failed.
  static Future<void> scheduleDaily({
    required int hour,
    required int minute,
  }) async {
    await init();
    await cancelAll();

    final now = DateTime.now();
    var first = DateTime(now.year, now.month, now.day, hour, minute);
    if (!first.isAfter(now)) {
      first = first.add(const Duration(days: 1));
    }

    for (int i = 0; i < _daysAhead; i++) {
      final localWhen = first.add(Duration(days: i));
      final when = tz.TZDateTime.from(localWhen, tz.local);
      final quote = DailyQuotes.forDate(localWhen);
      final body = '"${quote.text}" — ${quote.author}';
      final details = NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_quote',
          'Thënia e Ditës',
          channelDescription:
              'Njoftim ditor me thënie të dijetarëve të Islamit',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          styleInformation: BigTextStyleInformation(body),
        ),
      );
      try {
        await _plugin.zonedSchedule(
          _baseId + i,
          'Thënia e Ditës ⚖️',
          body,
          when,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      } catch (_) {
        // Exact alarms not permitted — fall back to inexact.
        try {
          await _plugin.zonedSchedule(
            _baseId + i,
            'Thënia e Ditës ⚖️',
            body,
            when,
            details,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          );
        } catch (_) {}
      }
    }
  }

  static Future<void> cancelAll() async {
    await init();
    await _plugin.cancelAll();
  }
}
