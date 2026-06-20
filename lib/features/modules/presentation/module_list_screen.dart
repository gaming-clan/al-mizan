import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../home/providers/home_provider.dart';
import '../../home/presentation/widgets/module_card.dart';

class ModuleListScreen extends ConsumerWidget {
  const ModuleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modulesAsync = ref.watch(modulesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Module')),
      body: modulesAsync.when(
        data: (modules) => GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.95,
          ),
          itemCount: modules.length,
          itemBuilder: (context, index) => ModuleCard(module: modules[index]),
        ),
        loading: () => const _ModuleListShimmer(),
        error: (e, _) => _ModuleListError(error: e),
      ),
    );
  }
}

class _ModuleListShimmer extends StatelessWidget {
  const _ModuleListShimmer();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: cs.surfaceContainerHighest,
      highlightColor: cs.surfaceContainerLow,
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.95,
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
