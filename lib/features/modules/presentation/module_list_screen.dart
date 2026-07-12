import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/providers/home_provider.dart';
import '../../home/presentation/widgets/module_card.dart';
import '../data/models/fiqh_models.dart';
import 'widgets/level_lessons.dart';

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
    final entries = lessonsOfLevel(modules, selectedLevel);
    final color = kLevelColors[selectedLevel] ?? AppColors.info;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: LevelChipsRow(
            selectedLevel: selectedLevel,
            onLevelChanged: onLevelChanged,
          ),
        ),
        if (entries.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: LevelStartButton(
              modules: modules,
              level: selectedLevel,
              color: color,
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${entries.length} mësime — niveli ${kLevelLabels[selectedLevel]}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: color,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              LevelCompletedBadge(modules: modules, level: selectedLevel),
            ],
          ),
        ),
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
                      itemCount: entries.length + 1,
                      itemBuilder: (context, index) {
                        if (index == entries.length) {
                          return LevelQuizButton(level: selectedLevel);
                        }
                        final (module, lesson) = entries[index];
                        return LevelLessonTile(
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
