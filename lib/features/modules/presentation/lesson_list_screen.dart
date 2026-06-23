import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../data/models/fiqh_models.dart';
import '../providers/module_provider.dart';

const _levels = ['beginner', 'intermediate', 'advanced'];

const _levelLabels = {
  'beginner': 'Fillestar',
  'intermediate': 'Mesatar',
  'advanced': 'Avancuar',
};

const _levelColors = {
  'beginner': AppColors.success,
  'intermediate': AppColors.warning,
  'advanced': AppColors.error,
};

const _levelIcons = {
  'beginner': Icons.emoji_events_rounded,
  'intermediate': Icons.trending_up_rounded,
  'advanced': Icons.local_fire_department_rounded,
};

class LessonListScreen extends ConsumerWidget {
  final String moduleId;
  const LessonListScreen({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moduleAsync = ref.watch(moduleProvider(moduleId));
    final progressAsync = ref.watch(lessonProgressProvider(moduleId));

    return Scaffold(
      appBar: moduleAsync.when(
        data: (m) => AppBar(title: Text(m.titleSq)),
        loading: () => AppBar(title: const Text('...')),
        error: (_, __) => AppBar(title: const Text('Gabim')),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: moduleAsync.when(
        data: (module) => progressAsync.when(
          data: (progress) =>
              _LeveledList(module: module, progress: progress, moduleId: moduleId),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) =>
              _LeveledList(module: module, progress: const {}, moduleId: moduleId),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(error: e),
      ),
        ),
      ),
    );
  }
}

class _LeveledList extends StatelessWidget {
  final FiqhModule module;
  final Map<String, dynamic> progress;
  final String moduleId;

  const _LeveledList({
    required this.module,
    required this.progress,
    required this.moduleId,
  });

  bool _isLevelUnlocked(String level, Map<String, dynamic> progress) {
    if (level == 'beginner') return true;
    final prerequisite = level == 'intermediate' ? 'beginner' : 'intermediate';
    final prereqLessons =
        module.lessons.where((l) => l.level == prerequisite).toList();
    if (prereqLessons.isEmpty) return true;
    return prereqLessons.every((l) {
      final s = progress[l.id];
      return s != null && s.isComplete;
    });
  }

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<Lesson>>{};
    for (final level in _levels) {
      final lessons = module.lessons.where((l) => l.level == level).toList();
      if (lessons.isNotEmpty) grouped[level] = lessons;
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        for (final level in _levels)
          if (grouped.containsKey(level))
            _LevelSection(
              level: level,
              lessons: grouped[level]!,
              progress: progress,
              unlocked: _isLevelUnlocked(level, progress),
              moduleId: moduleId,
            ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          child: OutlinedButton.icon(
            onPressed: () => context.push('/module-quiz/$moduleId'),
            icon: const Icon(Icons.quiz_rounded),
            label: const Text('Kuiz i Modulit (3 Nivele)'),
          ),
        ),
      ],
    );
  }
}

class _LevelSection extends StatelessWidget {
  final String level;
  final List<Lesson> lessons;
  final Map<String, dynamic> progress;
  final bool unlocked;
  final String moduleId;

  const _LevelSection({
    required this.level,
    required this.lessons,
    required this.progress,
    required this.unlocked,
    required this.moduleId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final color = _levelColors[level] ?? AppColors.info;
    final label = _levelLabels[level] ?? level;
    final icon = _levelIcons[level] ?? Icons.school_rounded;

    final completed =
        lessons.where((l) => progress[l.id]?.isComplete == true).length;
    final total = lessons.length;
    final ratio = total > 0 ? completed / total : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
          child: Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              const Spacer(),
              Text(
                '$completed/$total',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              if (!unlocked) ...[
                const SizedBox(width: 8),
                Icon(Icons.lock_rounded, size: 14, color: cs.onSurfaceVariant),
              ],
            ],
          ),
        ),

        // Progress bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6,
              backgroundColor: cs.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                unlocked ? color : cs.outlineVariant,
              ),
            ),
          ),
        ),

        if (!unlocked)
          _LockedOverlay(level: level)
        else
          ...lessons.asMap().entries.map((entry) {
            final index = entry.key;
            final lesson = entry.value;
            final status = progress[lesson.id];
            final isRead = status?.isRead ?? false;
            final quizPassed = status?.quizPassed ?? false;

            return _LessonTile(
              lesson: lesson,
              index: index,
              isRead: isRead,
              quizPassed: quizPassed,
              moduleId: moduleId,
            );
          }),

        const SizedBox(height: 8),
      ],
    );
  }
}

class _LockedOverlay extends StatelessWidget {
  final String level;
  const _LockedOverlay({required this.level});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final prereq = level == 'intermediate' ? 'Fillestar' : 'Mesatar';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_rounded, color: cs.onSurfaceVariant, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nivel i kyçur',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Përfundo të gjitha mësimet e nivelit $prereq (lexo + kalo kuizin me ≥60%) për të hapur këtë nivel.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  final Lesson lesson;
  final int index;
  final bool isRead;
  final bool quizPassed;
  final String moduleId;

  const _LessonTile({
    required this.lesson,
    required this.index,
    required this.isRead,
    required this.quizPassed,
    required this.moduleId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isComplete = isRead && quizPassed;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isComplete
              ? AppColors.success.withValues(alpha: 0.15)
              : cs.primaryContainer.withValues(alpha: 0.5),
          child: isComplete
              ? const Icon(Icons.check_rounded,
                  color: AppColors.success, size: 20)
              : Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: cs.primary,
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
            if (isRead && !quizPassed) ...[
              const Icon(Icons.menu_book_rounded,
                  size: 13, color: AppColors.warning),
              const SizedBox(width: 4),
              Text(
                'Lexuar',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.warning,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 8),
            ],
            if (lesson.quiz.isNotEmpty) ...[
              Icon(
                quizPassed
                    ? Icons.check_circle_rounded
                    : Icons.quiz_rounded,
                size: 13,
                color: quizPassed
                    ? AppColors.success
                    : cs.secondary,
              ),
              const SizedBox(width: 3),
              Text(
                quizPassed ? 'Kuiz ✓' : 'Kuiz',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  color: quizPassed ? AppColors.success : cs.secondary,
                ),
              ),
            ],
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () => context.push('/lesson/$moduleId/${lesson.id}'),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final Object error;
  const _ErrorView({required this.error});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 56, color: cs.error),
            const SizedBox(height: 16),
            Text('Gabim gjatë ngarkimit', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('$error',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: cs.onSurfaceVariant),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
