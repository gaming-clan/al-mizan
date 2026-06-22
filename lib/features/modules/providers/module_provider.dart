import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/providers/home_provider.dart';
import '../data/fiqh_data_source.dart';
import '../data/models/fiqh_models.dart';

final moduleProvider =
    FutureProvider.family<FiqhModule, String>((ref, moduleId) async {
  return FiqhDataSource().loadModule(moduleId);
});

final lessonProvider =
    FutureProvider.family<Lesson?, String>((ref, lessonId) async {
  return FiqhDataSource().findLesson(lessonId);
});

class LessonStatus {
  final bool isRead;
  final bool quizPassed;

  const LessonStatus({required this.isRead, required this.quizPassed});

  bool get isComplete => isRead && quizPassed;
}

/// Returns completion status for every lesson in a module.
/// Key = lessonId, Value = LessonStatus.
final lessonProgressProvider =
    FutureProvider.family<Map<String, LessonStatus>, String>(
        (ref, moduleId) async {
  final db = ref.read(databaseProvider);
  final module = await FiqhDataSource().loadModule(moduleId);
  final lessonIds = module.lessons.map((l) => l.id).toList();

  final completed = await db.getCompletedLessonsForModule(moduleId);
  final completedIds = {for (final c in completed) c.lessonId};

  final quizResults = await db.getBestQuizResultsForLessons(lessonIds);

  return {
    for (final lesson in module.lessons)
      lesson.id: LessonStatus(
        isRead: completedIds.contains(lesson.id),
        quizPassed: lesson.quiz.isEmpty || (quizResults[lesson.id] ?? 0) >= 60.0,
      ),
  };
});
