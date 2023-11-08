import 'package:flutter/material.dart';

import 'package:keyword_project/pages/search_page.dart';
import 'package:keyword_project/pages/mail_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const SearchPage();
      case 1:
        page = const MailPage();
      case 2:
        page = const Placeholder();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SafeArea(
            child: NavigationRail(
              leading: IconButton(
                icon: const Icon(Icons.menu),
                style: const ButtonStyle(
                  fixedSize: MaterialStatePropertyAll(Size.fromRadius(28))
                ),
                onPressed: () {}, 
              ),
              destinations: const <NavigationRailDestination> [
                NavigationRailDestination(
                  label: Text('Post'),
                  icon: Icon(Icons.article_outlined),
                  selectedIcon: Icon(Icons.article),
                ),
                NavigationRailDestination(
                  label: Text('Mail'),
                  icon: Icon(Icons.mail_outlined),
                  selectedIcon: Icon(Icons.mail),
                ),
                NavigationRailDestination(
                  label: Text('Comment'),
                  icon: Icon(Icons.comment_outlined),
                  selectedIcon: Icon(Icons.comment),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              // other settings
              // groupAlignment: -0.7,
              // backgroundColor: Theme.of(context).colorScheme.onBackground,
              // unselectedLabelTextStyle: TextStyle(
              //   color: Theme.of(context).colorScheme.onPrimary,
              // ),
              // selectedLabelTextStyle: TextStyle(
              //   color: Theme.of(context).colorScheme.onSecondary,
              // ),
              // unselectedIconTheme: IconThemeData(
              //   color: Theme.of(context).colorScheme.onPrimary,
              // ),
            ),
          ),
          Expanded(
            child: page
          ),
        ],
      ),
    );
  }
}
