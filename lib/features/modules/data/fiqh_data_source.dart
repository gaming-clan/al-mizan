import 'dart:convert';
import 'package:flutter/services.dart';
import 'models/fiqh_models.dart';

/// Loads fiqh content from bundled JSON assets.
class FiqhDataSource {
  static final FiqhDataSource _instance = FiqhDataSource._();
  factory FiqhDataSource() => _instance;
  FiqhDataSource._();

  final Map<String, FiqhModule> _cache = {};

  static const _assetPaths = {
    'introduction': 'lib/data/fiqh_content/module_1_introduction.json',
    'taharah': 'lib/data/fiqh_content/module_2_taharah.json',
    'salah': 'lib/data/fiqh_content/module_3_salah.json',
    'sawm': 'lib/data/fiqh_content/module_4_sawm.json',
    'zakat': 'lib/data/fiqh_content/module_5_zakat.json',
    'hajj': 'lib/data/fiqh_content/module_6_hajj.json',
    'muamalat': 'lib/data/fiqh_content/module_7_muamalat.json',
    'halal_haram': 'lib/data/fiqh_content/module_8_halal_haram.json',
    'nikah': 'lib/data/fiqh_content/module_9_nikah.json',
    'xhenaze': 'lib/data/fiqh_content/module_10_xhenaze.json',
    'betim_nedhr': 'lib/data/fiqh_content/module_11_betim_nedhr.json',
    'ushqimi_pija': 'lib/data/fiqh_content/module_12_ushqimi_pija.json',
  };

  /// All module IDs in display order.
  List<String> get moduleIds => _assetPaths.keys.toList();

  /// Load a single module by ID.
  Future<FiqhModule> loadModule(String moduleId) async {
    if (_cache.containsKey(moduleId)) return _cache[moduleId]!;

    final path = _assetPaths[moduleId];
    if (path == null) {
      throw ArgumentError('Unknown module: $moduleId');
    }

    try {
      final jsonStr = await rootBundle.loadString(path);
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      final module = FiqhModule.fromJson(json);
      _cache[moduleId] = module;
      return module;
    } catch (e) {
      throw Exception('Failed to load module "$moduleId": $e');
    }
  }

  /// Load all available modules.
  Future<List<FiqhModule>> loadAllModules() async {
    final modules = <FiqhModule>[];
    for (final id in moduleIds) {
      try {
        modules.add(await loadModule(id));
      } catch (_) {
        // Skip modules whose JSON isn't ready yet
      }
    }
    return modules;
  }

  /// Find a specific lesson across all loaded modules.
  Future<Lesson?> findLesson(String lessonId) async {
    for (final module in _cache.values) {
      for (final lesson in module.lessons) {
        if (lesson.id == lessonId) return lesson;
      }
    }
    // Try loading all modules if not found in cache
    final allModules = await loadAllModules();
    for (final module in allModules) {
      for (final lesson in module.lessons) {
        if (lesson.id == lessonId) return lesson;
      }
    }
    return null;
  }

  /// Search lessons by keyword (Albanian or Arabic).
  Future<List<SearchResult>> search(String query) async {
    final results = <SearchResult>[];
    final q = query.toLowerCase();
    final allModules = await loadAllModules();

    for (final module in allModules) {
      for (final lesson in module.lessons) {
        // Search title
        if (lesson.titleSq.toLowerCase().contains(q) ||
            lesson.titleAr.contains(query)) {
          results.add(SearchResult(
            moduleId: module.moduleId,
            moduleTitleSq: module.titleSq,
            lesson: lesson,
            matchType: 'title',
          ));
          continue;
        }
        // Search section content
        for (final section in lesson.sections) {
          if (section.heading.toLowerCase().contains(q) ||
              section.contentSq.toLowerCase().contains(q)) {
            results.add(SearchResult(
              moduleId: module.moduleId,
              moduleTitleSq: module.titleSq,
              lesson: lesson,
              matchType: 'content',
              matchContext: section.heading,
            ));
            break;
          }
        }
      }
    }
    return results;
  }
}

class SearchResult {
  final String moduleId;
  final String moduleTitleSq;
  final Lesson lesson;
  final String matchType;
  final String? matchContext;

  const SearchResult({
    required this.moduleId,
    required this.moduleTitleSq,
    required this.lesson,
    required this.matchType,
    this.matchContext,
  });
}
