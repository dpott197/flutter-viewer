import 'package:flutter/material.dart';
import 'package:shared/character.dart';
import 'package:shared/custom_divider.dart';

class CharacterList extends StatelessWidget {
  final List<Character> characters;
  final Function(Character) onTap;

  CharacterList({required this.characters, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: characters.length,
      separatorBuilder: (BuildContext context, int index) {
        return const CustomDivider();
      },
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(characters[index].name),
          onTap: () => onTap(characters[index]),
        );
      },
    );
  }
}
