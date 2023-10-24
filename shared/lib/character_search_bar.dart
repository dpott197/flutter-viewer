import 'package:flutter/material.dart';

class CharacterSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const CharacterSearchBar(
      {super.key, required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Search',
          border: OutlineInputBorder(),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
