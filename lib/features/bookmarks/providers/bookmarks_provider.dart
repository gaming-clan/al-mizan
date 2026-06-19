import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../home/providers/home_provider.dart';

final bookmarksProvider = FutureProvider<List<Bookmark>>((ref) async {
  final db = ref.read(databaseProvider);
  return db.getAllBookmarks();
});
