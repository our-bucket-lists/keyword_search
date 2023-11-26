import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyword_project/provider/pixnet_provider.dart';
import 'package:keyword_project/widgets/filter.dart';

class PostSearchBar extends StatefulWidget {
  const PostSearchBar({super.key});

  @override
  State<PostSearchBar> createState() => _PostSearchBarState();
}

class _PostSearchBarState extends State<PostSearchBar> {
  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          leading: IconButton(
            icon: const Icon(Icons.search),
            onPressed: (){}
          ),
          trailing: <Widget>[
            IconButton(onPressed: (){}, icon: const Icon(Icons.tune)),
          ],
          onTap: () {},
          onChanged: (_) {},
          onSubmitted: (value) {
            log('Submit the value: $value');

            // var searchPixnet = context.read<PixnetSearchProvider>();
            var searchPixnet = context.read<PixnetSearchProvider>();

            searchPixnet.input = value;
            searchPixnet.search();
          },
        );
      }, 
      suggestionsBuilder: (BuildContext context, SearchController controller) {       
        return <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
            child: Row(
              children: [
                PlatformOptions(),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("除濕機"),
            onTap: () {
              setState(() {
                controller.closeView("除濕機");
              });
            },
          ),
        ];
      }
    );
  }
}
