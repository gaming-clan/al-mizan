import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/fiqh_models.dart';
import '../../providers/module_provider.dart';

const kLevels = ['beginner', 'intermediate', 'advanced'];

const kLevelLabels = {
  'beginner': 'Fillestar',
  'intermediate': 'Mesatar',
  'advanced': 'Avancuar',
};

const kLevelColors = {
  'beginner': AppColors.success,
  'intermediate': AppColors.warning,
  'advanced': AppColors.error,
};

const kLevelIcons = {
  'beginner': Icons.emoji_events_rounded,
  'intermediate': Icons.trending_up_rounded,
  'advanced': Icons.local_fire_department_rounded,
};

/// Collects (module, lesson) pairs of the given level across all modules,
/// preserving module order.
List<(FiqhModule, Lesson)> lessonsOfLevel(
    List<FiqhModule> modules, String level) {
  final entries = <(FiqhModule, Lesson)>[];
  for (final module in modules) {
    for (final lesson in module.lessons) {
      if (lesson.level == level) entries.add((module, lesson));
    }
  }
  return entries;
}

/// Row of the three level chips (Fillestar / Mesatar / Avancuar).
class LevelChipsRow extends StatelessWidget {
  final String selectedLevel;
  final void Function(String) onLevelChanged;

  const LevelChipsRow({
    super.key,
    required this.selectedLevel,
    required this.onLevelChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        for (final level in kLevels) ...[
          Expanded(
            child: Builder(builder: (context) {
              final isSelected = level == selectedLevel;
              final levelColor = kLevelColors[level]!;
              return ChoiceChip(
                label: SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        kLevelIcons[level],
                        size: 15,
                        color:
                            isSelected ? levelColor : cs.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          kLevelLabels[level]!,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                selected: isSelected,
                onSelected: (_) => onLevelChanged(level),
                showCheckmark: false,
                backgroundColor: cs.surfaceContainerLowest,
                selectedColor: levelColor.withValues(alpha: 0.15),
                side: BorderSide(
                  color: isSelected ? levelColor : cs.outlineVariant,
                  width: isSelected ? 1.5 : 1,
                ),
                labelStyle: TextStyle(
                  color: isSelected ? levelColor : cs.onSurfaceVariant,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              );
            }),
          ),
          if (level != kLevels.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

/// Green "Nivel i përfunduar" chip, shown only when every lesson of [level]
/// across all modules is complete. Renders nothing otherwise.
class LevelCompletedBadge extends ConsumerWidget {
  final List<FiqhModule> modules;
  final String level;

  /// Applied only when the badge is visible.
  final EdgeInsetsGeometry? padding;

  const LevelCompletedBadge({
    super.key,
    required this.modules,
    required this.level,
    this.padding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = lessonsOfLevel(modules, level);
    if (entries.isEmpty) return const SizedBox.shrink();
    for (final (module, lesson) in entries) {
      final progress =
          ref.watch(lessonProgressProvider(module.moduleId)).valueOrNull;
      if (progress == null || progress[lesson.id]?.isComplete != true) {
        return const SizedBox.shrink();
      }
    }

    final theme = Theme.of(context);
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.success),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_rounded,
              size: 14, color: AppColors.success),
          const SizedBox(width: 4),
          Text(
            'Nivel i përfunduar',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
    if (padding == null) return chip;
    return Padding(
      padding: padding!,
      child: Align(alignment: Alignment.centerLeft, child: chip),
    );
  }
}

/// Full-width button that starts the first lesson of [level] (in level
/// browsing mode, so "next lesson" follows the same level across modules).
class LevelStartButton extends StatelessWidget {
  final List<FiqhModule> modules;
  final String level;
  final Color color;

  const LevelStartButton({
    super.key,
    required this.modules,
    required this.level,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final entries = lessonsOfLevel(modules, level);
    if (entries.isEmpty) return const SizedBox.shrink();
    final first = entries.first;
    final label = kLevelLabels[level] ?? level;
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () => context.push(
            '/lesson/${first.$1.moduleId}/${first.$2.id}?mode=level'),
        icon: const Icon(Icons.play_circle_fill_rounded),
        label: Text('Fillo mësimet e nivelit $label'),
      ),
    );
  }
}

/// Button shown at the end of a level's lesson list — quizzes every lesson
/// of that level across all modules.
class LevelQuizButton extends StatelessWidget {
  final String level;

  const LevelQuizButton({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final label = kLevelLabels[level] ?? level;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: OutlinedButton.icon(
        onPressed: () => context.push('/level-quiz/$level'),
        icon: const Icon(Icons.quiz_rounded),
        label: Text('Kuiz i Nivelit $label'),
      ),
    );
  }
}

/// A lesson tile in the by-level list: shows the module name as subtitle
/// and a completion check when the lesson is done.
class LevelLessonTile extends ConsumerWidget {
  final FiqhModule module;
  final Lesson lesson;
  final int index;
  final Color color;

  const LevelLessonTile({
    super.key,
    required this.module,
    required this.lesson,
    required this.index,
    required this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final progressAsync = ref.watch(lessonProgressProvider(module.moduleId));
    final status = progressAsync.valueOrNull?[lesson.id];
    final isComplete = status?.isComplete ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isComplete
              ? AppColors.success.withValues(alpha: 0.15)
              : color.withValues(alpha: 0.12),
          child: isComplete
              ? const Icon(Icons.check_rounded,
                  color: AppColors.success, size: 20)
              : Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        title: Text(
          lesson.titleSq,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Icon(Icons.menu_book_rounded,
                size: 12, color: cs.onSurfaceVariant),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                module.titleSq,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  color: cs.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () => context
            .push('/lesson/${module.moduleId}/${lesson.id}?mode=level'),
      ),
    );
  }
}
