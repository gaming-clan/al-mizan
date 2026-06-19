import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../modules/data/fiqh_data_source.dart';
import '../../modules/data/models/fiqh_models.dart';
import '../../../core/database/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final modulesProvider = FutureProvider<List<FiqhModule>>((ref) async {
  return FiqhDataSource().loadAllModules();
});

final streakProvider = FutureProvider<int>((ref) async {
  final db = ref.read(databaseProvider);
  return db.getCurrentStreak();
});
