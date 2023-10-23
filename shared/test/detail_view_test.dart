import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared/character.dart';
import 'package:shared/detail_view.dart'; // make sure this is the correct path

void main() {
  final Character testCharacter = Character(
    name: 'John Doe',
    description: 'Test Description',
    iconUrl: 'https://example.com/test_image.png',
  );

  testWidgets('DetailView displays character details correctly',
          (WidgetTester tester) async {
        // Build our app and trigger a frame.
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: DetailView(character: testCharacter),
          ),
        ));

        // Verify if the character's image is displayed
        expect(find.byType(Image), findsOneWidget);

        // Verify if the character's name is displayed correctly
        expect(find.text('John Doe'), findsOneWidget);

        // Verify if the character's description is displayed correctly
        expect(find.text('Test Description'), findsOneWidget);
      });
}
