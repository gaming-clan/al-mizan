/// Utilities for Arabic text handling.
class ArabicTextHelper {
  ArabicTextHelper._();

  /// Returns true if the string contains Arabic characters.
  static bool containsArabic(String text) {
    return RegExp(r'[؀-ۿݐ-ݿﭐ-﷿ﹰ-﻿]')
        .hasMatch(text);
  }

  /// Wraps Arabic text with RTL embedding marks for mixed content.
  static String wrapRtl(String arabicText) {
    return '‫$arabicText‬';
  }

  /// Formats a Quran reference string.
  static String formatQuranRef({
    required String surah,
    required int surahNumber,
    required int ayah,
  }) {
    return 'Sure $surah ($surahNumber), Ajet $ayah';
  }

  /// Formats a hadith reference string.
  static String formatHadithRef({
    required String collection,
    int? hadithNumber,
    required String narrator,
    String? classification,
  }) {
    final parts = <String>[
      collection,
      if (hadithNumber != null) 'nr. $hadithNumber',
    ];
    final ref = parts.join(', ');
    final classTag = classification != null ? ' [$classification]' : '';
    return '$ref — Transmeton: $narrator$classTag';
  }
}
