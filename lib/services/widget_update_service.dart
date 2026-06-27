import 'package:home_widget/home_widget.dart';
import '../core/constants/daily_quotes.dart';
import '../core/database/app_database.dart';

class WidgetUpdateService {
  static const _appGroupId = 'com.fikhacademy.fikh_academy';

  static Future<void> update(AppDatabase db) async {
    try {
      await HomeWidget.setAppGroupId(_appGroupId);

      final quote = DailyQuotes.forToday();
      int streak = 0;
      try {
        streak = await db.getCurrentStreak();
      } catch (_) {}

      await HomeWidget.saveWidgetData<String>('widget_quote_text', quote.text);
      await HomeWidget.saveWidgetData<String>('widget_quote_author', quote.author);
      await HomeWidget.saveWidgetData<int>('widget_streak', streak);

      await HomeWidget.updateWidget(
        name: 'AlMizanWidget',
        androidName: 'AlMizanWidget',
      );
    } catch (_) {
      // widget update is best-effort; never crash the app
    }
  }
}
