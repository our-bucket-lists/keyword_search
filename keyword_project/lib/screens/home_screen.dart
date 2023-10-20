import 'package:flutter/material.dart';

import 'package:keyword_project/pages/search_page.dart';
import 'package:keyword_project/widgets/search_bar.dart';

const List<Widget> platformsOptions = <Widget>[
  Text('YouTube'),
  Text('Instegram'),
  Text('Pixnet')
];


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var selectedIndex = 0;

  final List<bool> _selectedVegetables = <bool>[false, true, false];
  bool vertical = false;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const SearchScreen();
      case 1:
        page = const Placeholder();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      // appBar: AppBar(
      //   // elevation: 4,
      //   centerTitle: false,
      //   iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
      //   automaticallyImplyLeading: false,
      //   backgroundColor: Theme.of(context).colorScheme.onBackground,
      //   leading: Icon(Icons.menu),
      //   title: Text(
      //     "展悅國際Kelivi",
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       fontStyle: FontStyle.normal,
      //       color: Theme.of(context).colorScheme.onPrimary,
      //     ),
      //   ),
      // ),
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              labelType: NavigationRailLabelType.all,
              groupAlignment: -0.7,
              backgroundColor: Theme.of(context).colorScheme.onBackground,
              unselectedLabelTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              selectedLabelTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              unselectedIconTheme: IconThemeData(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              leading: FloatingActionButton(
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.onBackground,
                onPressed: () {
                  // Add your onPressed code here!
                },
                child: Icon(
                  Icons.menu,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.search,),
                  selectedIcon: Icon(Icons.troubleshoot),
                  label: Text('Search'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.contact_mail_outlined),
                  selectedIcon: Icon(Icons.contact_mail_rounded),
                  label: Text('Contact'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children:[
                SizedBox(
                  height: 72,
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('images/logo.jpeg')
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Kelivi',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          fontSize: 32,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(width: 32),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                        child: MySearchBar(),
                      ),
                      const SizedBox(width: 32),
                      ToggleButtons(
                        direction: vertical ? Axis.vertical : Axis.horizontal,
                        onPressed: (int index) {
                          // All buttons are selectable.
                          setState(() {
                            _selectedVegetables[index] = !_selectedVegetables[index];
                          });
                        },
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        borderWidth: 2,
                        selectedBorderColor: Theme.of(context).colorScheme.onBackground,
                        selectedColor: Theme.of(context).colorScheme.onPrimary,
                        fillColor: Colors.white.withAlpha(40),
                        color: Colors.white.withAlpha(160),
                        constraints: const BoxConstraints(
                          minHeight: 40.0,
                          minWidth: 80.0,
                        ),
                        isSelected: _selectedVegetables,
                        children: platformsOptions,
                      ),
                    ],
                  )
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(160, 8, 80, 8),
                    child: page,
                  )
                ),
                // page
              ]
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        // foregroundColor: customizations[index].$1,
        // backgroundColor: customizations[index].$2,
        shape: CircleBorder(),
        elevation: 12,
        child: const Icon(Icons.output_rounded),
      ),
    );
  }
}
