// main.dart
import 'package:flutter/material.dart';
import 'package:shared/base_app.dart';

void main() {
  runApp(SimpsonsApp());
}

class SimpsonsApp extends BaseApp {
  SimpsonsApp() : super(
    title: 'The Simpsons Character Viewer',
    apiUrl: 'https://api.duckduckgo.com/?q=simpsons+characters&format=json',
  );
}