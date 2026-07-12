import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/quiz_resume_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../modules/data/fiqh_data_source.dart';
import '../../modules/data/models/fiqh_models.dart';
import '../../modules/presentation/widgets/level_lessons.dart';
import '../providers/quiz_provider.dart';

/// All quiz questions (module quiz + pool quiz) from lessons of the given
/// level, across every module. Seeded so an interrupted quiz can be resumed
/// with the same set.
final levelQuizQuestionsProvider = FutureProvider.family<List<QuizQuestion>,
    (String, int)>((ref, args) async {
  final (level, seed) = args;
  final modules = await FiqhDataSource().loadAllModules();
  final questions = <QuizQuestion>[];
  for (final module in modules) {
    for (final lesson in module.lessons) {
      if (lesson.level == level) {
        questions.addAll(lesson.quiz);
        questions.addAll(lesson.poolQuiz);
      }
    }
  }
  questions.shuffle(Random(seed));
  return questions;
});

/// A quiz covering every lesson of one difficulty level, across all
/// modules — shown at the end of the level's lesson list.
class LevelQuizScreen extends ConsumerStatefulWidget {
  final String level;
  const LevelQuizScreen({super.key, required this.level});

  @override
  ConsumerState<LevelQuizScreen> createState() => _LevelQuizScreenState();
}

class _LevelQuizScreenState extends ConsumerState<LevelQuizScreen> {
  int _seed = QuizResumeService.newSeed();
  int _startIndex = 0;
  int _startCorrect = 0;

  String get _resumeKey => QuizResumeService.levelQuizKey(widget.level);

  @override
  void initState() {
    super.initState();
    _checkResume();
  }

  Future<void> _checkResume() async {
    final saved = await QuizResumeService.load(_resumeKey);
    if (saved == null || saved['seed'] is! int || !mounted) return;
    final index = (saved['index'] as num?)?.toInt() ?? 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Kuiz i papërfunduar'),
          content: Text(
              'E ke lënë përgjysmë kuizin e nivelit ${kLevelLabels[widget.level] ?? widget.level} te pyetja ${index + 1}. Dëshiron të vazhdosh ku mbete?'),
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
          });
        } else {
          QuizResumeService.clear(_resumeKey);
        }
      });
    });
  }

  void _persist(QuizState s, int total) {
    if (s.currentIndex < total) {
      QuizResumeService.save(_resumeKey, {
        'seed': _seed,
        'index': s.currentIndex,
        'correct': s.correctCount,
      });
    } else {
      QuizResumeService.clear(_resumeKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = kLevelLabels[widget.level] ?? widget.level;
    final color = kLevelColors[widget.level] ?? AppColors.primary;
    final questionsAsync =
        ref.watch(levelQuizQuestionsProvider((widget.level, _seed)));
    final quizState = ref.watch(quizProvider);
    final quizNotifier = ref.read(quizProvider.notifier);
    final theme = Theme.of(context);

    return questionsAsync.when(
      data: (rawQuestions) {
        if (rawQuestions.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text('Kuiz i Nivelit $label')),
            body: const Center(child: Text('Nuk ka pyetje të mjaftueshme.')),
          );
        }

        if (quizState.questions.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            quizNotifier.initialize(
              rawQuestions,
              seed: _seed,
              startIndex: _startIndex.clamp(0, rawQuestions.length - 1),
              startCorrect: _startCorrect,
            );
            _persist(ref.read(quizProvider), rawQuestions.length);
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final questions = quizState.questions;

        if (quizState.currentIndex >= questions.length) {
          final pct = (quizState.correctCount / questions.length) * 100;
          return Scaffold(
            appBar: AppBar(title: const Text('Rezultati')),
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        pct >= 70
                            ? Icons.emoji_events_rounded
                            : Icons.refresh_rounded,
                        size: 64,
                        color: pct >= 70 ? AppColors.accent : AppColors.warning,
                      ),
                      const SizedBox(height: 16),
                      Text('${pct.toStringAsFixed(0)}%',
                          style: theme.textTheme.headlineLarge),
                      const SizedBox(height: 8),
                      Text(
                        '${quizState.correctCount} / ${questions.length} sakte',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Niveli $label',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: color),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () {
                          QuizResumeService.clear(_resumeKey);
                          quizNotifier.reset();
                          setState(() {
                            _seed = QuizResumeService.newSeed();
                            _startIndex = 0;
                            _startCorrect = 0;
                          });
                        },
                        icon: const Icon(Icons.replay_rounded),
                        label: const Text('Provo Përsëri'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () {
                          quizNotifier.reset();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Kthehu'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        final q = questions[quizState.currentIndex];
        return Scaffold(
          appBar: AppBar(
            title: Text(
                'Niveli $label — ${quizState.currentIndex + 1}/${questions.length}'),
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
                          value: (quizState.currentIndex + 1) /
                              questions.length,
                          minHeight: 6,
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
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
                              _LevelQuizOption(
                                text: q.options[i],
                                index: i,
                                correctIndex: q.correctIndex,
                                selected: quizState.selectedOption,
                                answered: quizState.answered,
                                onTap: () => quizNotifier.selectOption(
                                    i, q.correctIndex),
                              ),
                              const SizedBox(height: 8),
                            ],
                            if (quizState.answered) ...[
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
                                  quizNotifier.nextQuestion();
                                  _persist(
                                      ref.read(quizProvider), questions.length);
                                },
                                child: Text(
                                  quizState.currentIndex + 1 < questions.length
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

class _LevelQuizOption extends StatelessWidget {
  final String text;
  final int index;
  final int correctIndex;
  final int? selected;
  final bool answered;
  final VoidCallback onTap;

  const _LevelQuizOption({
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
