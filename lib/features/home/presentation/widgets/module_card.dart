import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../modules/data/models/fiqh_models.dart';
import '../../../modules/providers/module_provider.dart';

class ModuleCard extends ConsumerWidget {
  final FiqhModule module;
  const ModuleCard({super.key, required this.module});

  IconData _iconForModule(String iconKey) {
    switch (iconKey) {
      case 'book_open':
        return Icons.menu_book_rounded;
      case 'droplets':
        return Icons.water_drop_rounded;
      case 'landmark':
        return Icons.mosque_rounded;
      case 'moon':
        return Icons.nightlight_round;
      case 'hand_coins':
        return Icons.volunteer_activism_rounded;
      case 'map_pin':
        return Icons.place_rounded;
      case 'handshake':
        return Icons.handshake_rounded;
      case 'utensils':
        return Icons.restaurant_rounded;
      case 'family':
        return Icons.family_restroom_rounded;
      case 'cemetery':
        return Icons.local_florist_rounded;
      case 'oath':
        return Icons.gavel_rounded;
      case 'food':
        return Icons.lunch_dining_rounded;
      case 'justice':
        return Icons.balance_rounded;
      default:
        return Icons.book_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final progress =
        ref.watch(lessonProgressProvider(module.moduleId)).valueOrNull;
    final isModuleComplete = progress != null &&
        progress.isNotEmpty &&
        progress.values.every((s) => s.isComplete);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/module/${module.moduleId}'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (isModuleComplete ? AppColors.success : cs.primary)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isModuleComplete
                      ? Icons.check_circle_rounded
                      : _iconForModule(module.moduleIcon),
                  size: 28,
                  color: isModuleComplete ? AppColors.success : cs.primary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                module.titleSq,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                isModuleComplete
                    ? 'Modul i përfunduar ✓'
                    : '${module.lessons.length} mësime',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isModuleComplete ? AppColors.success : null,
                  fontWeight: isModuleComplete ? FontWeight.w700 : null,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
