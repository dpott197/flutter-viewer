import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../lib/base_app.dart'; // Your dart file's name

void main() {
  group('Character Model', () {
    test('fromJson creates a Character object correctly', () {
      final json = {
        'Text': 'CharacterName - Description',
        'Icon': {'URL': 'iconUrl'}
      };
      final character = Character.fromJson(json);

      expect(character.name, 'CharacterName');
      expect(character.description, 'Description');
      expect(character.iconUrl, 'https://duckduckgo.com/iconUrl');
    });
  });

  group('DetailView Widget', () {
    testWidgets('displays character details correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: DetailView(
          character: Character(
            name: 'CharacterName',
            description: 'Description',
            iconUrl: 'https://duckduckgo.com/iconUrl',
          ),
        ),
      ));

      expect(find.text('CharacterName'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
    });
  });

  group('MyHomePage Widget', () {
    // Define a setup function to avoid redundancy
    Future<void> _buildHomePage(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MyHomePage(
            title: 'Home', apiUrl: 'https://api.example.com/characters'),
      ));
    }

    testWidgets('initializes and displays characters correctly',
        (WidgetTester tester) async {
      await _buildHomePage(tester);

      // Pumping for the network request, you might need to adjust the duration
      await tester.pump(Duration(seconds: 2));

      expect(find.text('Search'), findsOneWidget);
      expect(find.byType(ListTile),
          findsWidgets); // Adjust according to the number of characters received
    });
  });
}
