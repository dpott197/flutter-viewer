import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Master-Detail Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Simpsons Characters'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic> _selectedCharacter = Map<String, dynamic>();
  List<dynamic> characters = [];

  @override
  void initState() {
    super.initState();
    _fetchCharacters();
  }

  Future<void> _fetchCharacters() async {
    final response = await http.get(Uri.parse('https://api.duckduckgo.com/?q=simpsons+characters&format=json'));

    if (response.statusCode == 200) {
      setState(() {
        characters = json.decode(response.body)['RelatedTopics'];
      });
    } else {
      // Handle error
      print('Failed to load characters');
    }
  }

  void _onCharacterTapped(Map<String, dynamic> character) {
    setState(() {
      _selectedCharacter = character;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Row(
        children: [
          // Master View
          Container(
            width: 300,
            child: ListView.builder(
              itemCount: characters.length,
              itemBuilder: (context, index) {
                var character = characters[index];
                return ListTile(
                  title: Text(character['Text'].split(' - ')[0]), // Display character name
                  onTap: () => _onCharacterTapped(character),
                );
              },
            ),
          ),

        // Detail View
          Expanded(
            child: _selectedCharacter == null
                ? Center(
              child: Text('Please select a character'),
            )
                : Center(
              child: Text(_selectedCharacter['Text'] ?? 'No description'), // Using null-aware operator
            ),
          ),
        ],
      ),
    );
  }
}
