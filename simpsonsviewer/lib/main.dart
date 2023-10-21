import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Simpsons Characters',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFFD966)),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> _characters = [];
  Map? _selectedCharacter;

  @override
  void initState() {
    super.initState();
    _fetchCharacters();
  }

  Future<void> _fetchCharacters() async {
    final response = await http.get(Uri.parse('https://api.duckduckgo.com/?q=simpsons+characters&format=json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> result = json.decode(response.body);
      setState(() {
        _characters = result['RelatedTopics'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simpsons Characters'),
      ),
      body: Row(
        children: [
          // Master View
          Expanded(
            child: ListView.builder(
              itemCount: _characters.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_characters[index]['Text'].split(' - ')[0]),
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
                : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _selectedCharacter!['Icon']['URL'] != null
                      ? Image.network("https://duckduckgo.com/" + _selectedCharacter!['Icon']['URL'])
                      : Container(),
                  Text(_selectedCharacter!['Text'].split(' - ')[0],
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(_selectedCharacter!['Text'].split(' - ').length > 1
                      ? _selectedCharacter!['Text'].split(' - ')[1]
                      : 'No description available'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
