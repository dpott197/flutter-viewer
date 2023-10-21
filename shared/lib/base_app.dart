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

  void _showDetails(Map character) {
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
          if (constraints.maxWidth < 600) { // Mobile view
            return ListView.separated(
              itemCount: _characters.length,
              separatorBuilder: (BuildContext context, int index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_characters[index]['Text'].split(' - ')[0]),
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
  final Map character;

  const DetailView({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          character['Icon']['URL'] != null
              ? ClipOval(
            child: Image.network(
              "https://duckduckgo.com/" + character['Icon']['URL'],
              width: 100, // you can adjust the width as you like
              height: 100, // you can adjust the height as you like
              fit: BoxFit.cover,
            ),
          )
              : Container(),
          Text(character['Text'].split(' - ')[0],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(character['Text'].split(' - ').length > 1
              ? character['Text'].split(' - ')[1]
              : 'No description available'),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Map character;

  const DetailScreen({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character['Text'].split(' - ')[0]),
      ),
      body: DetailView(character: character),
    );
  }
}
