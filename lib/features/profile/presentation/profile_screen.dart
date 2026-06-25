import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/providers/home_provider.dart';
import '../../settings/providers/settings_provider.dart';

void _showThemePicker(BuildContext context, WidgetRef ref) {
  final current = ref.read(themeProvider);
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      final theme = Theme.of(ctx);
      final cs = theme.colorScheme;
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Zgjidh Temën',
                style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.78,
              children: AppThemeType.values.map((t) {
                final isSelected = t == current;
                return GestureDetector(
                  onTap: () {
                    ref.read(themeProvider.notifier).setTheme(t);
                    Navigator.pop(ctx);
                  },
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: t.swatchSurface,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? cs.primary
                                : cs.outlineVariant,
                            width: isSelected ? 3 : 1.5,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: cs.primary.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  )
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: t.swatchPrimary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        t.displayName,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: isSelected
                              ? cs.primary
                              : cs.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    },
  );
}

void _showEditNameDialog(
    BuildContext context, WidgetRef ref, String currentName) {
  final controller = TextEditingController(text: currentName);
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Ndrysho emrin'),
      content: TextField(
        controller: controller,
        textCapitalization: TextCapitalization.words,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Emri ose pseudonimi',
          border: OutlineInputBorder(),
        ),
        onSubmitted: (_) {
          ref.read(userNameProvider.notifier).setName(controller.text);
          Navigator.pop(ctx);
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Anulo'),
        ),
        FilledButton(
          onPressed: () {
            ref.read(userNameProvider.notifier).setName(controller.text);
            Navigator.pop(ctx);
          },
          child: const Text('Ruaj'),
        ),
      ],
    ),
  );
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final streakAsync = ref.watch(streakProvider);
    final modulesAsync = ref.watch(modulesProvider);
    final userName = ref.watch(userNameProvider);
    final displayName = userName.isEmpty ? 'Nxënës' : userName;
    final currentTheme = ref.watch(themeProvider);

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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      displayName,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () =>
                          _showEditNameDialog(context, ref, userName),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.edit_rounded,
                          size: 16,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
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
            icon: Icons.palette_outlined,
            title: 'Tema',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: currentTheme.swatchPrimary,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: cs.outlineVariant, width: 1),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  currentTheme.displayName,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right_rounded,
                    color: cs.onSurfaceVariant, size: 20),
              ],
            ),
            onTap: () => _showThemePicker(context, ref),
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
