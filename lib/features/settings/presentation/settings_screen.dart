import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(darkModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cilësime')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: SwitchListTile(
              secondary: Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: AppColors.primary,
              ),
              title: const Text('Dark Mode'),
              subtitle: const Text('Ndërro ndriçimin e pamjes'),
              value: isDark,
              onChanged: (_) => ref.read(darkModeProvider.notifier).toggle(),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading:
                  const Icon(Icons.info_outline_rounded, color: AppColors.info),
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
