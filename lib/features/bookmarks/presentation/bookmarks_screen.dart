import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/providers/home_provider.dart';
import '../providers/bookmarks_provider.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarksProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Shënimet')),
      body: bookmarksAsync.when(
        data: (bookmarks) {
          if (bookmarks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border_rounded,
                      size: 64,
                      color: AppColors.primary.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text('Asnjë shënim ende.',
                      style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 8),
                  Text('Shto shënime gjatë leximit të mësimeve.',
                      style: theme.textTheme.bodySmall),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final bm = bookmarks[index];
              return Dismissible(
                key: ValueKey(bm.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: AppColors.error,
                  child:
                      const Icon(Icons.delete_rounded, color: Colors.white),
                ),
                onDismissed: (_) async {
                  final db = ref.read(databaseProvider);
                  await db.removeBookmark(bm.lessonId);
                  ref.invalidate(bookmarksProvider);
                },
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.bookmark_rounded,
                        color: AppColors.accent),
                    title: Text(bm.lessonId),
                    subtitle: Text('Moduli: ${bm.moduleId}'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded,
                        size: 16),
                    onTap: () => context
                        .push('/lesson/${bm.moduleId}/${bm.lessonId}'),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gabim: $e')),
      ),
    );
  }
}
