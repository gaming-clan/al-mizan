import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/providers/home_provider.dart';
import '../../home/presentation/widgets/module_card.dart';
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

class ModuleListScreen extends ConsumerStatefulWidget {
  const ModuleListScreen({super.key});

  @override
  ConsumerState<ModuleListScreen> createState() => _ModuleListScreenState();
}

class _ModuleListScreenState extends ConsumerState<ModuleListScreen> {
  bool _byLevel = false;
  String _selectedLevel = 'beginner';

  @override
  Widget build(BuildContext context) {
    final modulesAsync = ref.watch(modulesProvider);
    final width = MediaQuery.sizeOf(context).width;
    final cols = width >= 900 ? 4 : (width >= 600 ? 3 : 2);

    return Scaffold(
      appBar: AppBar(title: const Text('Module')),
      body: Column(
        children: [
          // ── View toggle: by module / by level ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: false,
                  label: Text('Sipas Moduleve'),
                  icon: Icon(Icons.menu_book_rounded, size: 18),
                ),
                ButtonSegment(
                  value: true,
                  label: Text('Sipas Niveleve'),
                  icon: Icon(Icons.stairs_rounded, size: 18),
                ),
              ],
              selected: {_byLevel},
              onSelectionChanged: (s) => setState(() => _byLevel = s.first),
              showSelectedIcon: false,
            ),
          ),
          Expanded(
            child: modulesAsync.when(
              data: (modules) => _byLevel
                  ? _LevelView(
                      modules: modules,
                      selectedLevel: _selectedLevel,
                      onLevelChanged: (l) =>
                          setState(() => _selectedLevel = l),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: cols >= 3 ? 1.0 : 0.95,
                      ),
                      itemCount: modules.length,
                      itemBuilder: (context, index) =>
                          ModuleCard(module: modules[index]),
                    ),
              loading: () => _ModuleListShimmer(cols: cols),
              error: (e, _) => _ModuleListError(error: e),
            ),
          ),
        ],
      ),
    );
  }
}

/// Lessons of one level, gathered across all modules.
class _LevelView extends StatelessWidget {
  final List<FiqhModule> modules;
  final String selectedLevel;
  final void Function(String) onLevelChanged;

  const _LevelView({
    required this.modules,
    required this.selectedLevel,
    required this.onLevelChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Collect (module, lesson) pairs of the selected level, in module order.
    final entries = <(FiqhModule, Lesson)>[];
    for (final module in modules) {
      for (final lesson in module.lessons) {
        if (lesson.level == selectedLevel) entries.add((module, lesson));
      }
    }

    final color = _levelColors[selectedLevel] ?? AppColors.info;

    return Column(
      children: [
        // ── Level chips ──
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Row(
            children: [
              for (final level in _levels) ...[
                Expanded(
                  child: ChoiceChip(
                    label: SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _levelIcons[level],
                            size: 15,
                            color: level == selectedLevel
                                ? _levelColors[level]
                                : cs.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              _levelLabels[level]!,
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
                if (level != _levels.last) const SizedBox(width: 8),
              ],
            ],
          ),
        ),

        // ── Count ──
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
          child: Row(
            children: [
              Text(
                '${entries.length} mësime — niveli ${_levelLabels[selectedLevel]}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),

        // ── Lesson list ──
        Expanded(
          child: entries.isEmpty
              ? Center(
                  child: Text(
                    'Nuk ka mësime për këtë nivel.',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),
                )
              : Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                        top: 4,
                        bottom: MediaQuery.of(context).padding.bottom + 24,
                      ),
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final (module, lesson) = entries[index];
                        return _LevelLessonTile(
                          module: module,
                          lesson: lesson,
                          index: index,
                          color: color,
                        );
                      },
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _LevelLessonTile extends ConsumerWidget {
  final FiqhModule module;
  final Lesson lesson;
  final int index;
  final Color color;

  const _LevelLessonTile({
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

class _ModuleListShimmer extends StatelessWidget {
  final int cols;
  const _ModuleListShimmer({this.cols = 2});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: cs.surfaceContainerHighest,
      highlightColor: cs.surfaceContainerLow,
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: cols >= 3 ? 1.0 : 0.95,
        ),
        itemCount: 12,
        itemBuilder: (_, __) => Card(
          child: Container(
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModuleListError extends StatelessWidget {
  final Object error;
  const _ModuleListError({required this.error});

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
            Text('Nuk mund të ngarkohen modulet',
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Rinisni aplikacionin nëse problemi vazhdon.',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: cs.onSurfaceVariant),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
