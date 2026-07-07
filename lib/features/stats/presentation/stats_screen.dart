import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../modules/presentation/widgets/level_lessons.dart';
import '../providers/stats_provider.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(userStatsProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistikat e Mia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(userStatsProvider),
          ),
        ],
      ),
      body: statsAsync.when(
        data: (stats) {
          final overallRatio = stats.lessonsTotal > 0
              ? stats.lessonsDone / stats.lessonsTotal
              : 0.0;
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // ── Overall progress ──
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: cs.primary.withValues(alpha: 0.35)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'PROGRESI I PËRGJITHSHËM',
                          style: theme.textTheme.labelMedium?.copyWith(
                            letterSpacing: 1.2,
                            color: cs.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${stats.lessonsDone} / ${stats.lessonsTotal}',
                          style: theme.textTheme.headlineLarge
                              ?.copyWith(color: cs.primary),
                        ),
                        Text('mësime të përfunduara',
                            style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: overallRatio,
                            minHeight: 10,
                            backgroundColor: cs.surfaceContainerHighest,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${(overallRatio * 100).toStringAsFixed(0)}%',
                          style: theme.textTheme.labelLarge
                              ?.copyWith(color: cs.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Quick stats grid ──
                  Row(
                    children: [
                      _StatCard(
                        icon: Icons.local_fire_department_rounded,
                        color: AppColors.warning,
                        value: '${stats.learningStreak}',
                        label: 'Ditë rresht',
                      ),
                      const SizedBox(width: 8),
                      _StatCard(
                        icon: Icons.quiz_rounded,
                        color: AppColors.info,
                        value: '${stats.quizAttempts}',
                        label: 'Kuize të bëra',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _StatCard(
                        icon: Icons.percent_rounded,
                        color: AppColors.success,
                        value: stats.quizAttempts > 0
                            ? '${stats.avgScore.toStringAsFixed(0)}%'
                            : '—',
                        label: 'Mesatarja e kuizeve',
                      ),
                      const SizedBox(width: 8),
                      _StatCard(
                        icon: Icons.bookmark_rounded,
                        color: AppColors.accent,
                        value: '${stats.bookmarksCount}',
                        label: 'Shënime',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Challenges ──
                  Text(
                    'SFIDAT',
                    style: theme.textTheme.labelMedium
                        ?.copyWith(letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.today_rounded,
                              color: AppColors.warning),
                          title: const Text('Sfida Ditore'),
                          subtitle: Text(stats.dailyStreak > 0
                              ? 'Seria: ${stats.dailyStreak} ditë'
                              : 'Ende pa seri'),
                          trailing: Text(
                            stats.dailyLastScore > 0
                                ? '${stats.dailyLastScore}%'
                                : '—',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(color: AppColors.warning),
                          ),
                        ),
                        Divider(height: 1, color: cs.outlineVariant),
                        ListTile(
                          leading: const Icon(Icons.date_range_rounded,
                              color: AppColors.error),
                          title: const Text('Sfida Javore'),
                          subtitle: Text(stats.weeklyStreak > 0
                              ? 'Seria: ${stats.weeklyStreak} javë'
                              : 'Ende pa seri'),
                          trailing: Text(
                            stats.weeklyLastScore > 0
                                ? '${stats.weeklyLastScore}%'
                                : '—',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Per level ──
                  Text(
                    'PROGRESI SIPAS NIVELEVE',
                    style: theme.textTheme.labelMedium
                        ?.copyWith(letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          for (final level in stats.perLevel) ...[
                            Row(
                              children: [
                                Icon(kLevelIcons[level.level],
                                    size: 16,
                                    color: kLevelColors[level.level]),
                                const SizedBox(width: 8),
                                Text(kLevelLabels[level.level] ?? level.level,
                                    style: theme.textTheme.bodyMedium),
                                const Spacer(),
                                Text(
                                  '${level.done}/${level.total}',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                      color: kLevelColors[level.level]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: level.ratio,
                                minHeight: 7,
                                backgroundColor: cs.surfaceContainerHighest,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    kLevelColors[level.level] ??
                                        AppColors.info),
                              ),
                            ),
                            if (level != stats.perLevel.last)
                              const SizedBox(height: 14),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Per module ──
                  Text(
                    'PROGRESI SIPAS MODULEVE',
                    style: theme.textTheme.labelMedium
                        ?.copyWith(letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          for (final m in stats.perModule) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    m.title,
                                    style: theme.textTheme.bodyMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (m.done == m.total && m.total > 0)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 4),
                                    child: Icon(Icons.check_circle_rounded,
                                        size: 15, color: AppColors.success),
                                  ),
                                Text(
                                  '${m.done}/${m.total}',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: m.done == m.total && m.total > 0
                                        ? AppColors.success
                                        : cs.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: m.ratio,
                                minHeight: 6,
                                backgroundColor: cs.surfaceContainerHighest,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  m.done == m.total && m.total > 0
                                      ? AppColors.success
                                      : cs.primary,
                                ),
                              ),
                            ),
                            if (m != stats.perModule.last)
                              const SizedBox(height: 12),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gabim: $e')),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(value,
                style:
                    theme.textTheme.headlineSmall?.copyWith(color: color)),
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
