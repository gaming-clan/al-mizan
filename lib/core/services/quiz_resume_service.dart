import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists in-progress quiz state so the user can resume where they left off.
///
/// Each quiz type has its own key. The payload is an arbitrary JSON map
/// (question index, scores, RNG seed, validity token like today's date, …).
/// The state is cleared when the quiz is finished or restarted from scratch.
class QuizResumeService {
  QuizResumeService._();

  static String moduleKey(String moduleId) => 'quiz_resume_module_$moduleId';
  static const generalKey = 'quiz_resume_general';
  static const timedKey = 'quiz_resume_timed';
  static const dailyKey = 'quiz_resume_daily';
  static const weeklyKey = 'quiz_resume_weekly';

  /// A seed suitable for reproducible question shuffling.
  static int newSeed() =>
      DateTime.now().millisecondsSinceEpoch & 0x7fffffff;

  static Future<void> save(String key, Map<String, dynamic> state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(state));
  }

  static Future<Map<String, dynamic>?> load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
