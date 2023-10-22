// main.dart
import 'package:flutter/material.dart';
import 'package:shared/base_app.dart';

void main() {
  runApp(const WireApp());
}

class WireApp extends BaseApp {
  const WireApp({super.key}) : super(
    title: 'The Wire Character Viewer',
    apiUrl: 'https://api.duckduckgo.com/?q=the+wire+characters&format=json',
  );
}