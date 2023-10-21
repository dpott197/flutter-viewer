import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BaseApp extends StatelessWidget {
  final String title;
  final String apiUrl;

  const BaseApp({
    Key? key,
    required this.title,
    required this.apiUrl
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
  Map? _selectedCharacter;

  @override
  void initState() {
    super.initState();
    _fetchCharacters();
  }

  Future<void> _fetchCharacters() async {
    final response = await http.get(Uri.parse(widget.apiUrl));

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
        title: Text(widget.appName), // Set AppBar title to appName
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
