import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../modules/data/models/fiqh_models.dart';
import '../../modules/providers/module_provider.dart';

class ModuleQuizScreen extends ConsumerStatefulWidget {
  final String moduleId;
  const ModuleQuizScreen({super.key, required this.moduleId});

  @override
  ConsumerState<ModuleQuizScreen> createState() => _ModuleQuizScreenState();
}

class _ModuleQuizScreenState extends ConsumerState<ModuleQuizScreen> {
  static const _levels = ['beginner', 'intermediate', 'advanced'];
  static const _levelLabels = ['Fillestar', 'Mesatar', 'Avancuar'];
  static const _passThreshold = 60.0;

  // 'loading' | 'level_intro' | 'question' | 'level_result' | 'final'
  String _phase = 'loading';
  int _levelIndex = 0;

  List<List<QuizQuestion>> _questionsByLevel = [[], [], []];
  int _currentQ = 0;
  int? _selected;
  bool _answered = false;
  final List<int> _correct = [0, 0, 0];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final module = await ref.read(moduleProvider(widget.moduleId).future);
    final rng = Random();

    final byLevel = _levels.map((level) {
      final questions = module.lessons
          .where((l) => l.level == level)
          .expand((l) => l.quiz)
          .toList();
      questions.shuffle(rng);
      return questions.map((q) {
        final correctAnswer = q.options[q.correctIndex];
        final shuffled = List<String>.from(q.options)..shuffle(rng);
        return QuizQuestion(
          question: q.question,
          options: shuffled,
          correctIndex: shuffled.indexOf(correctAnswer),
          explanation: q.explanation,
        );
      }).toList();
    }).toList();

    if (!mounted) return;
    final firstNonEmpty = byLevel.indexWhere((q) => q.isNotEmpty);
    setState(() {
      _questionsByLevel = byLevel;
      if (firstNonEmpty >= 0) {
        _levelIndex = firstNonEmpty;
        _phase = 'level_intro';
      } else {
        _phase = 'final';
      }
    });
  }

  List<QuizQuestion> get _currentQuestions =>
      _levelIndex < _questionsByLevel.length
          ? _questionsByLevel[_levelIndex]
          : [];

  int get _totalQuestions =>
      _questionsByLevel.fold(0, (sum, q) => sum + q.length);

  int get _totalCorrect => _correct.fold(0, (sum, c) => sum + c);

  void _startLevel() => setState(() {
        _phase = 'question';
        _currentQ = 0;
        _selected = null;
        _answered = false;
      });

  void _selectOption(int index, int correctIndex) {
    if (_answered) return;
    setState(() {
      _selected = index;
      _answered = true;
      if (index == correctIndex) _correct[_levelIndex]++;
    });
  }

  void _nextQuestion() {
    if (_currentQ + 1 < _currentQuestions.length) {
      setState(() {
        _currentQ++;
        _selected = null;
        _answered = false;
      });
    } else {
      setState(() => _phase = 'level_result');
    }
  }

  void _goToNext() {
    int next = _levelIndex + 1;
    while (next < _questionsByLevel.length && _questionsByLevel[next].isEmpty) {
      next++;
    }
    if (next < _questionsByLevel.length) {
      setState(() {
        _levelIndex = next;
        _phase = 'level_intro';
        _currentQ = 0;
        _selected = null;
        _answered = false;
      });
    } else {
      setState(() => _phase = 'final');
    }
  }

  String _levelAchieved() {
    for (int i = _levels.length - 1; i >= 0; i--) {
      if (i < _questionsByLevel.length && _questionsByLevel[i].isNotEmpty) {
        final total = _questionsByLevel[i].length;
        final pct = (_correct[i] / total) * 100;
        if (pct >= _passThreshold) return _levelLabels[i];
      }
    }
    return 'Nën Fillestar (studioni më shumë!)';
  }

  @override
  Widget build(BuildContext context) {
    if (_phase == 'loading') {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_phase == 'level_intro') return _buildLevelIntro();
    if (_phase == 'question') return _buildQuestion();
    if (_phase == 'level_result') return _buildLevelResult();
    return _buildFinalResult();
  }

  Widget _buildLevelIntro() {
    final theme = Theme.of(context);
    final label = _levelLabels[_levelIndex];
    final icons = [
      Icons.emoji_events_rounded,
      Icons.trending_up_rounded,
      Icons.local_fire_department_rounded,
    ];
    final colors = [AppColors.success, AppColors.warning, AppColors.error];

    return Scaffold(
      appBar: AppBar(title: const Text('Kuiz i Modulit')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icons[_levelIndex], size: 80, color: colors[_levelIndex]),
              const SizedBox(height: 24),
              Text('Niveli $label',
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text(
                '${_currentQuestions.length} pyetje',
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: _startLevel,
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Fillo Nivelin'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion() {
    final theme = Theme.of(context);
    final q = _currentQuestions[_currentQ];
    final label = _levelLabels[_levelIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('$label — ${_currentQ + 1}/${_currentQuestions.length}'),
        automaticallyImplyLeading: false,
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
                    value: (_currentQ + 1) / _currentQuestions.length,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  ),
                  const SizedBox(height: 24),
                  Text(q.question, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 24),
                  for (int i = 0; i < q.options.length; i++) ...[
                    _OptionTile(
                      text: q.options[i],
                      index: i,
                      correctIndex: q.correctIndex,
                      selected: _selected,
                      answered: _answered,
                      onTap: () => _selectOption(i, q.correctIndex),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (_answered) ...[
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
                      onPressed: _nextQuestion,
                      child: Text(
                        _currentQ + 1 < _currentQuestions.length
                            ? 'Pyetja Tjetër'
                            : 'Shiko Rezultatin e Nivelit',
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
  }

  Widget _buildLevelResult() {
    final theme = Theme.of(context);
    final correct = _correct[_levelIndex];
    final total = _currentQuestions.length;
    final pct = total > 0 ? (correct / total) * 100 : 0.0;
    final passed = pct >= _passThreshold;
    final label = _levelLabels[_levelIndex];

    int next = _levelIndex + 1;
    while (
        next < _questionsByLevel.length && _questionsByLevel[next].isEmpty) {
      next++;
    }
    final hasNext = next < _questionsByLevel.length;
    final nextLabel = hasNext ? _levelLabels[next] : null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Rezultati — Niveli $label'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  passed
                      ? Icons.military_tech_rounded
                      : Icons.refresh_rounded,
                  size: 80,
                  color: passed ? AppColors.accent : AppColors.warning,
                ),
                const SizedBox(height: 16),
                Text('Niveli $label',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Text('${pct.toStringAsFixed(0)}%',
                    style: theme.textTheme.headlineLarge),
                const SizedBox(height: 8),
                Text('$correct / $total sakte',
                    style: theme.textTheme.bodyLarge),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: (passed ? AppColors.success : AppColors.warning)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color:
                            passed ? AppColors.success : AppColors.warning),
                  ),
                  child: Text(
                    passed
                        ? 'Niveli i kaluar'
                        : 'Niveli jo i kaluar (duhen 60%)',
                    style: TextStyle(
                      color: passed ? AppColors.success : AppColors.warning,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                if (hasNext)
                  FilledButton.icon(
                    onPressed: _goToNext,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: Text('Niveli ${nextLabel!}'),
                  )
                else
                  FilledButton(
                    onPressed: () => setState(() => _phase = 'final'),
                    child: const Text('Shiko Rezultatin Final'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFinalResult() {
    final theme = Theme.of(context);
    final total = _totalQuestions;
    final correct = _totalCorrect;
    final pct = total > 0 ? (correct / total) * 100 : 0.0;
    final achieved = _levelAchieved();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rezultati Final'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.workspace_premium_rounded,
                    size: 80, color: AppColors.accent),
                const SizedBox(height: 16),
                Text(
                  'Kuizi i Modulit Përfundoi!',
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text('${pct.toStringAsFixed(0)}%',
                    style: theme.textTheme.headlineLarge),
                const SizedBox(height: 4),
                Text('$correct / $total sakte gjithsej',
                    style: theme.textTheme.bodyLarge),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      AppColors.accent.withValues(alpha: 0.15),
                      AppColors.primary.withValues(alpha: 0.08),
                    ]),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.accent),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Niveli i arritur:',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        achieved,
                        style: theme.textTheme.headlineSmall
                            ?.copyWith(color: AppColors.accent),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                for (int i = 0; i < _levels.length; i++)
                  if (_questionsByLevel[i].isNotEmpty) ...[
                    _LevelBreakdownRow(
                      label: _levelLabels[i],
                      correct: _correct[i],
                      total: _questionsByLevel[i].length,
                      passThreshold: _passThreshold,
                    ),
                    const SizedBox(height: 6),
                  ],
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Kthehu'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LevelBreakdownRow extends StatelessWidget {
  final String label;
  final int correct;
  final int total;
  final double passThreshold;

  const _LevelBreakdownRow({
    required this.label,
    required this.correct,
    required this.total,
    required this.passThreshold,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? (correct / total) * 100 : 0.0;
    final passed = pct >= passThreshold;
    return Row(
      children: [
        Icon(
          passed ? Icons.check_circle_rounded : Icons.cancel_rounded,
          size: 18,
          color: passed ? AppColors.success : AppColors.error,
        ),
        const SizedBox(width: 8),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const Spacer(),
        Text(
          '$correct/$total (${pct.toStringAsFixed(0)}%)',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String text;
  final int index;
  final int correctIndex;
  final int? selected;
  final bool answered;
  final VoidCallback onTap;

  const _OptionTile({
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
