import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../modules/data/models/fiqh_models.dart';

class ModuleCard extends StatelessWidget {
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
      default:
        return Icons.book_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _iconForModule(module.moduleIcon),
                  size: 28,
                  color: AppColors.primary,
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
                '${module.lessons.length} mësime',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
