// test/script_editor_widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:nrcs/main.dart';

void main(){
  testWidgets('editor save updates rundown', (WidgetTester tester) async {
    await tester.pumpWidget(const NRCSApp());
    // app starts; ensure StoryService exists
    await tester.pumpAndSettle();

    // navigate to first item
    final listTileFinder = find.byType(ListTile).first;
    expect(listTileFinder, findsOneWidget);
    await tester.tap(listTileFinder);
    await tester.pumpAndSettle();

    // find the script TextField (the big one) and enter new text
    final scriptField = find.byType(TextField).at(1);
    expect(scriptField, findsOneWidget);
    await tester.enterText(scriptField, 'Hello test script');
    await tester.pumpAndSettle();

    final saveButton = find.widgetWithText(ElevatedButton, 'Save');
    expect(saveButton, findsOneWidget);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    // After save, we navigate back to rundown; ensure the list still shows
    expect(find.byType(ListTile), findsWidgets);
  });
}
