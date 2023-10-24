import 'package:flutter/material.dart';
import 'package:shared/base_home_page.dart';

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
        // Define your light theme here
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        // Define your dark theme here
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      themeMode: ThemeMode.system, // Automatically use the system theme mode
      home: BaseHomePage(title: title, apiUrl: apiUrl),
    );
  }
}
