// Core data models for Fikh Academy content.

class FiqhModule {
  final String moduleId;
  final String titleSq;
  final String titleAr;
  final String moduleIcon;
  final String? description;
  final List<Lesson> lessons;

  const FiqhModule({
    required this.moduleId,
    required this.titleSq,
    required this.titleAr,
    required this.moduleIcon,
    this.description,
    required this.lessons,
  });

  factory FiqhModule.fromJson(Map<String, dynamic> json) {
    return FiqhModule(
      moduleId: json['module_id'] as String,
      titleSq: json['module_title_sq'] as String,
      titleAr: json['module_title_ar'] as String,
      moduleIcon: json['module_icon'] as String,
      description: json['description'] as String?,
      lessons: (json['lessons'] as List<dynamic>)
          .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Lesson {
  final String id;
  final String titleSq;
  final String titleAr;
  final String level; // beginner, intermediate, advanced
  final List<LessonSection> sections;
  final List<QuizQuestion> quiz;
  final List<String> sourceReferences;

  const Lesson({
    required this.id,
    required this.titleSq,
    required this.titleAr,
    required this.level,
    required this.sections,
    required this.quiz,
    required this.sourceReferences,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      titleSq: json['title_sq'] as String,
      titleAr: json['title_ar'] as String,
      level: json['level'] as String,
      sections: (json['sections'] as List<dynamic>)
          .map((e) => LessonSection.fromJson(e as Map<String, dynamic>))
          .toList(),
      quiz: (json['quiz'] as List<dynamic>?)
              ?.map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      sourceReferences: (json['source_references'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

class LessonSection {
  final String heading;
  final String contentSq;
  final String? ruling; // farz, vaxhib, sunnet, etc.
  final List<Evidence> evidences;
  final MadhabRulings? madhabRulings;

  const LessonSection({
    required this.heading,
    required this.contentSq,
    this.ruling,
    required this.evidences,
    this.madhabRulings,
  });

  factory LessonSection.fromJson(Map<String, dynamic> json) {
    return LessonSection(
      heading: json['heading'] as String,
      contentSq: json['content_sq'] as String,
      ruling: json['ruling'] as String?,
      evidences: (json['evidences'] as List<dynamic>?)
              ?.map((e) => Evidence.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      madhabRulings: json['madhab_rulings'] != null
          ? MadhabRulings.fromJson(
              json['madhab_rulings'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Evidence {
  final String type; // quran, hadith
  // Quran fields
  final String? surah;
  final int? surahNumber;
  final int? ayah;
  // Hadith fields
  final String? narrator;
  final String? collection;
  final int? hadithNumber;
  final String? classification; // sahih, hasen, daif
  // Common
  final String arabic;
  final String translationSq;

  const Evidence({
    required this.type,
    this.surah,
    this.surahNumber,
    this.ayah,
    this.narrator,
    this.collection,
    this.hadithNumber,
    this.classification,
    required this.arabic,
    required this.translationSq,
  });

  bool get isQuran => type == 'quran';
  bool get isHadith => type == 'hadith';

  factory Evidence.fromJson(Map<String, dynamic> json) {
    return Evidence(
      type: json['type'] as String,
      surah: json['surah'] as String?,
      surahNumber: json['surah_number'] as int?,
      ayah: json['ayah'] as int?,
      narrator: json['narrator'] as String?,
      collection: json['collection'] as String?,
      hadithNumber: json['hadith_number'] as int?,
      classification: json['classification'] as String?,
      arabic: json['arabic'] as String,
      translationSq: json['translation_sq'] as String,
    );
  }
}

class MadhabRuling {
  final String ruling;
  final String source;
  final String? additionalNote;

  const MadhabRuling({
    required this.ruling,
    required this.source,
    this.additionalNote,
  });

  factory MadhabRuling.fromJson(Map<String, dynamic> json) {
    return MadhabRuling(
      ruling: json['ruling'] as String,
      source: json['source'] as String,
      additionalNote: json['additional_note'] as String?,
    );
  }
}

class MadhabRulings {
  final MadhabRuling? hanafi;
  final MadhabRuling? maliki;
  final MadhabRuling? shafii;
  final MadhabRuling? hanbali;
  final String? consensusNote;

  const MadhabRulings({
    this.hanafi,
    this.maliki,
    this.shafii,
    this.hanbali,
    this.consensusNote,
  });

  factory MadhabRulings.fromJson(Map<String, dynamic> json) {
    return MadhabRulings(
      hanafi: json['hanafi'] != null
          ? MadhabRuling.fromJson(json['hanafi'] as Map<String, dynamic>)
          : null,
      maliki: json['maliki'] != null
          ? MadhabRuling.fromJson(json['maliki'] as Map<String, dynamic>)
          : null,
      shafii: json['shafii'] != null
          ? MadhabRuling.fromJson(json['shafii'] as Map<String, dynamic>)
          : null,
      hanbali: json['hanbali'] != null
          ? MadhabRuling.fromJson(json['hanbali'] as Map<String, dynamic>)
          : null,
      consensusNote: json['consensus_note'] as String?,
    );
  }

  /// Returns true if all four madhabs agree.
  bool get hasConsensus =>
      consensusNote != null &&
      consensusNote!.toLowerCase().contains('ixhma');

  List<MapEntry<String, MadhabRuling>> get allRulings => [
        if (hanafi != null) MapEntry('hanafi', hanafi!),
        if (maliki != null) MapEntry('maliki', maliki!),
        if (shafii != null) MapEntry('shafii', shafii!),
        if (hanbali != null) MapEntry('hanbali', hanbali!),
      ];
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json['question'] as String,
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      correctIndex: json['correct_index'] as int,
      explanation: json['explanation'] as String,
    );
  }
}
