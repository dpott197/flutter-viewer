import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared/character.dart';
import 'package:shared/detail_screen.dart';
import 'package:shared/detail_view.dart';

void main() {
  final Character testCharacter = Character(
    name: 'Test Character',
    description: 'Test Description',
    iconUrl: 'test_url',
  );

  testWidgets('DetailScreen displays the correct character information',
          (WidgetTester tester) async {
        // Build our app and trigger a frame.
        await tester.pumpWidget(MaterialApp(
          home: DetailScreen(character: testCharacter),
        ));

        // Verify if the app bar title displays the correct character name
        expect(find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Test Character'),
        ), findsOneWidget);

        // Verify if the DetailView widget is displayed
        expect(find.byType(DetailView), findsOneWidget);
      });
}
