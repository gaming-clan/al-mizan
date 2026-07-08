import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

String _levelLabelOf(String level) {
  if (level == 'beginner') return 'Fillestar';
  if (level == 'intermediate') return 'Mesatar';
  if (level == 'advanced') return 'Avancuar';
  return level;
}

/// Shown when all lessons of a level (across every module) are finished in
/// by-level mode: offers a timed general quiz of that level.
class LevelQuizDialog extends StatelessWidget {
  final String level;
  final VoidCallback onStartQuiz;

  const LevelQuizDialog({
    super.key,
    required this.level,
    required this.onStartQuiz,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.military_tech_rounded,
              size: 72, color: AppColors.accent),
          const SizedBox(height: 12),
          Text('Urime!',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(color: AppColors.accent)),
          const SizedBox(height: 8),
          Text(
            'Përfundove të gjitha mësimet e nivelit\n"${_levelLabelOf(level)}"!',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Provo tani kuizin e përgjithshëm me kohë të këtij niveli për të vënë në provë njohuritë.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: AppColors.success),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onStartQuiz();
                  },
                  icon: const Icon(Icons.timer_rounded),
                  label: const Text('Kuizi me Kohë i Nivelit'),
                ),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Më vonë'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LevelCompleteDialog extends StatelessWidget {
  final String level;
  /// Label of the next level that actually has lessons in this module
  /// (e.g. 'Mesatar', 'Avancuar'), or null if there isn't one.
  final String? nextLevelLabel;
  final VoidCallback? onContinue;
  const LevelCompleteDialog({
    super.key,
    required this.level,
    this.nextLevelLabel,
    this.onContinue,
  });

  String get _levelLabel {
    if (level == 'beginner') return 'Fillestar';
    if (level == 'intermediate') return 'Mesatar';
    if (level == 'advanced') return 'Avancuar';
    return level;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasNext = nextLevelLabel != null && onContinue != null;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.military_tech_rounded, size: 72, color: AppColors.accent),
          const SizedBox(height: 12),
          Text(
            'Urime!',
            style: theme.textTheme.headlineSmall?.copyWith(color: AppColors.accent),
          ),
          const SizedBox(height: 8),
          Text(
            'Ke përfunduar nivelin\n"$_levelLabel"!',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          if (hasNext) ...[
            const SizedBox(height: 8),
            Text(
              'Je gati për nivelin "$nextLevelLabel"!',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.success),
            ),
          ] else ...[
            const SizedBox(height: 8),
            Text(
              'Ke përfunduar të gjitha mësimet e këtij moduli! Ekspert i vërtetë!',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.success),
            ),
          ],
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (hasNext) onContinue?.call();
            },
            child: Text(
              hasNext ? 'Vazhdo me Nivelin $nextLevelLabel' : 'Shkëlqyeshëm!',
            ),
          ),
        ),
      ],
    );
  }
}
