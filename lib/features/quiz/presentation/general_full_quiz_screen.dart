import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/quiz_resume_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../modules/data/fiqh_data_source.dart';
import '../../modules/data/models/fiqh_models.dart';
import 'timed_challenge_screen.dart' show TimedLevel;

/// Questions taken from each level of the combined test.
const _kQuestionsPerLevel = 15;
const _kTotalQuestions = _kQuestionsPerLevel * 3;

/// The General Quiz's full test: all three difficulty levels back to back
/// (15 questions each, 45 total), answered at the user's own pace — there
/// is no per-question timer. A single stopwatch runs continuously from
/// 00:00 until all 45 questions are done.
final generalFullQuestionsProvider =
    FutureProvider.family<List<QuizQuestion>, int>((ref, seed) async {
  final modules = await FiqhDataSource().loadAllModules();
  final byLevel = <String, List<QuizQuestion>>{
    'beginner': [],
    'intermediate': [],
    'advanced': [],
  };
  for (final module in modules) {
    for (final lesson in module.lessons) {
      final bucket = byLevel[lesson.level];
      if (bucket != null) {
        bucket.addAll(lesson.quiz);
        bucket.addAll(lesson.poolQuiz);
      }
    }
  }
  final rng = Random(seed);
  List<QuizQuestion> pick(String level) {
    final list = List<QuizQuestion>.from(byLevel[level] ?? []);
    list.shuffle(rng);
    return list.take(_kQuestionsPerLevel).toList();
  }
  return [...pick('beginner'), ...pick('intermediate'), ...pick('advanced')];
});

TimedLevel _levelForIndex(int index) {
  if (index < _kQuestionsPerLevel) return TimedLevel.beginner;
  if (index < _kQuestionsPerLevel * 2) return TimedLevel.intermediate;
  return TimedLevel.advanced;
}

String _formatElapsed(int seconds) {
  final m = seconds ~/ 60;
  final s = seconds % 60;
  return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
}

class GeneralFullQuizScreen extends ConsumerStatefulWidget {
  const GeneralFullQuizScreen({super.key});

  @override
  ConsumerState<GeneralFullQuizScreen> createState() =>
      _GeneralFullQuizScreenState();
}

class _GeneralFullQuizScreenState
    extends ConsumerState<GeneralFullQuizScreen> {
  bool _started = false;
  int _seed = QuizResumeService.newSeed();
  int _startIndex = 0;
  int _startCorrect = 0;
  int _startElapsed = 0;
  List<int> _startCorrectByLevel = const [0, 0, 0];

  @override
  void initState() {
    super.initState();
    _checkResume();
  }

  Future<void> _checkResume() async {
    final saved =
        await QuizResumeService.load(QuizResumeService.generalFullKey);
    if (saved == null || saved['seed'] is! int || !mounted) return;
    final index = (saved['index'] as num?)?.toInt() ?? 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Test i papërfunduar'),
          content: Text(
              'E ke lënë përgjysmë Kuizin e Përgjithshëm te pyetja ${index + 1}/$_kTotalQuestions. Dëshiron të vazhdosh ku mbete?'),
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
            _startElapsed = (saved['elapsed'] as num?)?.toInt() ?? 0;
            final rawByLevel = saved['correctByLevel'] as List?;
            _startCorrectByLevel = rawByLevel != null
                ? [for (final v in rawByLevel) (v as num).toInt()]
                : const [0, 0, 0];
            _started = true;
          });
        } else {
          QuizResumeService.clear(QuizResumeService.generalFullKey);
        }
      });
    });
  }

  void _freshStart() {
    _seed = QuizResumeService.newSeed();
    _startIndex = 0;
    _startCorrect = 0;
    _startElapsed = 0;
    _startCorrectByLevel = const [0, 0, 0];
  }

  @override
  Widget build(BuildContext context) {
    if (!_started) {
      return _FullQuizIntro(
        onStart: () {
          QuizResumeService.clear(QuizResumeService.generalFullKey);
          setState(() {
            _freshStart();
            _started = true;
          });
        },
      );
    }
    return _FullQuizBody(
      key: ValueKey('general_full_$_seed'),
      seed: _seed,
      startIndex: _startIndex,
      startCorrect: _startCorrect,
      startElapsed: _startElapsed,
      startCorrectByLevel: _startCorrectByLevel,
      onRetry: () => setState(_freshStart),
      onExit: () => setState(() {
        _freshStart();
        _started = false;
      }),
    );
  }
}

class _FullQuizIntro extends StatelessWidget {
  final VoidCallback onStart;
  const _FullQuizIntro({required this.onStart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Kuiz i Përgjithshëm')),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 12),
                Icon(Icons.bolt_rounded, size: 64, color: cs.primary),
                const SizedBox(height: 16),
                Text(
                  'Testi i Plotë',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '3 pjesë — Fillestar, Mesatar, Avancuar — 15 pyetje secila, gjithsej $_kTotalQuestions pyetje. Pas çdo pjese kalon automatikisht te pjesa tjetër. Përgjigjesh me ritmin tënd — s\'ka kohë të kufizuar për pyetje — por një kronometër i vazhdueshëm mat kohën totale, nga 00:00 deri sa të përfundosh të gjitha pyetjet.',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: cs.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                for (final level in TimedLevel.values) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: level.color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(level.icon, color: level.color, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(level.label,
                              style: theme.textTheme.titleSmall),
                        ),
                        Text(
                          '$_kQuestionsPerLevel pyetje',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: level.color),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: onStart,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Fillo Kuizin e Përgjithshëm'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FullQuizBody extends ConsumerStatefulWidget {
  final int seed;
  final int startIndex;
  final int startCorrect;
  final int startElapsed;
  final List<int> startCorrectByLevel;
  final VoidCallback onRetry;
  final VoidCallback onExit;

  const _FullQuizBody({
    super.key,
    required this.seed,
    this.startIndex = 0,
    this.startCorrect = 0,
    this.startElapsed = 0,
    this.startCorrectByLevel = const [0, 0, 0],
    required this.onRetry,
    required this.onExit,
  });

  @override
  ConsumerState<_FullQuizBody> createState() => _FullQuizBodyState();
}

class _FullQuizBodyState extends ConsumerState<_FullQuizBody> {
  late int _index = widget.startIndex;
  late int _correct = widget.startCorrect;
  late int _elapsed = widget.startElapsed;
  late final List<int> _correctByLevel =
      List<int>.from(widget.startCorrectByLevel);
  bool _answered = false;
  int? _selected;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _elapsed++);
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _persist(int total) {
    if (_index >= total) {
      QuizResumeService.clear(QuizResumeService.generalFullKey);
    } else {
      QuizResumeService.save(QuizResumeService.generalFullKey, {
        'seed': widget.seed,
        'index': _index,
        'correct': _correct,
        'elapsed': _elapsed,
        'correctByLevel': _correctByLevel,
      });
    }
  }

  void _onSelect(int i, int correctIndex) {
    if (_answered) return;
    setState(() {
      _answered = true;
      _selected = i;
      if (i == correctIndex) {
        _correct++;
        _correctByLevel[_levelForIndex(_index).index]++;
      }
    });
  }

  void _next(int total) {
    setState(() {
      _index++;
      _answered = false;
      _selected = null;
    });
    _persist(total);
    if (_index >= total) _ticker?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync =
        ref.watch(generalFullQuestionsProvider(widget.seed));
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return questionsAsync.when(
      data: (questions) {
        if (questions.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Kuiz i Përgjithshëm')),
            body: const Center(child: Text('Nuk ka pyetje të mjaftueshme.')),
          );
        }
        final total = questions.length;

        if (_index >= total) {
          return _FullQuizResult(
            total: total,
            correct: _correct,
            elapsed: _elapsed,
            correctByLevel: _correctByLevel,
            onRetry: widget.onRetry,
            onExit: widget.onExit,
          );
        }

        final q = questions[_index];
        final level = _levelForIndex(_index);

        return Scaffold(
          appBar: AppBar(
            title: Text('Pyetja ${_index + 1}/$total'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer_outlined,
                            size: 15, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          _formatElapsed(_elapsed),
                          style: theme.textTheme.labelLarge
                              ?.copyWith(color: AppColors.primary),
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
                          value: (_index + 1) / total,
                          minHeight: 6,
                          backgroundColor: cs.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              level.color),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        level.label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: level.color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView(
                          children: [
                            Text(q.question,
                                style: theme.textTheme.headlineSmall),
                            const SizedBox(height: 24),
                            for (int i = 0; i < q.options.length; i++) ...[
                              _FullQuizOption(
                                text: q.options[i],
                                index: i,
                                correctIndex: q.correctIndex,
                                selected: _selected,
                                answered: _answered,
                                onTap: () =>
                                    _onSelect(i, q.correctIndex),
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
                                onPressed: () => _next(total),
                                child: Text(
                                  _index + 1 < total
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

class _FullQuizOption extends StatelessWidget {
  final String text;
  final int index;
  final int correctIndex;
  final int? selected;
  final bool answered;
  final VoidCallback onTap;

  const _FullQuizOption({
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

class _FullQuizResult extends StatelessWidget {
  final int total;
  final int correct;
  final int elapsed;
  final List<int> correctByLevel;
  final VoidCallback onRetry;
  final VoidCallback onExit;

  const _FullQuizResult({
    required this.total,
    required this.correct,
    required this.elapsed,
    required this.correctByLevel,
    required this.onRetry,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pct = total > 0 ? (correct / total) * 100 : 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Rezultati i Kuizit të Përgjithshëm')),
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
                    pct >= 70 ? Icons.emoji_events_rounded : Icons.bolt_rounded,
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
                    '$correct / $total sakte',
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.timer_outlined,
                            size: 20, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Koha totale: ${_formatElapsed(elapsed)}',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (final level in TimedLevel.values)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: level.color.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(level.icon, color: level.color, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(level.label,
                                  style: theme.textTheme.bodyMedium),
                            ),
                            Text(
                              '${correctByLevel[level.index]}/$_kQuestionsPerLevel',
                              style: theme.textTheme.titleSmall
                                  ?.copyWith(color: level.color),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
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

  String _message(double pct) {
    if (pct >= 90) return 'Shkëlqyeshëm! Njohuri të thella në fikh.';
    if (pct >= 70) return 'Shumë mirë! Vazhdo kështu.';
    if (pct >= 50) return 'Mirë, por ka vend për përmirësim.';
    return 'Vazhdo të mësosh — provo përsëri!';
  }
}
