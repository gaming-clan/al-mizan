import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../modules/data/fiqh_data_source.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<SearchResult>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return [];
  return FiqhDataSource().search(query);
});
