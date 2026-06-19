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
                const Icon(Icons.format_quote_rounded,
                    size: 16, color: AppColors.accent),
                const SizedBox(width: 6),
                const Text(
                  'Hadith',
                  style: TextStyle(
                    color: AppColors.accent,
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
                      color: AppColors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      evidence.classification!,
                      style: const TextStyle(fontSize: 10, color: AppColors.accent),
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
                    color: AppColors.accent,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
