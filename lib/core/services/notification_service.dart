import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import '../constants/daily_quotes.dart';

/// Local notifications: the daily scholar quote, a daily-challenge reminder
/// and a weekly-challenge reminder.
///
/// Each type schedules a rolling window of future instances (refreshed on
/// every app launch and whenever the user changes a setting), and each uses
/// its own notification-id range so the types never cancel one another.
class NotificationService {
  NotificationService._();

  // ── Daily scholar quote ──
  static const _quoteBaseId = 100; // 100..113
  static const _quoteDaysAhead = 14;
  static const prefsEnabledKey = 'daily_notif_enabled';
  static const prefsHourKey = 'daily_notif_hour';
  static const prefsMinuteKey = 'daily_notif_minute';
  static const defaultHour = 8;
  static const defaultMinute = 0;

  // ── Daily-challenge reminder ──
  static const _challengeBaseId = 200; // 200..213
  static const _challengeDaysAhead = 14;
  static const prefsChallengeEnabledKey = 'daily_challenge_notif_enabled';
  static const challengeHour = 18;
  static const challengeMinute = 0;

  // ── Weekly-challenge reminder ──
  static const _weeklyBaseId = 300; // 300..307
  static const _weeklyWeeksAhead = 8;
  static const prefsWeeklyEnabledKey = 'weekly_challenge_notif_enabled';
  static const weeklyWeekday = DateTime.friday; // 5
  static const weeklyHour = 10;
  static const weeklyMinute = 0;

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
      _details(
        'daily_quote',
        'Thënia e Ditës',
        'Njoftim ditor me thënie të dijetarëve të Islamit',
        body,
      ),
    );
  }

  /// (Re)schedules every notification type according to the saved settings.
  /// Called on every app launch so the rolling windows stay fresh.
  static Future<void> rescheduleFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(prefsEnabledKey) ?? true) {
      await scheduleDaily(
        hour: prefs.getInt(prefsHourKey) ?? defaultHour,
        minute: prefs.getInt(prefsMinuteKey) ?? defaultMinute,
      );
    } else {
      await cancelDaily();
    }

    if (prefs.getBool(prefsChallengeEnabledKey) ?? true) {
      await scheduleDailyChallenge();
    } else {
      await cancelDailyChallenge();
    }

    if (prefs.getBool(prefsWeeklyEnabledKey) ?? true) {
      await scheduleWeeklyChallenge();
    } else {
      await cancelWeeklyChallenge();
    }
  }

  // ── Daily quote ──

  /// Schedules the next [_quoteDaysAhead] daily quote notifications.
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
    await cancelDaily();

    final now = DateTime.now();
    var first = DateTime(now.year, now.month, now.day, hour, minute);
    if (!first.isAfter(now)) first = first.add(const Duration(days: 1));

    for (int i = 0; i < _quoteDaysAhead; i++) {
      final localWhen = first.add(Duration(days: i));
      final quote = DailyQuotes.forDate(localWhen);
      final body = '"${quote.text}" — ${quote.author}';
      await _scheduleOne(
        _quoteBaseId + i,
        'Thënia e Ditës ⚖️',
        body,
        tz.TZDateTime.from(localWhen, tz.local),
        _details('daily_quote', 'Thënia e Ditës',
            'Njoftim ditor me thënie të dijetarëve të Islamit', body),
      );
    }
  }

  static Future<void> cancelDaily() =>
      _cancelRange(_quoteBaseId, _quoteDaysAhead);

  // ── Daily-challenge reminder ──

  /// Schedules a daily reminder to do the Daily Challenge.
  static Future<void> scheduleDailyChallenge() async {
    await init();
    await cancelDailyChallenge();

    final now = DateTime.now();
    var first =
        DateTime(now.year, now.month, now.day, challengeHour, challengeMinute);
    if (!first.isAfter(now)) first = first.add(const Duration(days: 1));

    const body =
        'Sfida Ditore të pret! Provo njohuritë e tua me pyetjet e sotme dhe mbaje serinë. 🎯';
    for (int i = 0; i < _challengeDaysAhead; i++) {
      final localWhen = first.add(Duration(days: i));
      await _scheduleOne(
        _challengeBaseId + i,
        'Sfida Ditore 🎯',
        body,
        tz.TZDateTime.from(localWhen, tz.local),
        _details('daily_challenge', 'Sfida Ditore',
            'Kujtesë ditore për të bërë Sfidën Ditore', body),
      );
    }
  }

  static Future<void> cancelDailyChallenge() =>
      _cancelRange(_challengeBaseId, _challengeDaysAhead);

  // ── Weekly-challenge reminder ──

  /// Schedules a weekly reminder (every [weeklyWeekday]) to do the Weekly
  /// Challenge.
  static Future<void> scheduleWeeklyChallenge() async {
    await init();
    await cancelWeeklyChallenge();

    final now = DateTime.now();
    var first = DateTime(now.year, now.month, now.day, weeklyHour, weeklyMinute);
    final daysUntil = (weeklyWeekday - first.weekday) % 7; // 0..6, always >= 0
    first = first.add(Duration(days: daysUntil));
    if (!first.isAfter(now)) first = first.add(const Duration(days: 7));

    const body =
        'Sfida Javore është gati! Tri pjesë me kohë të presin këtë javë. 🏆';
    for (int i = 0; i < _weeklyWeeksAhead; i++) {
      final localWhen = first.add(Duration(days: 7 * i));
      await _scheduleOne(
        _weeklyBaseId + i,
        'Sfida Javore 🏆',
        body,
        tz.TZDateTime.from(localWhen, tz.local),
        _details('weekly_challenge', 'Sfida Javore',
            'Kujtesë javore për të bërë Sfidën Javore', body),
      );
    }
  }

  static Future<void> cancelWeeklyChallenge() =>
      _cancelRange(_weeklyBaseId, _weeklyWeeksAhead);

  // ── Helpers ──

  static NotificationDetails _details(
    String channelId,
    String channelName,
    String channelDesc,
    String body,
  ) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDesc,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        styleInformation: BigTextStyleInformation(body),
      ),
    );
  }

  static Future<void> _scheduleOne(
    int id,
    String title,
    String body,
    tz.TZDateTime when,
    NotificationDetails details,
  ) async {
    try {
      await _plugin.zonedSchedule(id, title, body, when, details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
    } catch (_) {
      // Exact alarms not permitted — fall back to inexact.
      try {
        await _plugin.zonedSchedule(id, title, body, when, details,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle);
      } catch (_) {}
    }
  }

  static Future<void> _cancelRange(int base, int count) async {
    await init();
    for (int i = 0; i < count; i++) {
      await _plugin.cancel(base + i);
    }
  }

  static Future<void> cancelAll() async {
    await init();
    await _plugin.cancelAll();
  }
}
