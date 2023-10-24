import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: filteredCharacters.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        indent: 16,
                        endIndent: 16,
                      ); // You can customize the Divider's appearance if you want
                    },
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredCharacters[index].name),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                  character: filteredCharacters[index]),
                            ),
                          );
                        },
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            labelText: 'Search',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: filteredCharacters.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(
                              indent: 16,
                              endIndent: 16,
                            ); // You can customize the Divider's appearance if you want
                          },
                          itemBuilder: (context, index) {
                            var character = filteredCharacters[index];
                            return ListTile(
                              tileColor: _selectedCharacter == character
                                  ? (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.blue.shade900
                                      : Colors
                                          .blue.shade100) // Color when selected
                                  : null, // Default color when not selected
                              title: Text(character.name),
                              onTap: () => _showDetails(character),
                            );
                          },
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
