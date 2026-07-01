import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The last lesson the user opened, used for "Continue where you left off".
class LastLesson {
  final String moduleId;
  final String lessonId;
  final String lessonTitle;
  final String moduleTitle;

  const LastLesson({
    required this.moduleId,
    required this.lessonId,
    required this.lessonTitle,
    required this.moduleTitle,
  });

  Map<String, dynamic> toJson() => {
        'moduleId': moduleId,
        'lessonId': lessonId,
        'lessonTitle': lessonTitle,
        'moduleTitle': moduleTitle,
      };

  factory LastLesson.fromJson(Map<String, dynamic> json) => LastLesson(
        moduleId: json['moduleId'] as String,
        lessonId: json['lessonId'] as String,
        lessonTitle: json['lessonTitle'] as String,
        moduleTitle: json['moduleTitle'] as String,
      );
}

const _kLastLessonKey = 'last_lesson';

final lastLessonProvider =
    StateNotifierProvider<LastLessonNotifier, LastLesson?>((ref) {
  return LastLessonNotifier();
});

class LastLessonNotifier extends StateNotifier<LastLesson?> {
  LastLessonNotifier() : super(null) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kLastLessonKey);
    if (raw == null) return;
    try {
      state = LastLesson.fromJson(
          jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      state = null;
    }
  }

  Future<void> save(LastLesson lesson) async {
    state = lesson;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLastLessonKey, jsonEncode(lesson.toJson()));
  }

  Future<void> clear() async {
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kLastLessonKey);
  }
}
