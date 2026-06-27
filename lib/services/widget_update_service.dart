import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/daily_quotes.dart';
import '../core/database/app_database.dart';

class WidgetUpdateService {
  static const _channel = MethodChannel('com.fikhacademy.fikh_academy/widget');

  static Future<void> update(AppDatabase db) async {
    try {
      final quote = DailyQuotes.forToday();
      int streak = 0;
      try {
        streak = await db.getCurrentStreak();
      } catch (_) {}

      // shared_preferences stores data in FlutterSharedPreferences with "flutter." prefix
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('widget_quote_text', quote.text);
      await prefs.setString('widget_quote_author', quote.author);
      await prefs.setInt('widget_streak', streak);

      // Trigger native widget refresh via MethodChannel
      await _channel.invokeMethod('updateWidget');
    } catch (_) {
      // best-effort — never crash the app
    }
  }
}
