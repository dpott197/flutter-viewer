// main.dart
import 'package:flutter/material.dart';
import 'package:shared/base_app.dart';

void main() {
  runApp(WireApp());
}

class WireApp extends BaseApp {
  WireApp() : super(
    title: 'The Wire Character Viewer',
    apiUrl: 'https://api.duckduckgo.com/?q=the+wire+characters&format=json',
  );
}