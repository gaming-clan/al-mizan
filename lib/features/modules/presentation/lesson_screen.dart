import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/quran_verse_card.dart';
import '../../../shared/widgets/hadith_card.dart';
import '../../../shared/widgets/madhab_comparison.dart';
import '../../home/providers/home_provider.dart';
import '../providers/module_provider.dart';
import '../data/models/fiqh_models.dart';

class LessonScreen extends ConsumerWidget {
  final String moduleId;
  final String lessonId;
  const LessonScreen(
      {super.key, required this.moduleId, required this.lessonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moduleAsync = ref.watch(moduleProvider(moduleId));
    final db = ref.read(databaseProvider);
    final theme = Theme.of(context);

    return moduleAsync.when(
      data: (module) {
        final lesson = module.lessons.firstWhere(
          (l) => l.id == lessonId,
          orElse: () => module.lessons.first,
        );
        return Scaffold(
          appBar: AppBar(
            title: Text(lesson.titleSq),
            actions: [
              IconButton(
                icon: const Icon(Icons.bookmark_border_rounded),
                onPressed: () async {
                  await db.addBookmark(lessonId, moduleId);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('U shtua te shënimet!')),
                    );
                  }
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(lesson.titleAr,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontFamily: 'Amiri',
                    fontSize: 24,
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              for (final section in lesson.sections) ...[
                _SectionWidget(section: section),
                const SizedBox(height: 16),
              ],
              if (lesson.sourceReferences.isNotEmpty) ...[
                const Divider(height: 32),
                Text('Referencat', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                for (final ref in lesson.sourceReferences)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.library_books_rounded,
                            size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(ref, style: theme.textTheme.bodySmall),
                        ),
                      ],
                    ),
                  ),
              ],
              const SizedBox(height: 24),
              if (lesson.quiz.isNotEmpty)
                FilledButton.icon(
                  onPressed: () =>
                      context.push('/quiz/$moduleId/$lessonId'),
                  icon: const Icon(Icons.quiz_rounded),
                  label: const Text('Fillo Kuizin'),
                ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () async {
                  await db.markLessonCompleted(lessonId, moduleId);
                  await db.recordLearningDay();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Mësimi u shënua si i përfunduar!')),
                    );
                  }
                },
                icon: const Icon(Icons.check_circle_outline_rounded),
                label: const Text('Shëno si të Përfunduar'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Gabim: $e'))),
    );
  }
}

class _SectionWidget extends StatelessWidget {
  final LessonSection section;
  const _SectionWidget({required this.section});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.ruling != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              section.ruling!.toUpperCase(),
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
        Text(section.heading, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(section.contentSq,
            style: theme.textTheme.bodyLarge),
        const SizedBox(height: 12),
        for (final evidence in section.evidences) ...[
          if (evidence.isQuran)
            QuranVerseCard(evidence: evidence)
          else
            HadithCard(evidence: evidence),
          const SizedBox(height: 8),
        ],
        if (section.madhabRulings != null) ...[
          const SizedBox(height: 8),
          MadhabComparison(rulings: section.madhabRulings!),
        ],
      ],
    );
  }
}
