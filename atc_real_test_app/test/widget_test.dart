import 'package:flutter_test/flutter_test.dart';

import 'package:atc_real_test_app/main.dart';

void main() {
  testWidgets('real test app opens home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const AtcRealTestApp());
    await tester.pumpAndSettle();

    expect(find.text('ATC Real Test App'), findsOneWidget);
    expect(find.textContaining('QA flow:'), findsOneWidget);
  });

  testWidgets('live studio opens without build-phase notifier crash', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AtcRealTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Customize home'));
    await tester.pumpAndSettle();

    expect(find.text('Live Customizer Studio'), findsOneWidget);
  });
}
