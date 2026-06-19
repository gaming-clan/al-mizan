import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../features/modules/data/models/fiqh_models.dart';

class MadhabComparison extends StatelessWidget {
  final MadhabRulings rulings;
  const MadhabComparison({super.key, required this.rulings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.compare_arrows_rounded, size: 18),
                const SizedBox(width: 8),
                Text('Krahasimi i Medh\'hebeve',
                    style: theme.textTheme.titleMedium),
              ],
            ),
            if (rulings.hasConsensus && rulings.consensusNote != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.consensusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.handshake_rounded,
                        size: 16, color: AppColors.consensusColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rulings.consensusNote!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.consensusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            for (final entry in rulings.allRulings) ...[
              _MadhabRow(
                madhabKey: entry.key,
                ruling: entry.value,
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _MadhabRow extends StatelessWidget {
  final String madhabKey;
  final MadhabRuling ruling;
  const _MadhabRow({required this.madhabKey, required this.ruling});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.madhabColor(madhabKey);
    final name = AppConstants.madhabNames[madhabKey] ?? madhabKey;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: color, width: 3)),
        color: color.withValues(alpha: 0.05),
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(height: 4),
          Text(ruling.ruling, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 2),
          Text(ruling.source,
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              )),
          if (ruling.additionalNote != null) ...[
            const SizedBox(height: 2),
            Text(ruling.additionalNote!,
                style: theme.textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}
