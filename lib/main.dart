import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  await NotificationService.requestPermission();
  // Refresh the rolling 14-day window of daily quote notifications.
  NotificationService.rescheduleFromPrefs();
  runApp(const ProviderScope(child: FikhAcademyApp()));
}
