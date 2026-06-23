import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/level_complete_dialog.dart';
import '../../home/providers/home_provider.dart';
import '../../modules/providers/module_provider.dart';
import '../providers/quiz_provider.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final String moduleId;
  final String lessonId;
  const QuizScreen({super.key, required this.moduleId, required this.lessonId});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  bool _resultSaved = false;

  Future<void> _saveResult(double pct, String lessonLevel) async {
    if (_resultSaved) return;
    _resultSaved = true;

    final db = ref.read(databaseProvider);
    final quizState = ref.read(quizProvider);

    await db.saveQuizResult(
      lessonId: widget.lessonId,
      totalQuestions: quizState.questions.length,
      correctAnswers: quizState.correctCount,
    );

    if (pct >= 60) {
      await db.markLessonCompleted(widget.lessonId, widget.moduleId);
      await db.recordLearningDay();
    }

    ref.invalidate(lessonProgressProvider(widget.moduleId));

    if (pct >= 60 && mounted) {
      try {
        final progress =
            await ref.read(lessonProgressProvider(widget.moduleId).future);
        final module =
            await ref.read(moduleProvider(widget.moduleId).future);
        final levelLessons =
            module.lessons.where((l) => l.level == lessonLevel).toList();
        final allComplete = levelLessons.isNotEmpty &&
            levelLessons.every((l) => progress[l.id]?.isComplete == true);
        if (allComplete && mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => LevelCompleteDialog(level: lessonLevel),
          );
        }
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final moduleAsync = ref.watch(moduleProvider(widget.moduleId));
    final quizState = ref.watch(quizProvider);
    final quizNotifier = ref.read(quizProvider.notifier);
    final theme = Theme.of(context);

    return moduleAsync.when(
      data: (module) {
        final lesson = module.lessons.firstWhere(
          (l) => l.id == widget.lessonId,
          orElse: () => module.lessons.first,
        );
        final rawQuestions = lesson.quiz;
        if (rawQuestions.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Kuiz')),
            body: const Center(child: Text('Nuk ka pyetje kuizi.')),
          );
        }

        if (quizState.questions.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            quizNotifier.initialize(rawQuestions);
          });
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        final questions = quizState.questions;

        if (quizState.currentIndex >= questions.length) {
          final pct = questions.isEmpty
              ? 0.0
              : (quizState.correctCount / questions.length) * 100;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _saveResult(pct, lesson.level);
          });

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
                      if (pct >= 60) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Mësimi u shënua automatikisht si i përfunduar!',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: AppColors.success),
                          textAlign: TextAlign.center,
                        ),
                      ],
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

        final q = questions[quizState.currentIndex];
        return Scaffold(
          appBar: AppBar(
            title: Text(
                'Pyetja ${quizState.currentIndex + 1}/${questions.length}'),
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
                      LinearProgressIndicator(
                        value:
                            (quizState.currentIndex + 1) / questions.length,
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.1),
                      ),
                      const SizedBox(height: 24),
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
