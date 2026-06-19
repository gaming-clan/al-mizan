import 'package:drift/drift.dart';
import 'connection/connection.dart' as conn;

part 'app_database.g.dart';

// ── Tables ──

/// Tracks which lessons the user has completed.
class CompletedLessons extends Table {
  TextColumn get lessonId => text()();
  TextColumn get moduleId => text()();
  DateTimeColumn get completedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {lessonId};
}

/// User bookmarks on lessons.
class Bookmarks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get lessonId => text()();
  TextColumn get moduleId => text()();
  DateTimeColumn get createdAt => dateTime()();
}

/// Quiz results per lesson.
class QuizResults extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get lessonId => text()();
  IntColumn get totalQuestions => integer()();
  IntColumn get correctAnswers => integer()();
  RealColumn get percentage => real()();
  DateTimeColumn get takenAt => dateTime()();
}

/// Daily streak tracking.
class LearningStreak extends Table {
  TextColumn get date => text()(); // yyyy-MM-dd
  IntColumn get lessonsCompleted => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {date};
}

// ── Database ──

@DriftDatabase(
  tables: [CompletedLessons, Bookmarks, QuizResults, LearningStreak],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(conn.openConnection());

  @override
  int get schemaVersion => 1;

  // ── Completed Lessons ──

  Future<void> markLessonCompleted(String lessonId, String moduleId) {
    return into(completedLessons).insertOnConflictUpdate(
      CompletedLessonsCompanion.insert(
        lessonId: lessonId,
        moduleId: moduleId,
        completedAt: DateTime.now(),
      ),
    );
  }

  Future<bool> isLessonCompleted(String lessonId) async {
    final query = select(completedLessons)
      ..where((t) => t.lessonId.equals(lessonId));
    final result = await query.getSingleOrNull();
    return result != null;
  }

  Future<List<CompletedLesson>> getCompletedLessonsForModule(
      String moduleId) {
    final query = select(completedLessons)
      ..where((t) => t.moduleId.equals(moduleId));
    return query.get();
  }

  Future<int> countCompletedLessons(String moduleId) async {
    final list = await getCompletedLessonsForModule(moduleId);
    return list.length;
  }

  // ── Bookmarks ──

  Future<int> addBookmark(String lessonId, String moduleId) {
    return into(bookmarks).insert(
      BookmarksCompanion.insert(
        lessonId: lessonId,
        moduleId: moduleId,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> removeBookmark(String lessonId) {
    return (delete(bookmarks)..where((t) => t.lessonId.equals(lessonId))).go();
  }

  Future<bool> isBookmarked(String lessonId) async {
    final query = select(bookmarks)
      ..where((t) => t.lessonId.equals(lessonId));
    final result = await query.getSingleOrNull();
    return result != null;
  }

  Future<List<Bookmark>> getAllBookmarks() {
    return (select(bookmarks)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  // ── Quiz Results ──

  Future<int> saveQuizResult({
    required String lessonId,
    required int totalQuestions,
    required int correctAnswers,
  }) {
    final percentage =
        totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0.0;
    return into(quizResults).insert(
      QuizResultsCompanion.insert(
        lessonId: lessonId,
        totalQuestions: totalQuestions,
        correctAnswers: correctAnswers,
        percentage: percentage,
        takenAt: DateTime.now(),
      ),
    );
  }

  Future<QuizResult?> getBestQuizResult(String lessonId) {
    final query = select(quizResults)
      ..where((t) => t.lessonId.equals(lessonId))
      ..orderBy([(t) => OrderingTerm.desc(t.percentage)])
      ..limit(1);
    return query.getSingleOrNull();
  }

  // ── Streak ──

  Future<void> recordLearningDay() {
    final today = _todayString();
    return into(learningStreak).insertOnConflictUpdate(
      LearningStreakCompanion.insert(
        date: today,
        lessonsCompleted: const Value(1),
      ),
    );
  }

  Future<int> getCurrentStreak() async {
    final rows = await (select(learningStreak)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();

    if (rows.isEmpty) return 0;

    int streak = 0;
    DateTime checkDate = DateTime.now();

    for (final row in rows) {
      final rowDate = DateTime.parse(row.date);
      final diff = _daysBetween(rowDate, checkDate);

      if (diff <= 1) {
        streak++;
        checkDate = rowDate;
      } else {
        break;
      }
    }
    return streak;
  }

  String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  int _daysBetween(DateTime a, DateTime b) {
    final aDay = DateTime(a.year, a.month, a.day);
    final bDay = DateTime(b.year, b.month, b.day);
    return bDay.difference(aDay).inDays;
  }
}

