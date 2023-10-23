import 'package:flutter/material.dart';
import 'package:shared/character.dart';
import 'package:shared/detail_view.dart';

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
