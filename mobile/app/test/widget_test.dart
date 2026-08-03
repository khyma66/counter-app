import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_counter/main.dart';

void main() {
  testWidgets('onboarding opens mantra selection', (tester) async {
    await tester.pumpWidget(const MantraCounterApp());

    expect(find.text('Chant with focus'), findsOneWidget);
    await tester.tap(find.text('Choose a mantra'));
    await tester.pumpAndSettle();

    expect(find.text('Select mantra'), findsOneWidget);
    expect(find.text('Om Namah Shivaya'), findsOneWidget);
  });

  testWidgets('selected mantra opens live counter', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MantraSelectionScreen()));

    await tester.tap(find.text('Om Namah Shivaya'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('counter-value')), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
  });
}
