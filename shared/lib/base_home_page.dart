import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared/character_search_bar.dart';
import 'package:shared/character_list.dart';

import 'character.dart';
import 'detail_screen.dart';
import 'detail_view.dart';
import 'device_type.dart';

class BaseHomePage extends StatefulWidget {
  final String title;
  final String apiUrl;

  const BaseHomePage({Key? key, required this.title, required this.apiUrl})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BaseHomePageState createState() => _BaseHomePageState();
}

class _BaseHomePageState extends State<BaseHomePage> {
  List<Character> _characters = [];
  final TextEditingController _searchController = TextEditingController();
  Character? _selectedCharacter;

  @override
  void initState() {
    super.initState();
    _fetchCharacters();
  }

  Future<void> _fetchCharacters() async {
    final response = await http.get(Uri.parse(widget.apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> result = json.decode(response.body)['RelatedTopics'];
      setState(() {
        _characters = result
            .map((characterJson) => Character.fromJson(characterJson))
            .toList();
      });
    }
  }

  void _showDetails(Character character) {
    setState(() {
      _selectedCharacter = character;
    });
  }

  @override
  Widget build(BuildContext context) {
    var filteredCharacters = _characters.where((character) {
      return character.name
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (!DeviceType.isTablet(context)) {
            // Phone layout
            return Column(
              children: [
                CharacterSearchBar(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                Expanded(
                  child: CharacterList(
                    characters: filteredCharacters,
                    onTap: (character) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailScreen(character: character),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            // Tablet layout
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      CharacterSearchBar(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      Expanded(
                        child: CharacterList(
                          characters: filteredCharacters,
                          onTap: (character) => _showDetails(character),
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(
                  indent: 16.0,
                  endIndent: 16.0,
                  color: Colors.grey, // Customize color as needed
                  thickness: 0.25, // Customize thickness as needed
                  width: 0.25, // Customize width as needed
                ),
                Expanded(
                  flex: 2,
                  child: _selectedCharacter == null
                      ? const Center(
                          child: Text('Select a character to view details.'))
                      : DetailView(character: _selectedCharacter!),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
