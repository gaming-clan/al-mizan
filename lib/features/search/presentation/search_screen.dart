import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/search_provider.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(searchResultsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Kërko')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Kërko mësime, tema...',
                prefixIcon: const Icon(Icons.search_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
              onChanged: (value) =>
                  ref.read(searchQueryProvider.notifier).state = value,
            ),
          ),
          Expanded(
            child: resultsAsync.when(
              data: (results) {
                if (results.isEmpty &&
                    ref.read(searchQueryProvider).isNotEmpty) {
                  return const Center(child: Text('Asnjë rezultat.'));
                }
                if (results.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_rounded,
                            size: 64,
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.3)),
                        const SizedBox(height: 16),
                        Text('Shkruaj për të kërkuar',
                            style: theme.textTheme.bodyLarge),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final r = results[index];
                    return ListTile(
                      leading: Icon(
                        r.matchType == 'title'
                            ? Icons.title_rounded
                            : Icons.article_rounded,
                      ),
                      title: Text(r.lesson.titleSq),
                      subtitle: Text(r.matchContext ?? r.moduleTitleSq),
                      onTap: () => context
                          .push('/lesson/${r.moduleId}/${r.lesson.id}'),
                    );
                  },
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Gabim: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
