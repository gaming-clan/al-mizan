import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/quiz_resume_service.dart';
import 'timed_challenge_screen.dart';

/// A fixed number of questions taken from each level of the combined test.
const _kQuestionsPerLevel = 15;

/// The General Quiz's full timed test: all three difficulty levels back to
/// back (15 questions each, 45 total), auto-advancing between levels with
/// the same per-question countdown (shrinking as difficulty rises) used by
/// the standalone Timed Challenge — but run here as one continuous test
/// rather than a user-picked single level.
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
  TimedLevel _startLevel = TimedLevel.beginner;
  int _startIndex = 0;
  int _startCorrect = 0;
  int _startWrong = 0;
  int _startTimeouts = 0;
  List<Map<String, dynamic>> _startResults = const [];

  @override
  void initState() {
    super.initState();
    _checkResume();
  }

  Future<void> _checkResume() async {
    final saved =
        await QuizResumeService.load(QuizResumeService.generalFullKey);
    if (saved == null || saved['seed'] is! int || !mounted) return;
    final levelName = saved['level'] as String?;
    final level =
        TimedLevel.values.where((l) => l.name == levelName).firstOrNull;
    if (level == null) return;
    final index = (saved['index'] as num?)?.toInt() ?? 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Test i papërfunduar'),
          content: Text(
              'E ke lënë përgjysmë Kuizin e Përgjithshëm (${level.label}) te pyetja ${index + 1}. Dëshiron të vazhdosh ku mbete?'),
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
            _startLevel = level;
            _startIndex = index;
            _startCorrect = (saved['correct'] as num?)?.toInt() ?? 0;
            _startWrong = (saved['wrong'] as num?)?.toInt() ?? 0;
            _startTimeouts = (saved['timeouts'] as num?)?.toInt() ?? 0;
            _startResults = [
              for (final r in (saved['results'] as List? ?? const []))
                Map<String, dynamic>.from(r as Map),
            ];
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
    _startLevel = TimedLevel.beginner;
    _startIndex = 0;
    _startCorrect = 0;
    _startWrong = 0;
    _startTimeouts = 0;
    _startResults = const [];
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
    return TimedQuizBody(
      key: ValueKey('general_full_$_seed'),
      startLevel: _startLevel,
      seed: _seed,
      resumeKey: QuizResumeService.generalFullKey,
      title: 'Kuiz i Përgjithshëm',
      resultTitle: 'Rezultati i Kuizit të Përgjithshëm',
      exitLabel: 'Kthehu',
      questionCountFor: (_) => _kQuestionsPerLevel,
      startIndex: _startIndex,
      startCorrect: _startCorrect,
      startWrong: _startWrong,
      startTimeouts: _startTimeouts,
      startResults: _startResults,
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
                  '3 pjesë — Fillestar, Mesatar, Avancuar — 15 pyetje secila, gjithsej 45 pyetje. Pas çdo pjese kalon automatikisht te pjesa tjetër. I gjithë testi është me kohë: sa më i lartë niveli, aq më pak kohë ke për çdo pyetje.',
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
                          '$_kQuestionsPerLevel pyetje · ${level.secondsPerQuestion}s/pyetje',
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
