import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared/device_type.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFFD966)),
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
  List<dynamic> _characters = [];
  Character? _selectedCharacter;

  @override
  void initState() {
    super.initState();
    _fetchCharacters();
  }

  // In your _fetchCharacters() method in the _MyHomePageState class
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
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DetailScreen(character: character),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appName),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final deviceType = DeviceType();
          if (DeviceType.isHandset(constraints.maxWidth)) { // Handset view
            return ListView.separated(
              itemCount: _characters.length,
              separatorBuilder: (BuildContext context, int index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_characters[index].name),
                  onTap: () {
                    _showDetails(_characters[index]);
                  },
                );
              },
            );
          } else { // Tablet view
            return Row(
              children: [
                // Master View
                Expanded(
                  child: ListView.separated(
                    itemCount: _characters.length,
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_characters[index].name),
                        onTap: () {
                          setState(() {
                            _selectedCharacter = _characters[index];
                          });
                        },
                      );
                    },
                  ),
                ),
                // Detail View
                Expanded(
                  child: _selectedCharacter == null
                      ? const Center(child: Text('Please select a character'))
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
        crossAxisAlignment: CrossAxisAlignment.center, // Center the content horizontally
        children: [
          character.iconUrl != null
              ? Center( // Center the ClipOval widget
            child: ClipOval(
              child: Image.network(
                character.iconUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          )
              : Container(),
          SizedBox(height: 16),
          Text(character.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(character.description),
        ],
      ),
    );
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
  final String iconUrl;

  Character({
    required this.name,
    required this.description,
    required this.iconUrl
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    String name = json['Text'].split(' - ')[0];
    String description = json['Text'].split(' - ').length > 1
        ? json['Text'].split(' - ')[1]
        : 'No description available';
    String iconUrl = "https://duckduckgo.com/" + (json['Icon']['URL'] ?? '');

    return Character(name: name, description: description, iconUrl: iconUrl);
  }
}
