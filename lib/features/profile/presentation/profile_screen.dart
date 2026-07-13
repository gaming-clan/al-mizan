import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/providers/home_provider.dart';
import '../../settings/providers/notification_provider.dart';
import '../../settings/providers/settings_provider.dart';
import '../../stats/providers/stats_provider.dart';

// ── Avatar widget ──────────────────────────────────────────
class _ProfileAvatar extends StatelessWidget {
  final String? avatarPath;
  final String name;
  final double size;
  final Color primaryColor;
  final Color onPrimaryColor;
  final Color outlineColor;
  final Color textColor;

  const _ProfileAvatar({
    required this.avatarPath,
    required this.name,
    required this.size,
    required this.primaryColor,
    required this.onPrimaryColor,
    required this.outlineColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage =
        avatarPath != null && File(avatarPath!).existsSync();
    final letter =
        name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : null;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: primaryColor,
        border: Border.all(color: outlineColor, width: 2),
        image: hasImage
            ? DecorationImage(
                image: FileImage(File(avatarPath!)),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: hasImage
          ? null
          : letter != null
              ? Center(
                  child: Text(
                    letter,
                    style: GoogleFonts.sourceSerif4(
                      fontSize: size * 0.42,
                      fontWeight: FontWeight.w700,
                      color: onPrimaryColor,
                    ),
                  ),
                )
              : Icon(
                  Icons.person_rounded,
                  size: size * 0.46,
                  color: onPrimaryColor,
                ),
    );
  }
}

// ── Avatar picker ───────────────────────────────────────────
void _showAvatarPicker(
    BuildContext context, WidgetRef ref, String currentName) {
  final hasPhoto = ref.read(avatarPathProvider) != null;
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      final theme = Theme.of(ctx);
      final cs = theme.colorScheme;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.photo_library_rounded,
                      color: cs.primary),
                ),
                title: const Text('Zgjidh nga galeria'),
                subtitle: const Text('Ngarko foto nga pajisja'),
                onTap: () async {
                  Navigator.pop(ctx);
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 85,
                    maxWidth: 512,
                    maxHeight: 512,
                  );
                  if (picked != null) {
                    ref
                        .read(avatarPathProvider.notifier)
                        .setPath(picked.path);
                  }
                },
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.text_fields_rounded,
                      color: cs.primary),
                ),
                title: const Text('Gjenero avatar'),
                subtitle: Text(
                  currentName.trim().isNotEmpty
                      ? 'Shkronja "${currentName.trim()[0].toUpperCase()}" si avatar'
                      : 'Shkronja e parë e emrit',
                ),
                onTap: () {
                  ref.read(avatarPathProvider.notifier).setPath(null);
                  Navigator.pop(ctx);
                },
              ),
              if (hasPhoto)
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: cs.errorContainer.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.delete_outline_rounded,
                        color: cs.error),
                  ),
                  title: const Text('Hiq foton'),
                  onTap: () {
                    ref.read(avatarPathProvider.notifier).setPath(null);
                    Navigator.pop(ctx);
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    },
  );
}

String _autoThemeLabel(int hour) {
  if (hour >= 4 && hour < 7) return 'Agim — Andalusian Garden';
  if (hour >= 7 && hour < 17) return 'Ditë — Parchment';
  if (hour >= 17 && hour < 21) return 'Perëndim — Desert Sands';
  return 'Natë — Midnight Indigo';
}

void _showThemePicker(BuildContext context, WidgetRef ref) {
  final current = ref.read(themeProvider);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      final theme = Theme.of(ctx);
      final cs = theme.colorScheme;
      final maxHeight = MediaQuery.sizeOf(ctx).height * 0.75;
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: SingleChildScrollView(
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
              childAspectRatio: 0.62,
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
    final isAutoTheme = ref.watch(autoThemeProvider);
    final effectiveTheme = ref.watch(effectiveThemeProvider);
    final avatarPath = ref.watch(avatarPathProvider);
    final notifSettings = ref.watch(dailyNotifProvider);
    final challengeNotif = ref.watch(challengeNotifProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profili')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Avatar + Name ──
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => _showAvatarPicker(context, ref, userName),
                  child: Stack(
                    children: [
                      _ProfileAvatar(
                        avatarPath: avatarPath,
                        name: userName,
                        size: 88,
                        primaryColor: cs.primaryContainer,
                        onPrimaryColor: cs.onPrimary,
                        outlineColor: cs.outlineVariant,
                        textColor: cs.onSurface,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: cs.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: cs.surface, width: 2),
                          ),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            size: 13,
                            color: cs.onPrimary,
                          ),
                        ),
                      ),
                    ],
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
                  label: 'Ditë rresht',
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
                          total += l.quiz.length + l.poolQuiz.length;
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
          // Auto-theme toggle
          _SettingsTile(
            icon: Icons.brightness_auto_rounded,
            title: 'Temë automatike',
            subtitle: isAutoTheme
                ? _autoThemeLabel(DateTime.now().hour)
                : 'Ndryshon sipas orës së ditës',
            trailing: Switch.adaptive(
              value: isAutoTheme,
              onChanged: (v) =>
                  ref.read(autoThemeProvider.notifier).setAuto(v),
              activeTrackColor: cs.primary,
            ),
            onTap: () => ref
                .read(autoThemeProvider.notifier)
                .setAuto(!isAutoTheme),
          ),
          const SizedBox(height: 4),
          // Manual theme picker (disabled when auto is on)
          Opacity(
            opacity: isAutoTheme ? 0.4 : 1.0,
            child: _SettingsTile(
              icon: Icons.palette_outlined,
              title: 'Tema',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: effectiveTheme.swatchPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: cs.outlineVariant, width: 1),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isAutoTheme
                        ? effectiveTheme.displayName
                        : currentTheme.displayName,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right_rounded,
                      color: cs.onSurfaceVariant, size: 20),
                ],
              ),
              onTap: isAutoTheme
                  ? null
                  : () => _showThemePicker(context, ref),
            ),
          ),
          const SizedBox(height: 8),
          // Personal statistics
          _SettingsTile(
            icon: Icons.insights_rounded,
            title: 'Statistikat e Mia',
            subtitle: 'Progresi, kuizet, seritë dhe sfidat',
            trailing: Icon(Icons.chevron_right_rounded,
                color: cs.onSurfaceVariant, size: 20),
            onTap: () {
              ref.invalidate(userStatsProvider);
              context.push('/stats');
            },
          ),
          const SizedBox(height: 8),
          // Daily quote notification toggle
          _SettingsTile(
            icon: Icons.notifications_active_rounded,
            title: 'Njoftimi ditor',
            subtitle: notifSettings.enabled
                ? 'Thënie dijetarësh çdo ditë në ${notifSettings.timeLabel}'
                : 'I çaktivizuar',
            trailing: Switch.adaptive(
              value: notifSettings.enabled,
              onChanged: (v) =>
                  ref.read(dailyNotifProvider.notifier).setEnabled(v),
              activeTrackColor: cs.primary,
            ),
            onTap: () => ref
                .read(dailyNotifProvider.notifier)
                .setEnabled(!notifSettings.enabled),
          ),
          const SizedBox(height: 4),
          // Notification time picker (disabled when notifications are off)
          Opacity(
            opacity: notifSettings.enabled ? 1.0 : 0.4,
            child: _SettingsTile(
              icon: Icons.schedule_rounded,
              title: 'Ora e njoftimit',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(notifSettings.timeLabel,
                      style: theme.textTheme.bodySmall),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right_rounded,
                      color: cs.onSurfaceVariant, size: 20),
                ],
              ),
              onTap: notifSettings.enabled
                  ? () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: notifSettings.time,
                      );
                      if (picked != null) {
                        ref.read(dailyNotifProvider.notifier).setTime(picked);
                      }
                    }
                  : null,
            ),
          ),
          const SizedBox(height: 8),
          // Daily-challenge reminder toggle
          _SettingsTile(
            icon: Icons.today_rounded,
            title: 'Kujtesë për Sfidën Ditore',
            subtitle: challengeNotif.dailyEnabled
                ? 'Kujtesë çdo ditë në ${challengeNotif.dailyLabel}'
                : 'I çaktivizuar',
            trailing: Switch.adaptive(
              value: challengeNotif.dailyEnabled,
              onChanged: (v) =>
                  ref.read(challengeNotifProvider.notifier).setDailyEnabled(v),
              activeTrackColor: cs.primary,
            ),
            onTap: () => ref
                .read(challengeNotifProvider.notifier)
                .setDailyEnabled(!challengeNotif.dailyEnabled),
          ),
          const SizedBox(height: 4),
          // Daily-challenge reminder time picker
          Opacity(
            opacity: challengeNotif.dailyEnabled ? 1.0 : 0.4,
            child: _SettingsTile(
              icon: Icons.schedule_rounded,
              title: 'Ora e Sfidës Ditore',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(challengeNotif.dailyLabel,
                      style: theme.textTheme.bodySmall),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right_rounded,
                      color: cs.onSurfaceVariant, size: 20),
                ],
              ),
              onTap: challengeNotif.dailyEnabled
                  ? () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: challengeNotif.dailyTime,
                      );
                      if (picked != null) {
                        ref
                            .read(challengeNotifProvider.notifier)
                            .setDailyTime(picked);
                      }
                    }
                  : null,
            ),
          ),
          const SizedBox(height: 8),
          // Weekly-challenge reminder toggle
          _SettingsTile(
            icon: Icons.date_range_rounded,
            title: 'Kujtesë për Sfidën Javore',
            subtitle: challengeNotif.weeklyEnabled
                ? 'Kujtesë çdo të premte në ${challengeNotif.weeklyLabel}'
                : 'I çaktivizuar',
            trailing: Switch.adaptive(
              value: challengeNotif.weeklyEnabled,
              onChanged: (v) =>
                  ref.read(challengeNotifProvider.notifier).setWeeklyEnabled(v),
              activeTrackColor: cs.primary,
            ),
            onTap: () => ref
                .read(challengeNotifProvider.notifier)
                .setWeeklyEnabled(!challengeNotif.weeklyEnabled),
          ),
          const SizedBox(height: 4),
          // Weekly-challenge reminder time picker
          Opacity(
            opacity: challengeNotif.weeklyEnabled ? 1.0 : 0.4,
            child: _SettingsTile(
              icon: Icons.schedule_rounded,
              title: 'Ora e Sfidës Javore',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(challengeNotif.weeklyLabel,
                      style: theme.textTheme.bodySmall),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right_rounded,
                      color: cs.onSurfaceVariant, size: 20),
                ],
              ),
              onTap: challengeNotif.weeklyEnabled
                  ? () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: challengeNotif.weeklyTime,
                      );
                      if (picked != null) {
                        ref
                            .read(challengeNotifProvider.notifier)
                            .setWeeklyTime(picked);
                      }
                    }
                  : null,
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
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
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
        subtitle: subtitle != null
            ? Text(subtitle!, style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ))
            : null,
        trailing: trailing ??
            Icon(Icons.chevron_right_rounded,
                color: cs.onSurfaceVariant, size: 20),
        onTap: onTap,
      ),
    );
  }
}
