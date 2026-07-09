import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/quiz_resume_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../modules/data/fiqh_data_source.dart';
import '../../modules/data/models/fiqh_models.dart';

/// Difficulty levels for the timed challenge.
/// Higher difficulty → less time per question.
enum TimedLevel {
  beginner,
  intermediate,
  advanced;

  String get label {
    switch (this) {
      case TimedLevel.beginner:
        return 'Fillestar';
      case TimedLevel.intermediate:
        return 'Mesatar';
      case TimedLevel.advanced:
        return 'Avancuar';
    }
  }

  /// Seconds allowed per question.
  int get secondsPerQuestion {
    switch (this) {
      case TimedLevel.beginner:
        return 30;
      case TimedLevel.intermediate:
        return 20;
      case TimedLevel.advanced:
        return 12;
    }
  }

  int get questionCount {
    switch (this) {
      case TimedLevel.beginner:
        return 10;
      case TimedLevel.intermediate:
        return 15;
      case TimedLevel.advanced:
        return 20;
    }
  }

  /// Which lesson level the questions are drawn from.
  String get lessonLevel {
    switch (this) {
      case TimedLevel.beginner:
        return 'beginner';
      case TimedLevel.intermediate:
        return 'intermediate';
      case TimedLevel.advanced:
        return 'advanced';
    }
  }

  Color get color {
    switch (this) {
      case TimedLevel.beginner:
        return AppColors.success;
      case TimedLevel.intermediate:
        return AppColors.warning;
      case TimedLevel.advanced:
        return AppColors.error;
    }
  }

  IconData get icon {
    switch (this) {
      case TimedLevel.beginner:
        return Icons.emoji_events_rounded;
      case TimedLevel.intermediate:
        return Icons.trending_up_rounded;
      case TimedLevel.advanced:
        return Icons.local_fire_department_rounded;
    }
  }
}

/// Loads shuffled questions from lessons of the given level.
/// Seeded so an interrupted challenge can be resumed with the same set.
final timedQuestionsProvider = FutureProvider.family<List<QuizQuestion>,
    (TimedLevel, int)>((ref, args) async {
  final (level, seed) = args;
  final modules = await FiqhDataSource().loadAllModules();
  final questions = <QuizQuestion>[];
  for (final module in modules) {
    for (final lesson in module.lessons) {
      if (lesson.level == level.lessonLevel) {
        questions.addAll(lesson.quiz);
      }
    }
  }
  questions.shuffle(Random(seed));
  return questions.take(level.questionCount).toList();
});

class TimedChallengeScreen extends ConsumerStatefulWidget {
  /// When set (e.g. 'beginner'), skips the level selector and starts the
  /// timed quiz for that level directly — used after finishing a level.
  final String? initialLevel;

  const TimedChallengeScreen({super.key, this.initialLevel});

  @override
  ConsumerState<TimedChallengeScreen> createState() =>
      _TimedChallengeScreenState();
}

class _TimedChallengeScreenState extends ConsumerState<TimedChallengeScreen> {
  TimedLevel? _level;
  int _seed = QuizResumeService.newSeed();
  int _startIndex = 0;
  int _startCorrect = 0;
  int _startWrong = 0;
  int _startTimeouts = 0;

  @override
  void initState() {
    super.initState();
    final init = widget.initialLevel;
    if (init != null) {
      _level = TimedLevel.values.firstWhere(
        (l) => l.lessonLevel == init,
        orElse: () => TimedLevel.beginner,
      );
    } else {
      _checkResume();
    }
  }

  Future<void> _checkResume() async {
    final saved = await QuizResumeService.load(QuizResumeService.timedKey);
    if (saved == null || saved['seed'] is! int || !mounted) return;
    final levelName = saved['level'] as String?;
    final level = TimedLevel.values
        .where((l) => l.name == levelName)
        .firstOrNull;
    if (level == null) return;
    final index = (saved['index'] as num?)?.toInt() ?? 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Sfidë e papërfunduar'),
          content: Text(
              'E ke lënë përgjysmë një sfidë me kohë (${level.label}) te pyetja ${index + 1}. Dëshiron të vazhdosh ku mbete?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Fillo nga e para'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Vazhdo ku mbete'),
            ),
          ],
        ),
      ).then((resume) {
        if (!mounted) return;
        if (resume == true) {
          setState(() {
            _seed = saved['seed'] as int;
            _startIndex = index;
            _startCorrect = (saved['correct'] as num?)?.toInt() ?? 0;
            _startWrong = (saved['wrong'] as num?)?.toInt() ?? 0;
            _startTimeouts = (saved['timeouts'] as num?)?.toInt() ?? 0;
            _level = level;
          });
        } else {
          QuizResumeService.clear(QuizResumeService.timedKey);
        }
      });
    });
  }

  void _freshStart() {
    _seed = QuizResumeService.newSeed();
    _startIndex = 0;
    _startCorrect = 0;
    _startWrong = 0;
    _startTimeouts = 0;
  }

  @override
  Widget build(BuildContext context) {
    if (_level == null) {
      return _LevelSelector(onSelect: (l) {
        QuizResumeService.clear(QuizResumeService.timedKey);
        setState(() {
          _freshStart();
          _level = l;
        });
      });
    }
    return _TimedQuizBody(
      key: ValueKey('timed_${_level!.name}_$_seed'),
      level: _level!,
      seed: _seed,
      startIndex: _startIndex,
      startCorrect: _startCorrect,
      startWrong: _startWrong,
      startTimeouts: _startTimeouts,
      onRetry: () => setState(_freshStart),
      onExit: () => setState(() {
        _freshStart();
        _level = null;
      }),
    );
  }
}

class _LevelSelector extends StatelessWidget {
  final void Function(TimedLevel) onSelect;
  const _LevelSelector({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Sfida me Kohë')),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 12),
                Icon(Icons.timer_rounded, size: 64, color: cs.primary),
                const SizedBox(height: 16),
                Text(
                  'Sa shpejt mendon?',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Përgjigju para se të mbarojë koha! Sa më i lartë niveli, aq më pak kohë ke për çdo pyetje.',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: cs.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                for (final level in TimedLevel.values) ...[
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => onSelect(level),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                        child: Row(
                          children: [
                            Icon(level.icon, size: 36, color: level.color),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(level.label,
                                      style: theme.textTheme.titleMedium),
                                  Text(
                                    '${level.questionCount} pyetje — pyetje nga mësimet e nivelit ${level.label.toLowerCase()}',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: level.color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.timer_rounded,
                                      size: 15, color: level.color),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${level.secondsPerQuestion}s',
                                    style: theme.textTheme.labelLarge
                                        ?.copyWith(color: level.color),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimedQuizBody extends ConsumerStatefulWidget {
  final TimedLevel level;
  final int seed;
  final int startIndex;
  final int startCorrect;
  final int startWrong;
  final int startTimeouts;
  final VoidCallback onRetry;
  final VoidCallback onExit;

  const _TimedQuizBody({
    super.key,
    required this.level,
    required this.seed,
    this.startIndex = 0,
    this.startCorrect = 0,
    this.startWrong = 0,
    this.startTimeouts = 0,
    required this.onRetry,
    required this.onExit,
  });

  @override
  ConsumerState<_TimedQuizBody> createState() => _TimedQuizBodyState();
}

class _TimedQuizBodyState extends ConsumerState<_TimedQuizBody> {
  static const _tick = Duration(milliseconds: 100);
  static const _feedbackDelay = Duration(milliseconds: 1600);

  List<QuizQuestion>? _questions;
  late int _index = widget.startIndex;
  late int _correct = widget.startCorrect;
  late int _wrong = widget.startWrong;
  late int _timeouts = widget.startTimeouts;
  bool _answered = false;
  int? _selected;
  double _remaining = 0;

  void _persist() {
    final total = _questions?.length ?? 0;
    if (_index < total) {
      QuizResumeService.save(QuizResumeService.timedKey, {
        'level': widget.level.name,
        'seed': widget.seed,
        'index': _index,
        'correct': _correct,
        'wrong': _wrong,
        'timeouts': _timeouts,
      });
    } else {
      QuizResumeService.clear(QuizResumeService.timedKey);
    }
  }
  Timer? _ticker;
  Timer? _advanceTimer;

  int get _totalSeconds => widget.level.secondsPerQuestion;

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
      _remaining = _totalSeconds.toDouble();
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
    _timeouts++;
    _scheduleAdvance();
  }

  void _onSelect(int i, int correctIndex) {
    if (_answered) return;
    _ticker?.cancel();
    setState(() {
      _answered = true;
      _selected = i;
      if (i == correctIndex) {
        _correct++;
      } else {
        _wrong++;
      }
    });
    _scheduleAdvance();
  }

  void _scheduleAdvance() {
    _advanceTimer?.cancel();
    _advanceTimer = Timer(_feedbackDelay, () {
      if (!mounted) return;
      setState(() => _index++);
      _persist();
      if (_index < (_questions?.length ?? 0)) {
        _startQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync =
        ref.watch(timedQuestionsProvider((widget.level, widget.seed)));
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return questionsAsync.when(
      data: (questions) {
        if (questions.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Sfida me Kohë')),
            body: const Center(child: Text('Nuk ka pyetje për këtë nivel.')),
          );
        }

        if (_questions == null) {
          _questions = questions;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _persist();
            _startQuestion();
          });
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        // Results
        if (_index >= _questions!.length) {
          return _ResultScreen(
            level: widget.level,
            total: _questions!.length,
            correct: _correct,
            wrong: _wrong,
            timeouts: _timeouts,
            onRetry: () {
              QuizResumeService.clear(QuizResumeService.timedKey);
              widget.onRetry();
            },
            onExit: widget.onExit,
          );
        }

        final q = _questions![_index];
        final ratio = _remaining / _totalSeconds;
        final timerColor = ratio > 0.5
            ? AppColors.success
            : (ratio > 0.25 ? AppColors.warning : AppColors.error);

        return Scaffold(
          appBar: AppBar(
            title: Text('Pyetja ${_index + 1}/${_questions!.length}'),
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
                        Icon(Icons.timer_rounded, size: 16, color: timerColor),
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
                      // Time bar
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
                              _TimedOption(
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
                                color: AppColors.error.withValues(alpha: 0.08),
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
}

class _TimedOption extends StatelessWidget {
  final String text;
  final int index;
  final int correctIndex;
  final int? selected;
  final bool answered;
  final VoidCallback onTap;

  const _TimedOption({
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

class _ResultScreen extends StatelessWidget {
  final TimedLevel level;
  final int total;
  final int correct;
  final int wrong;
  final int timeouts;
  final VoidCallback onRetry;
  final VoidCallback onExit;

  const _ResultScreen({
    required this.level,
    required this.total,
    required this.correct,
    required this.wrong,
    required this.timeouts,
    required this.onRetry,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pct = total > 0 ? (correct / total) * 100 : 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Rezultati i Sfidës')),
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
                        : Icons.timer_rounded,
                    size: 64,
                    color: pct >= 70 ? AppColors.accent : AppColors.warning,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${pct.toStringAsFixed(0)}%',
                    style: theme.textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Niveli: ${level.label} — ${level.secondsPerQuestion}s për pyetje',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  _StatRow(
                    icon: Icons.check_circle_rounded,
                    color: AppColors.success,
                    label: 'Sakte',
                    value: correct,
                  ),
                  const SizedBox(height: 8),
                  _StatRow(
                    icon: Icons.cancel_rounded,
                    color: AppColors.error,
                    label: 'Gabim',
                    value: wrong,
                  ),
                  const SizedBox(height: 8),
                  _StatRow(
                    icon: Icons.timer_off_rounded,
                    color: AppColors.warning,
                    label: 'Pa përgjigje (koha mbaroi)',
                    value: timeouts,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _message(pct),
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.replay_rounded),
                    label: const Text('Provo Përsëri'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: onExit,
                    child: const Text('Zgjidh Nivel Tjetër'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _message(double pct) {
    if (pct >= 90) return 'Shkëlqyeshëm! Mendim i shpejtë dhe i saktë!';
    if (pct >= 70) return 'Shumë mirë! Vazhdo kështu.';
    if (pct >= 50) return 'Mirë, por provo të jesh më i shpejtë.';
    return 'Stërvitu edhe pak — shpejtësia vjen me përsëritje!';
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final int value;

  const _StatRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Text('$value',
              style: theme.textTheme.titleMedium?.copyWith(color: color)),
        ],
      ),
    );
  }
}
