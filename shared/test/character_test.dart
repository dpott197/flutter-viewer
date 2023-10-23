import 'package:flutter_test/flutter_test.dart';
import 'package:shared/character.dart';

void main() {
  group('Character', () {
    test('fromJson factory returns a Character with correct data', () {
      final json = {
        'Text': 'Darth Vader - Sith Lord in Star Wars',
        'Icon': {'URL': '/icons/darthvader.png'}
      };

      final character = Character.fromJson(json);

      expect(character.name, 'Darth Vader');
      expect(character.description, 'Sith Lord in Star Wars');
      expect(character.iconUrl, 'https://duckduckgo.com//icons/darthvader.png');
    });

    test('fromJson factory handles missing description', () {
      final json = {
        'Text': 'Darth Vader',
        'Icon': {'URL': '/icons/darthvader.png'}
      };

      final character = Character.fromJson(json);

      expect(character.name, 'Darth Vader');
      expect(character.description, 'No description available');
      expect(character.iconUrl, 'https://duckduckgo.com//icons/darthvader.png');
    });

    test('fromJson factory handles missing Icon URL', () {
      final json = {
        'Text': 'Darth Vader - Sith Lord in Star Wars',
        'Icon': {}
      };

      final character = Character.fromJson(json);

      expect(character.name, 'Darth Vader');
      expect(character.description, 'Sith Lord in Star Wars');
      expect(character.iconUrl, 'https://duckduckgo.com/');
    });
  });
}
