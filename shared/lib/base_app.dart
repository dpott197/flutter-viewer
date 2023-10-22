import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BaseApp extends StatelessWidget {
  final String title;
  final String apiUrl;

  const BaseApp({
    Key? key,
    required this.title,
    required this.apiUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: MyHomePage(appName: title, apiUrl: apiUrl),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String appName;
  final String apiUrl;

  const MyHomePage({Key? key, required this.appName, required this.apiUrl}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Character> _characters = [];
  TextEditingController _searchController = TextEditingController();
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
        _characters = result.map((characterJson) => Character.fromJson(characterJson)).toList();
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
      return character.name.toLowerCase().contains(_searchController.text.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appName),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Phone layout
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredCharacters.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredCharacters[index].name),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(character: filteredCharacters[index]),
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
                          decoration: InputDecoration(
                            labelText: 'Search',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredCharacters.length,
                          itemBuilder: (context, index) {
                            var character = filteredCharacters[index];
                            return ListTile(
                              tileColor: _selectedCharacter == character
                                  ? Colors.blue.shade100  // Color when selected
                                  : null,  // Default color when not selected
                              title: Text(character.name),
                              onTap: () => _showDetails(character),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _selectedCharacter == null
                      ? Center(child: Text('Select a character to view details.'))
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

class DetailView extends StatelessWidget {
  final Character character;

  const DetailView({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ClipOval(
              child: Image.network(
                character.iconUrl ?? '', // FIXME
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 50,
                    child: Text(
                      _getInitials(character.name),
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(character.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(character.description),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    List<String> names = name.split(' ');
    String initials = '';
    int numWords = 2;

    for (var i = 0; i < names.length && i < numWords; i++) {
      if (names[i].isNotEmpty) {
        initials += names[i][0].toUpperCase();
      }
    }

    return initials;
  }
}


class DetailScreen extends StatelessWidget {
  final Character character;

  const DetailScreen({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
      ),
      body: DetailView(character: character),
    );
  }
}

class Character {
  final String name;
  final String description;
  final String? iconUrl;

  Character({
    required this.name,
    required this.description,
    this.iconUrl,
  });

  // TODO: Better error handling
  factory Character.fromJson(Map<String, dynamic> json) {
    String name = json['Text'].split(' - ')[0];
    String description = json['Text'].split(' - ').length > 1
        ? json['Text'].split(' - ')[1]
        : 'No description available';
    String iconUrl = "https://duckduckgo.com/" + (json['Icon']['URL'] ?? '');
    return Character(name: name, description: description, iconUrl: iconUrl);
  }
}
