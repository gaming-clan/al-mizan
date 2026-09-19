import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fikh_academy/app.dart';
import 'package:fikh_academy/core/constants/daily_quotes.dart';

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
}
