import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/arabic_text_helper.dart';
import '../../features/modules/data/models/fiqh_models.dart';

class HadithCard extends StatelessWidget {
  final Evidence evidence;
  const HadithCard({super.key, required this.evidence});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: isDark ? AppColors.hadithCardBgDark : AppColors.hadithCardBg,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.format_quote_rounded,
                    size: 16, color: cs.secondary),
                const SizedBox(width: 6),
                Text(
                  'Hadith',
                  style: TextStyle(
                    color: cs.secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                if (evidence.classification != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: cs.secondary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      evidence.classification!,
                      style: TextStyle(fontSize: 10, color: cs.secondary),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Text(
              evidence.arabic,
              style: AppTypography.hadithArabic,
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
              ArabicTextHelper.formatHadithRef(
                collection: evidence.collection ?? '',
                hadithNumber: evidence.hadithNumber,
                narrator: evidence.narrator ?? '',
                classification: evidence.classification,
              ),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.secondary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
