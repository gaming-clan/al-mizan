import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final currentTheme = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cilësime')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        children: [
          // ── Theme picker ──
          Text(
            'TEMA',
            style: theme.textTheme.labelMedium?.copyWith(letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.72,
            children: AppThemeType.values.map((t) {
              final isSelected = t == currentTheme;
              return GestureDetector(
                onTap: () => ref.read(themeProvider.notifier).setTheme(t),
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
                          color: isSelected ? cs.primary : cs.outlineVariant,
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
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w400,
                        color:
                            isSelected ? cs.primary : cs.onSurfaceVariant,
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
          const SizedBox(height: 24),

          // ── Info ──
          Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              leading: const Icon(Icons.info_outline_rounded,
                  color: AppColors.info),
              title: const Text('Rreth App-it'),
              subtitle: const Text('${AppConstants.appName} v1.0.0'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: AppConstants.appName,
                  applicationVersion: '1.0.0',
                  applicationLegalese:
                      'Aplikacion edukativ për jurisprudencën islame.\nTë gjitha të drejtat janë të rezervuara.',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
