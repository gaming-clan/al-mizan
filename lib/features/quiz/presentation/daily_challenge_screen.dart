import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/quiz_resume_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../modules/data/fiqh_data_source.dart';
import '../../modules/data/models/fiqh_models.dart';

const _kLastDateKey = 'daily_ch_last_date';
const _kLastScoreKey = 'daily_ch_last_score';
const _kStreakKey = 'daily_ch_streak';

String _dateKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

const _sqMonths = [
  'Janar', 'Shkurt', 'Mars', 'Prill', 'Maj', 'Qershor',
  'Korrik', 'Gusht', 'Shtator', 'Tetor', 'Nëntor', 'Dhjetor'
];

String _sqDate(DateTime d) => '${d.day} ${_sqMonths[d.month - 1]} ${d.year}';

/// Number of questions taken from each level per day.
const _kQuestionsPerLevel = 5;

/// Today's fixed question set: truly interleaved 1 beginner + 1 intermediate
/// + 1 advanced, repeated, seeded by the date so the whole day serves the
/// same questions.
final dailyQuestionsProvider = FutureProvider<List<QuizQuestion>>((ref) async {
  final modules = await FiqhDataSource().loadAllModules();
  final byLevel = <String, List<QuizQuestion>>{
    'beginner': [],
    'intermediate': [],
    'advanced': [],
  };
  for (final module in modules) {
    for (final lesson in module.lessons) {
      byLevel[lesson.level]?.addAll(lesson.quiz);
      byLevel[lesson.level]?.addAll(lesson.poolQuiz);
    }
  }

  final now = DateTime.now();
  final seed = now.year * 10000 + now.month * 100 + now.day;
  final rng = Random(seed);

  List<QuizQuestion> pick(String level, int count) {
    final list = List<QuizQuestion>.from(byLevel[level] ?? []);
    list.shuffle(rng);
    return list.take(count).toList();
  }

  final beginner = pick('beginner', _kQuestionsPerLevel);
  final intermediate = pick('intermediate', _kQuestionsPerLevel);
  final advanced = pick('advanced', _kQuestionsPerLevel);

  // True mix: 1 easy, 1 medium, 1 advanced, repeated.
  final mixed = <QuizQuestion>[];
  for (var i = 0; i < _kQuestionsPerLevel; i++) {
    if (i < beginner.length) mixed.add(beginner[i]);
    if (i < intermediate.length) mixed.add(intermediate[i]);
    if (i < advanced.length) mixed.add(advanced[i]);
  }
  return mixed;
});

/// Completion state for today's challenge.
class DailyStatus {
  final bool completedToday;
  final int lastScore;
  final int streak;
  const DailyStatus({
    required this.completedToday,
    required this.lastScore,
    required this.streak,
  });
}

final dailyStatusProvider = FutureProvider<DailyStatus>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final today = _dateKey(DateTime.now());
  final lastDate = prefs.getString(_kLastDateKey);
  return DailyStatus(
    completedToday: lastDate == today,
    lastScore: prefs.getInt(_kLastScoreKey) ?? 0,
    streak: prefs.getInt(_kStreakKey) ?? 0,
  );
});

Future<int> _saveDailyResult(int scorePct) async {
  final prefs = await SharedPreferences.getInstance();
  final now = DateTime.now();
  final today = _dateKey(now);
  final yesterday = _dateKey(now.subtract(const Duration(days: 1)));
  final lastDate = prefs.getString(_kLastDateKey);

  int streak = prefs.getInt(_kStreakKey) ?? 0;
  if (lastDate == today) {
    // Already recorded today — keep streak as is.
  } else if (lastDate == yesterday) {
    streak += 1;
  } else {
    streak = 1;
  }
  await prefs.setString(_kLastDateKey, today);
  await prefs.setInt(_kLastScoreKey, scorePct);
  await prefs.setInt(_kStreakKey, streak);
  return streak;
}

class DailyChallengeScreen extends ConsumerStatefulWidget {
  const DailyChallengeScreen({super.key});

  @override
  ConsumerState<DailyChallengeScreen> createState() =>
      _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends ConsumerState<DailyChallengeScreen> {
  bool _started = false;
  int _startIndex = 0;
  int _startCorrect = 0;

  /// Saved mid-quiz state for today, if any (index of the next question).
  int? _resumeIndex;

  @override
  void initState() {
    super.initState();
    _loadResume();
  }

  Future<void> _loadResume() async {
    final saved = await QuizResumeService.load(QuizResumeService.dailyKey);
    if (saved == null) return;
    if (saved['date'] != _dateKey(DateTime.now())) {
      // Stale (another day) — discard.
      await QuizResumeService.clear(QuizResumeService.dailyKey);
      return;
    }
    if (!mounted) return;
    setState(() => _resumeIndex = (saved['index'] as num?)?.toInt() ?? 0);
    _startCorrect = (saved['correct'] as num?)?.toInt() ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    if (!_started) {
      return _DailyIntro(
        resumeIndex: _resumeIndex,
        onStart: () {
          QuizResumeService.clear(QuizResumeService.dailyKey);
          setState(() {
            _startIndex = 0;
            _startCorrect = 0;
            _started = true;
          });
        },
        onResume: _resumeIndex == null
            ? null
            : () => setState(() {
                  _startIndex = _resumeIndex!;
                  _started = true;
                }),
      );
    }
    return _DailyQuizBody(
      startIndex: _startIndex,
      startCorrect: _startCorrect,
    );
  }
}

class _DailyIntro extends ConsumerWidget {
  final VoidCallback onStart;
  final VoidCallback? onResume;
  final int? resumeIndex;
  const _DailyIntro({
    required this.onStart,
    this.onResume,
    this.resumeIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final statusAsync = ref.watch(dailyStatusProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sfida Ditore')),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: statusAsync.when(
              data: (status) => ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const SizedBox(height: 12),
                  Icon(Icons.today_rounded, size: 64, color: cs.primary),
                  const SizedBox(height: 12),
                  Text(
                    _sqDate(DateTime.now()),
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: cs.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sfida e Ditës',
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '15 pyetje të përziera në mënyrë të barabartë nga të tre nivelet (1 e lehtë, 1 mesatare, 1 e avancuar, me radhë). Pyetjet ndryshojnë çdo ditë!',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: cs.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  if (status.streak > 0)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cs.secondaryContainer.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: cs.outlineVariant),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.local_fire_department_rounded,
                              color: AppColors.warning, size: 28),
                          const SizedBox(width: 10),
                          Text(
                            'Seria: ${status.streak} ditë',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  if (status.completedToday) ...[
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.success),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              color: AppColors.success, size: 40),
                          const SizedBox(height: 8),
                          Text(
                            'E përfundove sfidën e sotme!',
                            style: theme.textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rezultati: ${status.lastScore}%',
                            style: theme.textTheme.headlineSmall
                                ?.copyWith(color: AppColors.success),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Kthehu nesër për sfidën e re.',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: onStart,
                      icon: const Icon(Icons.replay_rounded),
                      label: const Text('Provo Përsëri (pa u regjistruar)'),
                    ),
                  ] else if (onResume != null) ...[
                    FilledButton.icon(
                      onPressed: onResume,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: Text(
                          'Vazhdo ku mbete (pyetja ${(resumeIndex ?? 0) + 1})'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: onStart,
                      icon: const Icon(Icons.replay_rounded),
                      label: const Text('Fillo nga e para'),
                    ),
                  ] else
                    FilledButton.icon(
                      onPressed: onStart,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Fillo Sfidën e Ditës'),
                    ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Gabim: $e')),
            ),
          ),
        ),
      ),
    );
  }
}

class _DailyQuizBody extends ConsumerStatefulWidget {
  final int startIndex;
  final int startCorrect;
  const _DailyQuizBody({this.startIndex = 0, this.startCorrect = 0});

  @override
  ConsumerState<_DailyQuizBody> createState() => _DailyQuizBodyState();
}

class _DailyQuizBodyState extends ConsumerState<_DailyQuizBody> {
  late int _index = widget.startIndex;
  late int _correct = widget.startCorrect;
  bool _answered = false;
  int? _selected;
  bool _saved = false;
  int _streak = 0;

  void _persist(int total) {
    if (_index < total) {
      QuizResumeService.save(QuizResumeService.dailyKey, {
        'date': _dateKey(DateTime.now()),
        'index': _index,
        'correct': _correct,
      });
    } else {
      QuizResumeService.clear(QuizResumeService.dailyKey);
    }
  }

  String _levelTag(int index) {
    switch (index % 3) {
      case 0:
        return 'Fillestar';
      case 1:
        return 'Mesatar';
      default:
        return 'Avancuar';
    }
  }

  Color _levelColor(int index) {
    switch (index % 3) {
      case 0:
        return AppColors.success;
      case 1:
        return AppColors.warning;
      default:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(dailyQuestionsProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return questionsAsync.when(
      data: (questions) {
        if (questions.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Sfida Ditore')),
            body: const Center(child: Text('Nuk ka pyetje të mjaftueshme.')),
          );
        }

        // Results
        if (_index >= questions.length) {
          final pct = ((_correct / questions.length) * 100).round();
          if (!_saved) {
            _saved = true;
            _saveDailyResult(pct).then((streak) {
              if (mounted) {
                setState(() => _streak = streak);
                ref.invalidate(dailyStatusProvider);
              }
            });
          }
          return Scaffold(
            appBar: AppBar(title: const Text('Rezultati i Ditës')),
            body: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          pct >= 70
                              ? Icons.emoji_events_rounded
                              : Icons.today_rounded,
                          size: 64,
                          color:
                              pct >= 70 ? AppColors.accent : AppColors.warning,
                        ),
                        const SizedBox(height: 16),
                        Text('$pct%',
                            style: theme.textTheme.headlineLarge,
                            textAlign: TextAlign.center),
                        const SizedBox(height: 4),
                        Text(
                          '$_correct / ${questions.length} sakte — ${_sqDate(DateTime.now())}',
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        if (_streak > 0)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.warning),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                    Icons.local_fire_department_rounded,
                                    color: AppColors.warning,
                                    size: 28),
                                const SizedBox(width: 10),
                                Text(
                                  'Seria jote: $_streak ditë rresht!',
                                  style: theme.textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 20),
                        Text(
                          pct >= 90
                              ? 'Shkëlqyeshëm! Të presim nesër!'
                              : pct >= 60
                                  ? 'Shumë mirë! Kthehu nesër për sfidën e re.'
                                  : 'Vazhdo të mësosh — nesër sfidë e re!',
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Kthehu'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        // Question
        final q = questions[_index];
        final tag = _levelTag(_index);
        final tagColor = _levelColor(_index);

        return Scaffold(
          appBar: AppBar(
            title: Text('Pyetja ${_index + 1}/${questions.length}'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: tagColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag,
                      style: theme.textTheme.labelMedium
                          ?.copyWith(color: tagColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (_index + 1) / questions.length,
                          minHeight: 6,
                          backgroundColor: cs.surfaceContainerHighest,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: ListView(
                          children: [
                            Text(q.question,
                                style: theme.textTheme.headlineSmall),
                            const SizedBox(height: 24),
                            for (int i = 0; i < q.options.length; i++) ...[
                              _DailyOption(
                                text: q.options[i],
                                index: i,
                                correctIndex: q.correctIndex,
                                selected: _selected,
                                answered: _answered,
                                onTap: () {
                                  if (_answered) return;
                                  setState(() {
                                    _answered = true;
                                    _selected = i;
                                    if (i == q.correctIndex) _correct++;
                                  });
                                },
                              ),
                              const SizedBox(height: 8),
                            ],
                            if (_answered) ...[
                              const SizedBox(height: 8),
                              Card(
                                color:
                                    AppColors.primary.withValues(alpha: 0.08),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(q.explanation,
                                      style: theme.textTheme.bodyMedium),
                                ),
                              ),
                              const SizedBox(height: 16),
                              FilledButton(
                                onPressed: () {
                                  setState(() {
                                    _index++;
                                    _answered = false;
                                    _selected = null;
                                  });
                                  _persist(questions.length);
                                },
                                child: Text(
                                  _index + 1 < questions.length
                                      ? 'Pyetja Tjetër'
                                      : 'Shiko Rezultatin',
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Gabim: $e'))),
    );
  }
}

class _DailyOption extends StatelessWidget {
  final String text;
  final int index;
  final int correctIndex;
  final int? selected;
  final bool answered;
  final VoidCallback onTap;

  const _DailyOption({
    required this.text,
    required this.index,
    required this.correctIndex,
    required this.selected,
    required this.answered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color? borderColor;
    Color? bgColor;
    if (answered) {
      if (index == correctIndex) {
        borderColor = AppColors.success;
        bgColor = AppColors.success.withValues(alpha: 0.1);
      } else if (index == selected) {
        borderColor = AppColors.error;
        bgColor = AppColors.error.withValues(alpha: 0.1);
      }
    }

    return OutlinedButton(
      onPressed: answered ? null : onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        side: BorderSide(
          color: borderColor ?? Theme.of(context).dividerColor,
          width: borderColor != null ? 2 : 1,
        ),
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
