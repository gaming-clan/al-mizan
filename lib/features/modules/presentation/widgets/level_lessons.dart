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
            child: ChoiceChip(
              label: SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      kLevelIcons[level],
                      size: 15,
                      color: level == selectedLevel
                          ? kLevelColors[level]
                          : cs.onSurfaceVariant,
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
              selected: level == selectedLevel,
              onSelected: (_) => onLevelChanged(level),
              showCheckmark: false,
            ),
          ),
          if (level != kLevels.last) const SizedBox(width: 8),
        ],
      ],
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
        onTap: () =>
            context.push('/lesson/${module.moduleId}/${lesson.id}'),
      ),
    );
  }
}
