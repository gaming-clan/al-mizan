import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fikh_academy/app.dart';
import 'package:fikh_academy/core/constants/daily_quotes.dart';
import 'package:fikh_academy/features/ask_scholar/presentation/ask_scholar_screen.dart';
import 'package:fikh_academy/features/modules/data/fiqh_data_source.dart';

void main() {
  testWidgets('App starts', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: FikhAcademyApp()),
    );
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  test('Daily quote share text includes quote, author and source label', () {
    const quote = DailyQuote('Test quote', 'Test author');

    final shareText = buildDailyQuoteShareText(quote);

    expect(shareText, contains('Thënia e Ditës'));
    expect(shareText, contains('Test quote'));
    expect(shareText, contains('Test author'));
  });

  testWidgets('Ask scholar screen documents the missing Q&A 18 source',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AskScholarScreen()));
    await tester.pumpAndSettle();

    expect(
        find.textContaining('Audioja e pyetje-pergjigjeve të numrit 18 mungon'),
        findsOneWidget);
  });

  test('Sheikh Albanin Q&A content is integrated into module lessons',
      () async {
    final modules = await FiqhDataSource().loadAllModules();
    final salahModule = modules.firstWhere((m) => m.moduleId == 'salah');

    final hasIntegratedQnA = salahModule.lessons.any(
      (lesson) => lesson.sections.any(
        (section) =>
            section.heading.contains('Pyetja e Shejhut Albanin') ||
            section.contentSq
                .contains('A prishet namazi nëse nuk e lexon Fatihanë?'),
      ),
    );

    expect(hasIntegratedQnA, isTrue,
        reason:
            'The active Q&A 1–17 material should be present in module lesson data.');
  });
}
