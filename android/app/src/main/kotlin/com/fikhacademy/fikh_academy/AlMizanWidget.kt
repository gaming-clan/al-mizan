package com.fikhacademy.fikh_academy

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class AlMizanWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
    }
}

private fun updateWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    val data = HomeWidgetPlugin.getData(context)

    val quoteText = data.getString("widget_quote_text", "Mësoje edebin përpara diturisë.") ?: "Mësoje edebin përpara diturisë."
    val quoteAuthor = data.getString("widget_quote_author", "Imam Maliku") ?: "Imam Maliku"
    val streak = data.getInt("widget_streak", 0)

    val streakLabel = if (streak > 0) "🔥 $streak ditë" else "Fillo sot!"

    val views = RemoteViews(context.packageName, R.layout.al_mizan_widget)
    views.setTextViewText(R.id.widget_quote, quoteText)
    views.setTextViewText(R.id.widget_author, "— $quoteAuthor")
    views.setTextViewText(R.id.widget_streak, streakLabel)

    appWidgetManager.updateAppWidget(appWidgetId, views)
}
