import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home/providers/home_provider.dart';
import '../../modules/data/fiqh_data_source.dart';

class ModuleStat {
  final String moduleId;
  final String title;
  final int done;
  final int total;

  const ModuleStat({
    required this.moduleId,
    required this.title,
    required this.done,
    required this.total,
  });

  double get ratio => total > 0 ? done / total : 0.0;
}

class LevelStat {
  final String level;
  final int done;
  final int total;

  const LevelStat({
    required this.level,
    required this.done,
    required this.total,
  });

  double get ratio => total > 0 ? done / total : 0.0;
}

class UserStats {
  final int lessonsDone;
  final int lessonsTotal;
  final int quizAttempts;
  final double avgScore;
  final double bestScore;
  final int learningStreak;
  final int bookmarksCount;
  final int dailyStreak;
  final int dailyLastScore;
  final int weeklyStreak;
  final int weeklyLastScore;
  final List<LevelStat> perLevel;
  final List<ModuleStat> perModule;

  const UserStats({
    required this.lessonsDone,
    required this.lessonsTotal,
    required this.quizAttempts,
    required this.avgScore,
    required this.bestScore,
    required this.learningStreak,
    required this.bookmarksCount,
    required this.dailyStreak,
    required this.dailyLastScore,
    required this.weeklyStreak,
    required this.weeklyLastScore,
    required this.perLevel,
    required this.perModule,
  });
}

final userStatsProvider = FutureProvider<UserStats>((ref) async {
  final db = ref.read(databaseProvider);
  final modules = await FiqhDataSource().loadAllModules();

  final completed = await db.getAllCompletedLessons();
  final completedIds = {for (final c in completed) c.lessonId};

  // Per-module and per-level progress
  final perModule = <ModuleStat>[];
  final levelDone = {'beginner': 0, 'intermediate': 0, 'advanced': 0};
  final levelTotal = {'beginner': 0, 'intermediate': 0, 'advanced': 0};
  int lessonsTotal = 0;
  int lessonsDone = 0;

  for (final module in modules) {
    int done = 0;
    for (final lesson in module.lessons) {
      lessonsTotal++;
      levelTotal[lesson.level] = (levelTotal[lesson.level] ?? 0) + 1;
      if (completedIds.contains(lesson.id)) {
        done++;
        lessonsDone++;
        levelDone[lesson.level] = (levelDone[lesson.level] ?? 0) + 1;
      }
    }
    perModule.add(ModuleStat(
      moduleId: module.moduleId,
      title: module.titleSq,
      done: done,
      total: module.lessons.length,
    ));
  }

  // Quiz aggregate
  final results = await db.getAllQuizResults();
  final attempts = results.length;
  double avg = 0;
  double best = 0;
  if (attempts > 0) {
    avg = results.map((r) => r.percentage).reduce((a, b) => a + b) / attempts;
    best = results.map((r) => r.percentage).reduce((a, b) => a > b ? a : b);
  }

  final streak = await db.getCurrentStreak();
  final bookmarks = await db.getAllBookmarks();

  final prefs = await SharedPreferences.getInstance();

  return UserStats(
    lessonsDone: lessonsDone,
    lessonsTotal: lessonsTotal,
    quizAttempts: attempts,
    avgScore: avg,
    bestScore: best,
    learningStreak: streak,
    bookmarksCount: bookmarks.length,
    dailyStreak: prefs.getInt('daily_ch_streak') ?? 0,
    dailyLastScore: prefs.getInt('daily_ch_last_score') ?? 0,
    weeklyStreak: prefs.getInt('weekly_ch_streak') ?? 0,
    weeklyLastScore: prefs.getInt('weekly_ch_last_score') ?? 0,
    perLevel: [
      for (final level in ['beginner', 'intermediate', 'advanced'])
        LevelStat(
          level: level,
          done: levelDone[level] ?? 0,
          total: levelTotal[level] ?? 0,
        ),
    ],
    perModule: perModule,
  );
});
