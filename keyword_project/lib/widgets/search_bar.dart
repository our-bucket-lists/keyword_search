import 'package:flutter/material.dart';

class MySearchBar extends StatefulWidget {
  const MySearchBar({super.key});

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  List<String> platforms = ['YouTube', 'Instegram', 'Pixnet'];
  List<String> selectedPlatforms = [];
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      dividerColor: Theme.of(context).colorScheme.onBackground,
      viewBackgroundColor: Theme.of(context).colorScheme.onPrimary,
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          backgroundColor: MaterialStateColor.resolveWith(
            (states) => Theme.of(context).colorScheme.onPrimary
          ),
          padding: const MaterialStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0)
          ),
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
          leading: const Icon(Icons.search),
        );
      }, 
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return List<ListTile>.generate(5, (int index) {
          final String item = 'item $index';
          return ListTile(
            title: Text(item),
            onTap: () {
              setState(() {
                controller.closeView(item);
              });
            },
          );
        });
      }
    );
  }
}
