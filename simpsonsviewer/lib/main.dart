// main.dart
import 'package:flutter/material.dart';
import 'package:shared/base_app.dart';

void main() {
  runApp(const SimpsonsApp());
}

class SimpsonsApp extends BaseApp {
  const SimpsonsApp({super.key}) : super(
    title: 'The Simpsons Character Viewer',
    apiUrl: 'https://api.duckduckgo.com/?q=simpsons+characters&format=json',
  );
}