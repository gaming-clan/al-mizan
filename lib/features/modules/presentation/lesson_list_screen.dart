import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/module_provider.dart';

class LessonListScreen extends ConsumerWidget {
  final String moduleId;
  const LessonListScreen({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moduleAsync = ref.watch(moduleProvider(moduleId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: moduleAsync.when(
        data: (m) => AppBar(title: Text(m.titleSq)),
        loading: () => AppBar(title: const Text('...')),
        error: (_, __) => AppBar(title: const Text('Gabim')),
      ),
      body: moduleAsync.when(
        data: (module) => ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: module.lessons.length,
          itemBuilder: (context, index) {
            final lesson = module.lessons[index];
            final levelColor = switch (lesson.level) {
              'beginner' => AppColors.success,
              'intermediate' => AppColors.warning,
              'advanced' => AppColors.error,
              _ => AppColors.info,
            };
            final levelLabel = switch (lesson.level) {
              'beginner' => 'Fillestar',
              'intermediate' => 'Mesatar',
              'advanced' => 'Avancuar',
              _ => lesson.level,
            };

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(lesson.titleSq),
                subtitle: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: levelColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        levelLabel,
                        style: TextStyle(
                          fontSize: 11,
                          color: levelColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (lesson.quiz.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Icon(Icons.quiz_rounded,
                          size: 14, color: theme.colorScheme.secondary),
                      const SizedBox(width: 2),
                      Text('Kuiz',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.secondary)),
                    ],
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () =>
                    context.push('/lesson/$moduleId/${lesson.id}'),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gabim: $e')),
      ),
    );
  }
}
