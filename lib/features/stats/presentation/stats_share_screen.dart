import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../modules/presentation/widgets/level_lessons.dart';
import '../providers/stats_provider.dart';

/// Plain-text summary shared via "Si tekst" — mirrors every stat shown on
/// the Statistics screen (overall progress, quick stats, challenges,
/// per-level and per-module breakdowns).
String buildStatsShareText(UserStats stats) {
  final pct = stats.lessonsTotal > 0
      ? (stats.lessonsDone / stats.lessonsTotal * 100).round()
      : 0;
  final buffer = StringBuffer()
    ..writeln('📿 Al Mizan — Statistikat e Mia')
    ..writeln()
    ..writeln('📖 Mësime: ${stats.lessonsDone}/${stats.lessonsTotal} ($pct%)')
    ..writeln('🔥 Seri mësimi: ${stats.learningStreak} ditë')
    ..writeln('📝 Kuize të bëra: ${stats.quizAttempts}');
  if (stats.quizAttempts > 0) {
    buffer
      ..writeln('📊 Mesatarja e kuizeve: ${stats.avgScore.toStringAsFixed(0)}%')
      ..writeln(
          '🏆 Rezultati më i mirë: ${stats.bestScore.toStringAsFixed(0)}%');
  }
  buffer
    ..writeln('🔖 Shënime: ${stats.bookmarksCount}')
    ..writeln()
    ..writeln('SFIDAT')
    ..writeln(stats.dailyStreak > 0
        ? '📅 Sfida Ditore — seri: ${stats.dailyStreak} ditë (${stats.dailyLastScore}%)'
        : '📅 Sfida Ditore — ende pa seri')
    ..writeln(stats.weeklyStreak > 0
        ? '📆 Sfida Javore — seri: ${stats.weeklyStreak} javë (${stats.weeklyLastScore}%)'
        : '📆 Sfida Javore — ende pa seri')
    ..writeln()
    ..writeln('PROGRESI SIPAS NIVELEVE');
  for (final level in stats.perLevel) {
    buffer.writeln(
        '${kLevelLabels[level.level] ?? level.level}: ${level.done}/${level.total}');
  }
  buffer
    ..writeln()
    ..writeln('PROGRESI SIPAS MODULEVE');
  for (final module in stats.perModule) {
    buffer.writeln('${module.title}: ${module.done}/${module.total}');
  }
  buffer
    ..writeln()
    ..writeln('Mëso Fikhun me Al Mizan 📿');
  return buffer.toString();
}

/// Bottom sheet letting the user choose to share stats as text or as image.
Future<void> showStatsShareSheet(BuildContext context, UserStats stats) async {
  final choice = await showModalBottomSheet<String>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(sheetContext).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Shpërndaj Statistikat',
                  style: Theme.of(sheetContext).textTheme.titleMedium),
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading:
                const Icon(Icons.image_rounded, color: AppColors.primary),
            title: const Text('Si imazh'),
            subtitle: const Text('Kartelë e dizajnuar për t\'u ndarë'),
            onTap: () => Navigator.pop(sheetContext, 'image'),
          ),
          ListTile(
            leading: const Icon(Icons.text_snippet_rounded,
                color: AppColors.primary),
            title: const Text('Si tekst'),
            subtitle: const Text('Përmbledhje me shkrim'),
            onTap: () => Navigator.pop(sheetContext, 'text'),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );

  if (choice == 'text') {
    await SharePlus.instance.share(
      ShareParams(text: buildStatsShareText(stats)),
    );
  } else if (choice == 'image' && context.mounted) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => StatsShareImageScreen(stats: stats),
    ));
  }
}

class StatsShareImageScreen extends StatefulWidget {
  final UserStats stats;
  const StatsShareImageScreen({super.key, required this.stats});

  @override
  State<StatsShareImageScreen> createState() => _StatsShareImageScreenState();
}

class _StatsShareImageScreenState extends State<StatsShareImageScreen> {
  final _cardKey = GlobalKey();
  bool _busy = false;

  Future<Uint8List?> _captureBytes() async {
    final boundary =
        _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  Future<void> _share() async {
    setState(() => _busy = true);
    try {
      final bytes = await _captureBytes();
      if (bytes == null) return;
      final dir = await getTemporaryDirectory();
      final file = File(
          '${dir.path}/al_mizan_statistikat_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(bytes);
      await SharePlus.instance.share(ShareParams(
        files: [XFile(file.path)],
        text: 'Statistikat e mia në Al Mizan 📿',
      ));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _saveToGallery() async {
    setState(() => _busy = true);
    try {
      final bytes = await _captureBytes();
      if (bytes == null || !mounted) return;
      await Gal.putImageBytes(bytes,
          album: 'Al Mizan', name: 'al_mizan_statistikat');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('U ruajt në galeri!'),
      ));
    } on GalException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Nuk u ruajt: ${e.type.message}'),
      ));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shpërndaj si Imazh')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: RepaintBoundary(
                    key: _cardKey,
                    child: _StatsShareCard(stats: widget.stats),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _busy ? null : _saveToGallery,
                      icon: const Icon(Icons.download_rounded),
                      label: const Text('Ruaj në Galeri'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _busy ? null : _share,
                      icon: _busy
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.share_rounded),
                      label: const Text('Shpërndaje'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsShareCard extends StatelessWidget {
  final UserStats stats;
  const _StatsShareCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pct =
        stats.lessonsTotal > 0 ? stats.lessonsDone / stats.lessonsTotal : 0.0;
    return Container(
      width: 340,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryContainer],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('assets/icon/app_icon.png',
                    width: 40, height: 40),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Al Mizan',
                      style: theme.textTheme.titleLarge?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.bold)),
                  Text('Mëso Fikhun',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.onPrimary.withValues(alpha: 0.7))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('${stats.lessonsDone}/${stats.lessonsTotal}',
              style: theme.textTheme.displaySmall?.copyWith(
                  color: AppColors.onPrimary, fontWeight: FontWeight.bold)),
          Text('mësime të përfunduara (${(pct * 100).toStringAsFixed(0)}%)',
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.85))),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: AppColors.onPrimary.withValues(alpha: 0.15),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primaryFixed),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _MiniStat(
                  icon: Icons.local_fire_department_rounded,
                  value: '${stats.learningStreak}',
                  label: 'ditë rresht'),
              const SizedBox(width: 10),
              _MiniStat(
                  icon: Icons.quiz_rounded,
                  value: '${stats.quizAttempts}',
                  label: 'kuize të bëra'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _MiniStat(
                  icon: Icons.percent_rounded,
                  value: stats.quizAttempts > 0
                      ? '${stats.avgScore.toStringAsFixed(0)}%'
                      : '—',
                  label: 'mesatarja e kuizeve'),
              const SizedBox(width: 10),
              _MiniStat(
                  icon: Icons.bookmark_rounded,
                  value: '${stats.bookmarksCount}',
                  label: 'shënime'),
            ],
          ),
          if (stats.bestScore > 0) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                _MiniStat(
                    icon: Icons.emoji_events_rounded,
                    value: '${stats.bestScore.toStringAsFixed(0)}%',
                    label: 'rezultati më i mirë'),
              ],
            ),
          ],
          const SizedBox(height: 20),
          const _SectionLabel('SFIDAT'),
          const SizedBox(height: 8),
          _ChallengeRow(
            icon: Icons.today_rounded,
            label: 'Sfida Ditore',
            streak: stats.dailyStreak,
            streakUnit: 'ditë',
            lastScore: stats.dailyLastScore,
          ),
          const SizedBox(height: 8),
          _ChallengeRow(
            icon: Icons.date_range_rounded,
            label: 'Sfida Javore',
            streak: stats.weeklyStreak,
            streakUnit: 'javë',
            lastScore: stats.weeklyLastScore,
          ),
          const SizedBox(height: 20),
          const _SectionLabel('PROGRESI SIPAS NIVELEVE'),
          const SizedBox(height: 10),
          for (final level in stats.perLevel) ...[
            Row(
              children: [
                Icon(kLevelIcons[level.level],
                    size: 14,
                    color: AppColors.onPrimary.withValues(alpha: 0.85)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    kLevelLabels[level.level] ?? level.level,
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.onPrimary.withValues(alpha: 0.85)),
                  ),
                ),
                Text('${level.done}/${level.total}',
                    style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: level.ratio,
                minHeight: 5,
                backgroundColor: AppColors.onPrimary.withValues(alpha: 0.15),
                valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primaryFixed),
              ),
            ),
            if (level != stats.perLevel.last) const SizedBox(height: 10),
          ],
          const SizedBox(height: 20),
          const _SectionLabel('PROGRESI SIPAS MODULEVE'),
          const SizedBox(height: 10),
          for (final module in stats.perModule) ...[
            Row(
              children: [
                if (module.done == module.total && module.total > 0)
                  const Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Icon(Icons.check_circle_rounded,
                        size: 13, color: AppColors.primaryFixed),
                  ),
                Expanded(
                  child: Text(
                    module.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.onPrimary.withValues(alpha: 0.85)),
                  ),
                ),
                const SizedBox(width: 6),
                Text('${module.done}/${module.total}',
                    style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            if (module != stats.perModule.last) const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.onPrimary.withValues(alpha: 0.65),
          letterSpacing: 1.1,
          fontWeight: FontWeight.w700),
    );
  }
}

class _ChallengeRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final int streak;
  final String streakUnit;
  final int lastScore;

  const _ChallengeRow({
    required this.icon,
    required this.label,
    required this.streak,
    required this.streakUnit,
    required this.lastScore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.onPrimary.withValues(alpha: 0.85)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: AppColors.onPrimary.withValues(alpha: 0.85)),
          ),
        ),
        Text(
          streak > 0 ? 'seri $streak $streakUnit' : 'ende pa seri',
          style: theme.textTheme.labelSmall
              ?.copyWith(color: AppColors.onPrimary.withValues(alpha: 0.75)),
        ),
        if (lastScore > 0) ...[
          const SizedBox(width: 6),
          Text('($lastScore%)',
              style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.onPrimary, fontWeight: FontWeight.w700)),
        ],
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _MiniStat(
      {required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.onPrimary.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.onPrimary, size: 20),
            const SizedBox(height: 4),
            Text(value,
                style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.onPrimary, fontWeight: FontWeight.bold)),
            Text(label,
                style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.75)),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
