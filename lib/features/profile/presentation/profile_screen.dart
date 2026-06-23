import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/providers/home_provider.dart';
import '../../settings/providers/settings_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = ref.watch(darkModeProvider);
    final streakAsync = ref.watch(streakProvider);
    final modulesAsync = ref.watch(modulesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profili')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Avatar + Name ──
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cs.primaryContainer,
                    border: Border.all(color: cs.outlineVariant, width: 2),
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: 40,
                    color: cs.onPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Student',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mësues i Fikhut — Nxënës i përjetshëm',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Stats Cards ──
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.local_fire_department_rounded,
                  label: 'Ditë rrjesht',
                  value: streakAsync.when(
                    data: (s) => '$s',
                    loading: () => '—',
                    error: (_, __) => '0',
                  ),
                  color: cs.secondary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  icon: Icons.menu_book_rounded,
                  label: 'Module',
                  value: modulesAsync.when(
                    data: (m) => '${m.length}',
                    loading: () => '—',
                    error: (_, __) => '0',
                  ),
                  color: cs.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  icon: Icons.quiz_rounded,
                  label: 'Kuize',
                  value: modulesAsync.when(
                    data: (m) {
                      int total = 0;
                      for (final mod in m) {
                        for (final l in mod.lessons) {
                          total += l.quiz.length;
                        }
                      }
                      return '$total';
                    },
                    loading: () => '—',
                    error: (_, __) => '0',
                  ),
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Settings section ──
          Text(
            'CILËSIMET',
            style: theme.textTheme.labelMedium?.copyWith(
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: isDark
                ? Icons.dark_mode_rounded
                : Icons.light_mode_rounded,
            title: 'Pamja e errët',
            trailing: Switch.adaptive(
              value: isDark,
              onChanged: (_) =>
                  ref.read(darkModeProvider.notifier).toggle(),
              activeThumbColor: cs.primary,
            ),
          ),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            title: 'Rreth App-it',
            onTap: () => context.push('/about'),
          ),
          const SizedBox(height: 24),

          // ── Motivational footer ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Column(
              children: [
                Text(
                  'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ',
                  style: GoogleFonts.amiri(
                    fontSize: 22,
                    color: cs.primary,
                    height: 1.8,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Veprat vlerësohen sipas qëllimit.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: cs.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '— Buhariu & Muslimi',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.sourceSerif4(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

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
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: Icon(icon, color: cs.primary),
        title: Text(title, style: theme.textTheme.titleSmall),
        trailing: trailing ??
            Icon(Icons.chevron_right_rounded,
                color: cs.onSurfaceVariant, size: 20),
        onTap: onTap,
      ),
    );
  }
}
