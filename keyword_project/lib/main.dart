import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyword_project/provider/pixnet_posts_provider.dart';
import 'package:keyword_project/screens/home_screen.dart';
import 'package:keyword_project/common/theme.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PixnetSearchProvider()),
      ],
      child: MaterialApp(
        title: 'KEYWORD SEARCHING',
        theme: myDarkTheme,
        home: HomeScreen()
      ),
    );
  }
}
