import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class LevelCompleteDialog extends StatelessWidget {
  final String level;
  const LevelCompleteDialog({super.key, required this.level});

  String get _levelLabel {
    if (level == 'beginner') return 'Fillestar';
    if (level == 'intermediate') return 'Mesatar';
    if (level == 'advanced') return 'Avancuar';
    return level;
  }

  String? get _nextLevelLabel {
    if (level == 'beginner') return 'Mesatar';
    if (level == 'intermediate') return 'Avancuar';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasNext = _nextLevelLabel != null;

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
              'Je gati për nivelin "$_nextLevelLabel"!',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.success),
            ),
          ] else ...[
            const SizedBox(height: 8),
            Text(
              'Ke arritur nivelin maksimal! Ekspert i vërtetë!',
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
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              hasNext ? 'Vazhdo me Nivelin $_nextLevelLabel' : 'Shkellqyeshëm!',
            ),
          ),
        ),
      ],
    );
  }
}
