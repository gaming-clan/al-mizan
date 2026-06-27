package com.fikhacademy.fikh_academy

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews

class AlMizanWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (id in appWidgetIds) {
            updateWidget(context, appWidgetManager, id)
        }
    }
}

private fun updateWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    // shared_preferences Flutter package writes to "FlutterSharedPreferences" with "flutter." prefix
    val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

    val quoteText = prefs.getString("flutter.widget_quote_text", "Mësoje edebin përpara diturisë.")
        ?: "Mësoje edebin përpara diturisë."
    val quoteAuthor = prefs.getString("flutter.widget_quote_author", "Imam Maliku")
        ?: "Imam Maliku"
    // shared_preferences stores int as Long on Android
    val streak = prefs.getLong("flutter.widget_streak", 0L).toInt()

    val streakLabel = if (streak > 0) "🔥 $streak ditë" else "Fillo sot!"

    val views = RemoteViews(context.packageName, R.layout.al_mizan_widget)
    views.setTextViewText(R.id.widget_quote, quoteText)
    views.setTextViewText(R.id.widget_author, "— $quoteAuthor")
    views.setTextViewText(R.id.widget_streak, streakLabel)

    appWidgetManager.updateAppWidget(appWidgetId, views)
}
