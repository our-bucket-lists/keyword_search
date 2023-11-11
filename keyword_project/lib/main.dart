import 'package:flutter/material.dart';

import 'package:keyword_project/screens/home_screen.dart';
import 'package:keyword_project/widgets/app_theme.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KEYWORD SEARCHING',
      theme: myDarkTheme,
      home: HomeScreen()
    );
  }
}
