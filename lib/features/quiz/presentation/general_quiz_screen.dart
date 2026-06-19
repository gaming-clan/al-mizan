import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

/// Provider that loads all quiz questions across all modules
final allQuestionsProvider =
    FutureProvider.family<List<QuizQuestion>, QuizDifficulty>((ref, difficulty) async {
  final dataSource = FiqhDataSource();
  final modules = await dataSource.loadAllModules();
  final allQuestions = <QuizQuestion>[];

  for (final module in modules) {
    for (final lesson in module.lessons) {
      allQuestions.addAll(lesson.quiz);
    }
  }

  // Filter by difficulty based on question count
  switch (difficulty) {
    case QuizDifficulty.easy:
      // 10 questions
      allQuestions.shuffle(Random());
      return allQuestions.take(10).toList();
    case QuizDifficulty.medium:
      // 20 questions
      allQuestions.shuffle(Random());
      return allQuestions.take(20).toList();
    case QuizDifficulty.hard:
      // 30 questions (all available, shuffled)
      allQuestions.shuffle(Random());
      return allQuestions.take(30).toList();
  }
});

/// The difficulty selection + quiz screen
class GeneralQuizScreen extends ConsumerStatefulWidget {
  const GeneralQuizScreen({super.key});

  @override
  ConsumerState<GeneralQuizScreen> createState() => _GeneralQuizScreenState();
}

class _GeneralQuizScreenState extends ConsumerState<GeneralQuizScreen> {
  QuizDifficulty? _selectedDifficulty;

  @override
  Widget build(BuildContext context) {
    if (_selectedDifficulty == null) {
      return _DifficultySelector(
        onSelect: (d) => setState(() => _selectedDifficulty = d),
      );
    }

    return _GeneralQuizBody(difficulty: _selectedDifficulty!);
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Icon(Icons.quiz_rounded, size: 64, color: AppColors.primary),
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
            ],
          ),
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
              Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _GeneralQuizBody extends ConsumerWidget {
  final QuizDifficulty difficulty;
  const _GeneralQuizBody({required this.difficulty});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsAsync = ref.watch(allQuestionsProvider(difficulty));
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
            quizNotifier.initialize(rawQuestions);
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
                      const SizedBox(height: 8),
                      Text(
                        _resultMessage(pct),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
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
                  Text(q.question, style: theme.textTheme.headlineSmall),
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
                    const Spacer(),
                    FilledButton(
                      onPressed: quizNotifier.nextQuestion,
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
