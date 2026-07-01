import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/daily_quotes.dart';
import '../../settings/providers/settings_provider.dart';
import '../providers/home_provider.dart';
import '../providers/last_lesson_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modulesAsync = ref.watch(modulesProvider);
    final streakAsync = ref.watch(streakProvider);
    final userName = ref.watch(userNameProvider);
    final lastLesson = ref.watch(lastLessonProvider);

    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final width = MediaQuery.sizeOf(context).width;
    // Large screens = tablets & foldables (landscape). Phones (<600) stay as-is.
    final isLargeScreen = width >= 600;
    final gridCols = width >= 1000 ? 5 : (isLargeScreen ? 4 : 2);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: CustomScrollView(
          slivers: [
            // ── HEADER ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Es-selamu alejkum, ${userName.isEmpty ? 'Nxënës' : userName}!',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            AppConstants.appName,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: cs.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Streak badge
                    streakAsync.when(
                      data: (streak) => streak > 0
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: cs.secondaryContainer.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: cs.outlineVariant,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.local_fire_department_rounded,
                                      color: cs.secondary, size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$streak',
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: cs.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),

            // ── DAILY CONTEMPLATION CARD ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? cs.surfaceContainerHigh
                        : cs.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.auto_awesome_rounded,
                              color: isDark ? cs.secondary : cs.onPrimaryContainer,
                              size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'MEDITIMI I DITËS',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: isDark ? cs.secondary : cs.onPrimaryContainer,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        DailyQuotes.forToday().text,
                        style: GoogleFonts.sourceSerif4(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: isDark ? cs.onSurface : cs.onPrimaryContainer,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '— ${DailyQuotes.forToday().author}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? cs.onSurfaceVariant
                              : cs.onPrimaryContainer.withValues(alpha: 0.75),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── CONTINUE WHERE YOU LEFT OFF ──
            if (lastLesson != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Material(
                    color: cs.secondaryContainer.withValues(alpha: 0.35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: cs.outlineVariant),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => context.push(
                          '/lesson/${lastLesson.moduleId}/${lastLesson.lessonId}'),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: cs.primary.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.play_circle_fill_rounded,
                                  color: cs.primary, size: 26),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'VAZHDO KU MBETE',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: cs.onSurfaceVariant,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    lastLesson.lessonTitle,
                                    style: theme.textTheme.titleSmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    lastLesson.moduleTitle,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: cs.onSurfaceVariant,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded,
                                color: cs.onSurfaceVariant, size: 22),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // ── STUDY PROGRESS ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(
                  'VAZHDIMI I STUDIMIT',
                  style: theme.textTheme.labelMedium?.copyWith(
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            // Module grid
            modulesAsync.when(
              data: (modules) => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridCols,
                    mainAxisSpacing: isLargeScreen ? 12 : 10,
                    crossAxisSpacing: isLargeScreen ? 12 : 10,
                    childAspectRatio: isLargeScreen ? 0.82 : 1.15,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _ModuleGridCard(
                      module: modules[index],
                      large: isLargeScreen,
                    ),
                    childCount: modules.length,
                  ),
                ),
              ),
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverFillRemaining(
                child: Center(child: Text('Gabim: $e')),
              ),
            ),

            // ── QUICK ACTIONS ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text(
                  'VEGLA TË SHPEJTA',
                  style: theme.textTheme.labelMedium?.copyWith(
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _QuickActionTile(
                      icon: Icons.quiz_rounded,
                      title: 'Kuiz i Përgjithshëm',
                      subtitle: 'Testo njohuritë nga të gjitha temat',
                      onTap: () => context.push('/general-quiz'),
                    ),
                    const SizedBox(height: 8),
                    _QuickActionTile(
                      icon: Icons.calculate_rounded,
                      title: 'Llogaritës Zekati',
                      subtitle: 'Llogarit detyrimet e zekatit',
                      onTap: () => context.push('/zakat'),
                    ),
                    const SizedBox(height: 8),
                    _QuickActionTile(
                      icon: Icons.question_answer_rounded,
                      title: 'Pyet Dijetarin',
                      subtitle: 'Pyetje dhe përgjigje rreth fesë',
                      onTap: () => context.push('/ask'),
                    ),
                  ],
                ),
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
          ],
        ),
      ),
    ),
  ),
    );
  }
}

/// Module card matching Stitch design — bordered, no shadow, icon + title
class _ModuleGridCard extends StatelessWidget {
  final dynamic module;
  final bool large;
  const _ModuleGridCard({required this.module, this.large = false});

  IconData _iconForModule(String iconKey) {
    switch (iconKey) {
      case 'book_open':
        return Icons.menu_book_rounded;
      case 'droplets':
        return Icons.water_drop_rounded;
      case 'landmark':
        return Icons.mosque_rounded;
      case 'moon':
        return Icons.nightlight_round;
      case 'hand_coins':
        return Icons.volunteer_activism_rounded;
      case 'map_pin':
        return Icons.place_rounded;
      case 'handshake':
        return Icons.handshake_rounded;
      case 'utensils':
        return Icons.restaurant_rounded;
      case 'family':
        return Icons.family_restroom_rounded;
      case 'cemetery':
        return Icons.local_florist_rounded;
      case 'oath':
        return Icons.gavel_rounded;
      case 'food':
        return Icons.lunch_dining_rounded;
      default:
        return Icons.book_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: cs.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cs.outlineVariant),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/module/${module.moduleId}'),
        child: Padding(
          padding: EdgeInsets.all(large ? 18 : 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(large ? 18 : 12),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(large ? 14 : 10),
                ),
                child: Icon(
                  _iconForModule(module.moduleIcon),
                  size: large ? 40 : 26,
                  color: cs.primary,
                ),
              ),
              SizedBox(height: large ? 14 : 10),
              Text(
                module.titleSq,
                style: large
                    ? theme.textTheme.titleMedium
                    : theme.textTheme.titleSmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: large ? 6 : 4),
              Text(
                '${module.lessons.length} mësime',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Quick action tile — borderless card with icon
class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: cs.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cs.outlineVariant),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: cs.primary, size: 22),
        ),
        title: Text(title, style: theme.textTheme.titleSmall),
        subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
        trailing: Icon(Icons.chevron_right_rounded,
            color: cs.onSurfaceVariant, size: 20),
        onTap: onTap,
      ),
    );
  }
}
