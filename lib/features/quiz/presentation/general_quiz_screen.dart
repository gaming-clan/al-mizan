import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/quiz_resume_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../modules/data/fiqh_data_source.dart';
import '../../modules/data/models/fiqh_models.dart';
import '../providers/quiz_provider.dart';

/// Difficulty levels for the general quiz
enum QuizDifficulty {
  easy,
  medium,
  hard,
}

/// Provider that loads all quiz questions across all modules.
/// Seeded so an interrupted quiz can be resumed with the same questions.
final allQuestionsProvider = FutureProvider.family<List<QuizQuestion>,
    (QuizDifficulty, int)>((ref, args) async {
  final (difficulty, seed) = args;
  final dataSource = FiqhDataSource();
  final modules = await dataSource.loadAllModules();
  final allQuestions = <QuizQuestion>[];

  for (final module in modules) {
    for (final lesson in module.lessons) {
      allQuestions.addAll(lesson.quiz);
      allQuestions.addAll(lesson.poolQuiz);
    }
  }

  allQuestions.shuffle(Random(seed));
  final count = switch (difficulty) {
    QuizDifficulty.easy => 10,
    QuizDifficulty.medium => 20,
    QuizDifficulty.hard => 30,
  };
  return allQuestions.take(count).toList();
});

/// The difficulty selection + quiz screen
class GeneralQuizScreen extends ConsumerStatefulWidget {
  const GeneralQuizScreen({super.key});

  @override
  ConsumerState<GeneralQuizScreen> createState() => _GeneralQuizScreenState();
}

class _GeneralQuizScreenState extends ConsumerState<GeneralQuizScreen> {
  QuizDifficulty? _selectedDifficulty;
  int _seed = QuizResumeService.newSeed();
  int _startIndex = 0;
  int _startCorrect = 0;

  @override
  void initState() {
    super.initState();
    _checkResume();
  }

  Future<void> _checkResume() async {
    final saved = await QuizResumeService.load(QuizResumeService.generalKey);
    if (saved == null || saved['seed'] is! int || !mounted) return;
    final diffIdx = ((saved['difficulty'] as num?)?.toInt() ?? 0)
        .clamp(0, QuizDifficulty.values.length - 1);
    final index = (saved['index'] as num?)?.toInt() ?? 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Kuiz i papërfunduar'),
          content: Text(
              'E ke lënë përgjysmë një kuiz të përgjithshëm te pyetja ${index + 1}. Dëshiron të vazhdosh ku mbete?'),
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
            _selectedDifficulty = QuizDifficulty.values[diffIdx];
          });
        } else {
          QuizResumeService.clear(QuizResumeService.generalKey);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedDifficulty == null) {
      return _DifficultySelector(
        onSelect: (d) => setState(() {
          _seed = QuizResumeService.newSeed();
          _startIndex = 0;
          _startCorrect = 0;
          _selectedDifficulty = d;
        }),
      );
    }

    return _GeneralQuizBody(
      key: ValueKey('general_$_seed'),
      difficulty: _selectedDifficulty!,
      seed: _seed,
      startIndex: _startIndex,
      startCorrect: _startCorrect,
      onNewSeed: () => setState(() {
        _seed = QuizResumeService.newSeed();
        _startIndex = 0;
        _startCorrect = 0;
      }),
    );
  }
}

class _DifficultySelector extends StatelessWidget {
  final void Function(QuizDifficulty) onSelect;
  const _DifficultySelector({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Kuiz i Përgjithshëm')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 20),
            Icon(Icons.quiz_rounded,
                size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Testo njohuritë e tua',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Pyetje nga të gjitha modulet e fikhut',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Text('Zgjidh nivelin:', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            _DifficultyCard(
              title: 'I Lehtë',
              subtitle: '10 pyetje — për fillestarë',
              icon: Icons.sentiment_satisfied_rounded,
              color: AppColors.success,
              onTap: () => onSelect(QuizDifficulty.easy),
            ),
            const SizedBox(height: 12),
            _DifficultyCard(
              title: 'Mesatar',
              subtitle: '20 pyetje — nivel i ndërmjetëm',
              icon: Icons.trending_up_rounded,
              color: AppColors.accent,
              onTap: () => onSelect(QuizDifficulty.medium),
            ),
            const SizedBox(height: 12),
            _DifficultyCard(
              title: 'I Vështirë',
              subtitle: '30 pyetje — për të avancuar',
              icon: Icons.local_fire_department_rounded,
              color: AppColors.error,
              onTap: () => onSelect(QuizDifficulty.hard),
            ),
            const SizedBox(height: 28),
            const Divider(),
            const SizedBox(height: 12),
            _DifficultyCard(
              title: 'Kuiz i Përgjithshëm',
              subtitle: '45 pyetje me kohë — 3 pjesë × 15 pyetje',
              icon: Icons.bolt_rounded,
              color: AppColors.primary,
              onTap: () => context.push('/general-quiz-full'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DifficultyCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(subtitle,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _GeneralQuizBody extends ConsumerWidget {
  final QuizDifficulty difficulty;
  final int seed;
  final int startIndex;
  final int startCorrect;
  final VoidCallback onNewSeed;

  const _GeneralQuizBody({
    super.key,
    required this.difficulty,
    required this.seed,
    required this.startIndex,
    required this.startCorrect,
    required this.onNewSeed,
  });

  void _persist(QuizState s, int total) {
    if (s.currentIndex < total) {
      QuizResumeService.save(QuizResumeService.generalKey, {
        'difficulty': difficulty.index,
        'seed': seed,
        'index': s.currentIndex,
        'correct': s.correctCount,
      });
    } else {
      QuizResumeService.clear(QuizResumeService.generalKey);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsAsync = ref.watch(allQuestionsProvider((difficulty, seed)));
    final quizState = ref.watch(quizProvider);
    final quizNotifier = ref.read(quizProvider.notifier);
    final theme = Theme.of(context);

    return questionsAsync.when(
      data: (rawQuestions) {
        if (rawQuestions.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Kuiz')),
            body: const Center(child: Text('Nuk ka pyetje të mjaftueshme.')),
          );
        }

        // Initialize shuffled questions
        if (quizState.questions.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            quizNotifier.initialize(
              rawQuestions,
              seed: seed,
              startIndex: startIndex.clamp(0, rawQuestions.length - 1),
              startCorrect: startCorrect,
            );
            _persist(ref.read(quizProvider), rawQuestions.length);
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final questions = quizState.questions;

        // Result screen
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
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.accent),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Niveli i arritur:',
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                            Text(
                              _levelAchieved(pct),
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(color: AppColors.accent),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _resultMessage(pct),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () {
                          QuizResumeService.clear(
                              QuizResumeService.generalKey);
                          quizNotifier.reset();
                          onNewSeed();
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

        // Question screen
        final q = questions[quizState.currentIndex];
        return Scaffold(
          appBar: AppBar(
            title: Text(
                'Pyetja ${quizState.currentIndex + 1}/${questions.length}'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinearProgressIndicator(
                    value: (quizState.currentIndex + 1) / questions.length,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView(
                      children: [
                        Text(q.question,
                            style: theme.textTheme.headlineSmall),
                        const SizedBox(height: 24),
                        for (int i = 0; i < q.options.length; i++) ...[
                          _OptionButton(
                            text: q.options[i],
                            index: i,
                            correctIndex: q.correctIndex,
                            selected: quizState.selectedOption,
                            answered: quizState.answered,
                            onTap: () =>
                                quizNotifier.selectOption(i, q.correctIndex),
                          ),
                          const SizedBox(height: 8),
                        ],
                        if (quizState.answered) ...[
                          const SizedBox(height: 16),
                          Card(
                            color: AppColors.primary.withValues(alpha: 0.08),
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
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Gabim: $e'))),
    );
  }

  String _resultMessage(double pct) {
    if (pct >= 90) return 'Shkëlqyeshëm! Ke njohuri të thella në fikh.';
    if (pct >= 70) return 'Shumë mirë! Vazhdo të mësosh.';
    if (pct >= 50) return 'Mirë, por ka vend për përmirësim.';
    return 'Duhet të studiosh më shumë. Mos u dorëzo!';
  }

  String _levelAchieved(double pct) {
    if (pct >= 80) return 'Avancuar';
    if (pct >= 60) return 'Mesatar';
    if (pct >= 40) return 'Fillestar';
    return 'Nën Fillestar';
  }
}

class _OptionButton extends StatelessWidget {
  final String text;
  final int index;
  final int correctIndex;
  final int? selected;
  final bool answered;
  final VoidCallback onTap;

  const _OptionButton({
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
