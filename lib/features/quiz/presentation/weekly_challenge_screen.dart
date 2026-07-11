import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/quiz_resume_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../modules/data/fiqh_data_source.dart';
import '../../modules/data/models/fiqh_models.dart';

// ── Weekly parts config: difficulty up → time per question down ──

class _WeeklyPart {
  final String level;
  final String label;
  final int seconds;
  final int count;
  final Color color;
  final IconData icon;

  const _WeeklyPart({
    required this.level,
    required this.label,
    required this.seconds,
    required this.count,
    required this.color,
    required this.icon,
  });
}

const _parts = [
  _WeeklyPart(
    level: 'beginner',
    label: 'Fillestar',
    seconds: 25,
    count: 6,
    color: AppColors.success,
    icon: Icons.emoji_events_rounded,
  ),
  _WeeklyPart(
    level: 'intermediate',
    label: 'Mesatar',
    seconds: 18,
    count: 6,
    color: AppColors.warning,
    icon: Icons.trending_up_rounded,
  ),
  _WeeklyPart(
    level: 'advanced',
    label: 'Avancuar',
    seconds: 10,
    count: 6,
    color: AppColors.error,
    icon: Icons.local_fire_department_rounded,
  ),
];

// ── ISO week helpers ──

(int, int) _isoYearWeek(DateTime d) {
  final thursday = d.add(Duration(days: 4 - d.weekday));
  final firstDay = DateTime(thursday.year, 1, 1);
  final week = (thursday.difference(firstDay).inDays / 7).floor() + 1;
  return (thursday.year, week);
}

String _weekKey(DateTime d) {
  final (y, w) = _isoYearWeek(d);
  return '$y-W${w.toString().padLeft(2, '0')}';
}

String _weekLabel(DateTime d) {
  final (y, w) = _isoYearWeek(d);
  return 'Java $w, $y';
}

const _kLastWeekKey = 'weekly_ch_last_week';
const _kLastScoreKey = 'weekly_ch_last_score';
const _kStreakKey = 'weekly_ch_streak';

/// This week's fixed question sets, one list per part, seeded by the ISO week.
final weeklyQuestionsProvider =
    FutureProvider<List<List<QuizQuestion>>>((ref) async {
  final modules = await FiqhDataSource().loadAllModules();
  final byLevel = <String, List<QuizQuestion>>{};
  for (final module in modules) {
    for (final lesson in module.lessons) {
      final bucket = byLevel.putIfAbsent(lesson.level, () => []);
      bucket.addAll(lesson.quiz);
      bucket.addAll(lesson.poolQuiz);
    }
  }

  final (y, w) = _isoYearWeek(DateTime.now());
  final rng = Random(y * 100 + w);

  return [
    for (final part in _parts)
      () {
        final list = List<QuizQuestion>.from(byLevel[part.level] ?? []);
        list.shuffle(rng);
        return list.take(part.count).toList();
      }(),
  ];
});

class WeeklyStatus {
  final bool completedThisWeek;
  final int lastScore;
  final int streak;
  const WeeklyStatus({
    required this.completedThisWeek,
    required this.lastScore,
    required this.streak,
  });
}

final weeklyStatusProvider = FutureProvider<WeeklyStatus>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return WeeklyStatus(
    completedThisWeek: prefs.getString(_kLastWeekKey) == _weekKey(DateTime.now()),
    lastScore: prefs.getInt(_kLastScoreKey) ?? 0,
    streak: prefs.getInt(_kStreakKey) ?? 0,
  );
});

Future<int> _saveWeeklyResult(int scorePct) async {
  final prefs = await SharedPreferences.getInstance();
  final now = DateTime.now();
  final thisWeek = _weekKey(now);
  final prevWeek = _weekKey(now.subtract(const Duration(days: 7)));
  final lastWeek = prefs.getString(_kLastWeekKey);

  int streak = prefs.getInt(_kStreakKey) ?? 0;
  if (lastWeek == thisWeek) {
    // Already recorded this week — keep streak.
  } else if (lastWeek == prevWeek) {
    streak += 1;
  } else {
    streak = 1;
  }
  await prefs.setString(_kLastWeekKey, thisWeek);
  await prefs.setInt(_kLastScoreKey, scorePct);
  await prefs.setInt(_kStreakKey, streak);
  return streak;
}

// ── Screen ──

class WeeklyChallengeScreen extends ConsumerStatefulWidget {
  const WeeklyChallengeScreen({super.key});

  @override
  ConsumerState<WeeklyChallengeScreen> createState() =>
      _WeeklyChallengeScreenState();
}

class _WeeklyChallengeScreenState
    extends ConsumerState<WeeklyChallengeScreen> {
  static const _tick = Duration(milliseconds: 100);
  static const _feedbackDelay = Duration(milliseconds: 1600);

  // 'intro' | 'partIntro' | 'question' | 'final'
  String _phase = 'intro';
  int _partIndex = 0;
  int _qIndex = 0;
  bool _answered = false;
  int? _selected;
  double _remaining = 0;
  Timer? _ticker;
  Timer? _advanceTimer;
  bool _saved = false;
  int _streak = 0;

  final List<int> _correct = [0, 0, 0];
  final List<int> _wrong = [0, 0, 0];
  final List<int> _timeouts = [0, 0, 0];

  /// Saved mid-challenge state for this week, if any.
  Map<String, dynamic>? _resume;

  _WeeklyPart get _part => _parts[_partIndex];

  @override
  void initState() {
    super.initState();
    _loadResume();
  }

  Future<void> _loadResume() async {
    final saved = await QuizResumeService.load(QuizResumeService.weeklyKey);
    if (saved == null) return;
    if (saved['week'] != _weekKey(DateTime.now())) {
      // Stale (another week) — discard.
      await QuizResumeService.clear(QuizResumeService.weeklyKey);
      return;
    }
    if (!mounted) return;
    setState(() => _resume = saved);
  }

  void _applyResume() {
    final saved = _resume;
    if (saved == null) return;
    List<int> ints(String key) => [
          for (final v in (saved[key] as List? ?? const []))
            (v as num).toInt(),
        ];
    final corr = ints('correct');
    final wrong = ints('wrong');
    final touts = ints('timeouts');
    setState(() {
      _partIndex = ((saved['partIndex'] as num?)?.toInt() ?? 0).clamp(0, 2);
      _qIndex = (saved['qIndex'] as num?)?.toInt() ?? 0;
      for (int i = 0; i < 3; i++) {
        _correct[i] = i < corr.length ? corr[i] : 0;
        _wrong[i] = i < wrong.length ? wrong[i] : 0;
        _timeouts[i] = i < touts.length ? touts[i] : 0;
      }
      _saved = saved['alreadySaved'] == true;
      _answered = false;
      _selected = null;
      _phase = 'partIntro';
    });
  }

  void _persist() {
    QuizResumeService.save(QuizResumeService.weeklyKey, {
      'week': _weekKey(DateTime.now()),
      'partIndex': _partIndex,
      'qIndex': _qIndex,
      'correct': _correct,
      'wrong': _wrong,
      'timeouts': _timeouts,
      'alreadySaved': _saved,
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _advanceTimer?.cancel();
    super.dispose();
  }

  void _startQuestion() {
    _ticker?.cancel();
    setState(() {
      _answered = false;
      _selected = null;
      _remaining = _part.seconds.toDouble();
    });
    _ticker = Timer.periodic(_tick, (_) {
      if (!mounted) return;
      setState(() {
        _remaining -= 0.1;
        if (_remaining <= 0) {
          _remaining = 0;
          _onTimeout();
        }
      });
    });
  }

  void _onTimeout() {
    _ticker?.cancel();
    _answered = true;
    _selected = null;
    _timeouts[_partIndex]++;
    _scheduleAdvance();
  }

  void _onSelect(int i, int correctIndex) {
    if (_answered) return;
    _ticker?.cancel();
    setState(() {
      _answered = true;
      _selected = i;
      if (i == correctIndex) {
        _correct[_partIndex]++;
      } else {
        _wrong[_partIndex]++;
      }
    });
    _scheduleAdvance();
  }

  void _scheduleAdvance() {
    _advanceTimer?.cancel();
    _advanceTimer = Timer(_feedbackDelay, () {
      if (!mounted) return;
      final questions = ref.read(weeklyQuestionsProvider).valueOrNull;
      final partLen = questions?[_partIndex].length ?? 0;
      if (_qIndex + 1 < partLen) {
        setState(() => _qIndex++);
        _persist();
        _startQuestion();
      } else if (_partIndex + 1 < _parts.length) {
        setState(() {
          _partIndex++;
          _qIndex = 0;
          _phase = 'partIntro';
        });
        _persist();
      } else {
        QuizResumeService.clear(QuizResumeService.weeklyKey);
        setState(() => _phase = 'final');
      }
    });
  }

  void _restart() {
    _ticker?.cancel();
    _advanceTimer?.cancel();
    QuizResumeService.clear(QuizResumeService.weeklyKey);
    setState(() {
      _resume = null;
      _phase = 'partIntro';
      _partIndex = 0;
      _qIndex = 0;
      _answered = false;
      _selected = null;
      _saved = true; // replays this week don't re-register
      for (int i = 0; i < 3; i++) {
        _correct[i] = 0;
        _wrong[i] = 0;
        _timeouts[i] = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_phase) {
      case 'intro':
        return _buildIntro();
      case 'partIntro':
        return _buildPartIntro();
      case 'question':
        return _buildQuestion();
      default:
        return _buildFinal();
    }
  }

  Widget _buildIntro() {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final statusAsync = ref.watch(weeklyStatusProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sfida Javore')),
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
                  Icon(Icons.date_range_rounded, size: 64, color: cs.primary),
                  const SizedBox(height: 12),
                  Text(
                    _weekLabel(DateTime.now()),
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: cs.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sfida e Javës',
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '3 pjesë me kohëmatës — sa më lart niveli, aq më pak kohë për pyetje. Pyetjet ndryshojnë çdo javë!',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: cs.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  for (final part in _parts)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: part.color.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: part.color.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          children: [
                            Icon(part.icon, color: part.color, size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Pjesa ${_parts.indexOf(part) + 1} — ${part.label}',
                                style: theme.textTheme.titleSmall,
                              ),
                            ),
                            Icon(Icons.timer_rounded,
                                size: 15, color: part.color),
                            const SizedBox(width: 4),
                            Text(
                              '${part.count} pyetje × ${part.seconds}s',
                              style: theme.textTheme.labelMedium
                                  ?.copyWith(color: part.color),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  if (status.streak > 0)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cs.secondaryContainer.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: cs.outlineVariant),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.local_fire_department_rounded,
                              color: AppColors.warning, size: 26),
                          const SizedBox(width: 10),
                          Text(
                            'Seria: ${status.streak} javë',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (status.completedThisWeek) ...[
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
                            'E përfundove sfidën e kësaj jave!',
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
                            'Kthehu javën tjetër për sfidën e re.',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        _restart();
                      },
                      icon: const Icon(Icons.replay_rounded),
                      label: const Text('Provo Përsëri (pa u regjistruar)'),
                    ),
                  ] else if (_resume != null) ...[
                    FilledButton.icon(
                      onPressed: _applyResume,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: Text(
                        'Vazhdo ku mbete (Pjesa ${(((_resume!['partIndex'] as num?)?.toInt() ?? 0).clamp(0, 2)) + 1}, pyetja ${((_resume!['qIndex'] as num?)?.toInt() ?? 0) + 1})',
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () {
                        QuizResumeService.clear(QuizResumeService.weeklyKey);
                        setState(() {
                          _resume = null;
                          _partIndex = 0;
                          _qIndex = 0;
                          for (int i = 0; i < 3; i++) {
                            _correct[i] = 0;
                            _wrong[i] = 0;
                            _timeouts[i] = 0;
                          }
                          _phase = 'partIntro';
                        });
                      },
                      icon: const Icon(Icons.replay_rounded),
                      label: const Text('Fillo nga e para'),
                    ),
                  ] else
                    FilledButton.icon(
                      onPressed: () => setState(() => _phase = 'partIntro'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Fillo Sfidën e Javës'),
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

  Widget _buildPartIntro() {
    final theme = Theme.of(context);
    final part = _part;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sfida Javore'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(part.icon, size: 80, color: part.color),
                const SizedBox(height: 24),
                Text(
                  'Pjesa ${_partIndex + 1}/3 — ${part.label}',
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: part.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.timer_rounded, size: 18, color: part.color),
                      const SizedBox(width: 6),
                      Text(
                        '${part.count} pyetje × ${part.seconds} sekonda',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(color: part.color),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: () {
                    setState(() => _phase = 'question');
                    _startQuestion();
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text('Fillo Pjesën ${_partIndex + 1}'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion() {
    final questionsAsync = ref.watch(weeklyQuestionsProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return questionsAsync.when(
      data: (allParts) {
        final questions = allParts[_partIndex];
        if (questions.isEmpty) {
          // No questions for this part — skip forward.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_partIndex + 1 < _parts.length) {
              setState(() {
                _partIndex++;
                _phase = 'partIntro';
              });
            } else {
              setState(() => _phase = 'final');
            }
          });
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        final q = questions[_qIndex];
        final part = _part;
        final ratio = _remaining / part.seconds;
        final timerColor = ratio > 0.5
            ? AppColors.success
            : (ratio > 0.25 ? AppColors.warning : AppColors.error);

        return Scaffold(
          appBar: AppBar(
            title: Text(
                '${part.label} — ${_qIndex + 1}/${questions.length}'),
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: timerColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.timer_rounded,
                            size: 16, color: timerColor),
                        const SizedBox(width: 4),
                        Text(
                          '${_remaining.ceil()}s',
                          style: theme.textTheme.labelLarge
                              ?.copyWith(color: timerColor),
                        ),
                      ],
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
                          value: ratio,
                          minHeight: 8,
                          backgroundColor: cs.surfaceContainerHighest,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(timerColor),
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
                              _WeeklyOption(
                                text: q.options[i],
                                index: i,
                                correctIndex: q.correctIndex,
                                selected: _selected,
                                answered: _answered,
                                onTap: () => _onSelect(i, q.correctIndex),
                              ),
                              const SizedBox(height: 8),
                            ],
                            if (_answered && _selected == null) ...[
                              const SizedBox(height: 8),
                              Card(
                                color:
                                    AppColors.error.withValues(alpha: 0.08),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.timer_off_rounded,
                                          color: AppColors.error, size: 20),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Koha mbaroi!',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                  color: AppColors.error),
                                        ),
                                      ),
                                    ],
                                  ),
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

  Widget _buildFinal() {
    final theme = Theme.of(context);
    final questions = ref.watch(weeklyQuestionsProvider).valueOrNull;
    final totals = [
      for (int i = 0; i < 3; i++) questions?[i].length ?? 0,
    ];
    final total = totals.fold(0, (a, b) => a + b);
    final correct = _correct.fold(0, (a, b) => a + b);
    final pct = total > 0 ? ((correct / total) * 100).round() : 0;

    if (!_saved) {
      _saved = true;
      _saveWeeklyResult(pct).then((streak) {
        if (mounted) {
          setState(() => _streak = streak);
          ref.invalidate(weeklyStatusProvider);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rezultati i Javës'),
        automaticallyImplyLeading: false,
      ),
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
                        ? Icons.workspace_premium_rounded
                        : Icons.date_range_rounded,
                    size: 64,
                    color: pct >= 70 ? AppColors.accent : AppColors.warning,
                  ),
                  const SizedBox(height: 16),
                  Text('$pct%',
                      style: theme.textTheme.headlineLarge,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 4),
                  Text(
                    '$correct / $total sakte — ${_weekLabel(DateTime.now())}',
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  for (int i = 0; i < _parts.length; i++)
                    if (totals[i] > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color:
                                _parts[i].color.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(_parts[i].icon,
                                  color: _parts[i].color, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(_parts[i].label,
                                    style: theme.textTheme.bodyMedium),
                              ),
                              if (_timeouts[i] > 0) ...[
                                const Icon(Icons.timer_off_rounded,
                                    size: 14, color: AppColors.warning),
                                Text(
                                  ' ${_timeouts[i]}  ',
                                  style: theme.textTheme.bodySmall
                                      ?.copyWith(color: AppColors.warning),
                                ),
                              ],
                              Text(
                                '${_correct[i]}/${totals[i]}',
                                style: theme.textTheme.titleSmall
                                    ?.copyWith(color: _parts[i].color),
                              ),
                            ],
                          ),
                        ),
                      ),
                  const SizedBox(height: 12),
                  if (_streak > 0)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.warning),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.local_fire_department_rounded,
                              color: AppColors.warning, size: 26),
                          const SizedBox(width: 10),
                          Text(
                            'Seria jote: $_streak javë rresht!',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    pct >= 90
                        ? 'Shkëlqyeshëm! Të presim javën tjetër!'
                        : pct >= 60
                            ? 'Shumë mirë! Kthehu javën tjetër.'
                            : 'Vazhdo të mësosh — javën tjetër sfidë e re!',
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
}

class _WeeklyOption extends StatelessWidget {
  final String text;
  final int index;
  final int correctIndex;
  final int? selected;
  final bool answered;
  final VoidCallback onTap;

  const _WeeklyOption({
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
