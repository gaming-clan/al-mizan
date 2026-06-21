import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/arabic_text_helper.dart';
import '../../features/modules/data/models/fiqh_models.dart';

class QuranVerseCard extends StatelessWidget {
  final Evidence evidence;
  const QuranVerseCard({super.key, required this.evidence});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: isDark ? AppColors.quranCardBgDark : AppColors.quranCardBg,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.auto_stories_rounded, size: 16, color: cs.primary),
                const SizedBox(width: 6),
                Text(
                  'Kuran',
                  style: TextStyle(
                    color: cs.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              evidence.arabic,
              style: AppTypography.quranArabic,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
            ),
            const Divider(height: 24),
            Text(
              evidence.translationSq,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              ArabicTextHelper.formatQuranRef(
                surah: evidence.surah ?? '',
                surahNumber: evidence.surahNumber ?? 0,
                ayah: evidence.ayah ?? 0,
              ),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
