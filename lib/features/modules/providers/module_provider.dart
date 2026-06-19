import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/fiqh_data_source.dart';
import '../data/models/fiqh_models.dart';

final moduleProvider =
    FutureProvider.family<FiqhModule, String>((ref, moduleId) async {
  return FiqhDataSource().loadModule(moduleId);
});

final lessonProvider =
    FutureProvider.family<Lesson?, String>((ref, lessonId) async {
  return FiqhDataSource().findLesson(lessonId);
});
