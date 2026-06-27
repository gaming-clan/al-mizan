package com.fikhacademy.fikh_academy

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "com.fikhacademy.fikh_academy/widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                if (call.method == "updateWidget") {
                    val awm = AppWidgetManager.getInstance(this)
                    val ids = awm.getAppWidgetIds(
                        ComponentName(this, AlMizanWidget::class.java)
                    )
                    if (ids.isNotEmpty()) {
                        val intent = Intent(AppWidgetManager.ACTION_APPWIDGET_UPDATE)
                        intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
                        sendBroadcast(intent)
                    }
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }
}
