import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/quran_verse_card.dart';
import '../../../shared/widgets/hadith_card.dart';
import '../../../shared/widgets/madhab_comparison.dart';
import '../../../shared/widgets/level_complete_dialog.dart';
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
    final progressAsync = ref.watch(lessonProgressProvider(moduleId));
    final db = ref.read(databaseProvider);
    final theme = Theme.of(context);

    return moduleAsync.when(
      data: (module) {
        final lesson = module.lessons.firstWhere(
          (l) => l.id == lessonId,
          orElse: () => module.lessons.first,
        );
        final isAlreadyRead = progressAsync.valueOrNull?[lessonId]?.isRead ?? false;

        // Ordered lesson list: beginner → intermediate → advanced
        final levelOrder = ['beginner', 'intermediate', 'advanced'];
        final allLessonsOrdered = [
          for (final lvl in levelOrder)
            ...module.lessons.where((l) => l.level == lvl),
        ];
        final currentIdx = allLessonsOrdered.indexWhere((l) => l.id == lessonId);
        final nextLesson = (currentIdx >= 0 && currentIdx < allLessonsOrdered.length - 1)
            ? allLessonsOrdered[currentIdx + 1]
            : null;

        // First lesson of next level (for the level-complete dialog)
        final nextLevel = lesson.level == 'beginner'
            ? 'intermediate'
            : lesson.level == 'intermediate'
                ? 'advanced'
                : null;
        final nextLevelLessons = nextLevel != null
            ? module.lessons.where((l) => l.level == nextLevel).toList()
            : <Lesson>[];
        final nextLevelFirstLesson =
            nextLevelLessons.isNotEmpty ? nextLevelLessons.first : null;

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
          body: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 840),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    lesson.titleAr,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontFamily: 'Amiri',
                      fontSize: 24,
                    ),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  for (final section in lesson.sections) ...[
                    _SectionWidget(section: section),
                    const SizedBox(height: 16),
                  ],
                  if (lesson.sourceReferences.isNotEmpty) ...[
                    const Divider(height: 32),
                    Text('Referencat', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    for (final sourceRef in lesson.sourceReferences)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.library_books_rounded,
                                size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(sourceRef,
                                  style: theme.textTheme.bodySmall),
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
                    onPressed: isAlreadyRead
                        ? null
                        : () async {
                            await db.markLessonCompleted(lessonId, moduleId);
                            await db.recordLearningDay();
                            ref.invalidate(lessonProgressProvider(moduleId));
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Mësimi u shënua si i përfunduar!')),
                            );
                            try {
                              final progress = await ref
                                  .read(lessonProgressProvider(moduleId).future);
                              if (!context.mounted) return;
                              final levelLessons = module.lessons
                                  .where((l) => l.level == lesson.level)
                                  .toList();
                              final allComplete = levelLessons.isNotEmpty &&
                                  levelLessons.every(
                                      (l) => progress[l.id]?.isComplete == true);
                              if (allComplete) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => LevelCompleteDialog(
                                    level: lesson.level,
                                    onContinue: nextLevelFirstLesson != null
                                        ? () => context.push(
                                            '/lesson/$moduleId/${nextLevelFirstLesson.id}')
                                        : null,
                                  ),
                                );
                              }
                            } catch (_) {}
                          },
                    icon: Icon(isAlreadyRead
                        ? Icons.check_circle_rounded
                        : Icons.check_circle_outline_rounded),
                    label: Text(isAlreadyRead
                        ? 'I Përfunduar'
                        : 'Shëno si të Përfunduar'),
                  ),
                  if (isAlreadyRead && nextLesson != null) ...[
                    const SizedBox(height: 8),
                    FilledButton.icon(
                      onPressed: () =>
                          context.push('/lesson/$moduleId/${nextLesson.id}'),
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('Mësimi Pasardhës'),
                    ),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
            ),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: _rulingColor(section.ruling!),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _rulingLabel(section.ruling!),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
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

Color _rulingColor(String ruling) {
  switch (ruling.toLowerCase()) {
    case 'farz':
      return const Color(0xFF1B6B45);
    case 'vaxhib':
    case 'obligim':
      return const Color(0xFFB86200);
    case 'mekruh':
    case 'makruh':
      return const Color(0xFF5A5A6E);
    case 'sunnet':
      return const Color(0xFF2260A8);
    case 'important_concept':
      return const Color(0xFF4A3080);
    default:
      return const Color(0xFF2B5C3E);
  }
}

String _rulingLabel(String ruling) {
  switch (ruling.toLowerCase()) {
    case 'farz':
      return 'FARZ';
    case 'vaxhib':
      return 'VAXHIB';
    case 'obligim':
      return 'OBLIGIM';
    case 'mekruh':
    case 'makruh':
      return 'MEKRUH';
    case 'sunnet':
      return 'SUNNET';
    case 'important_concept':
      return 'E RËNDËSISHME';
    default:
      return ruling.toUpperCase();
  }
}
