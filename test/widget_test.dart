import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fikh_academy/app.dart';

void main() {
  testWidgets('App starts', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: FikhAcademyApp()),
    );
    await tester.pump();
    expect(find.text('Fikh Academy'), findsOneWidget);
  });
}
