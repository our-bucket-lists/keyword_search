import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyword_project/provider/result_table_provider.dart';
import 'package:keyword_project/provider/youtube_provider.dart';
import 'package:keyword_project/provider/pixnet_provider.dart';
import 'package:keyword_project/provider/ig_provider.dart';

class PostSearchBar extends StatefulWidget {
  const PostSearchBar({super.key});

  @override
  State<PostSearchBar> createState() => _PostSearchBarState();
}

class _PostSearchBarState extends State<PostSearchBar> {
  @override
  Widget build(BuildContext context) {
    var resultTable = context.watch<ResultTableProvider>();
    var searchPixnet = context.read<PixnetSearchProvider>();
    var searchInstagram = context.read<InstagramSearchProvider>();
    var searchYoutube = context.read<YoutubeSearchProvider>();

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
          onSubmitted: (value) async {
            resultTable.isLoading = true;

            log('Search Keyword: $value');
            searchPixnet.searchText = searchInstagram.searchText = searchYoutube.searchText = value;
            await searchYoutube.search();
            resultTable.isLoading = false;
            // try {
            //   searchPixnet.search();
            // } catch (_) {
            //   rethrow;
            // } finally {
            //   try {
            //     searchInstagram.search();
            //   } catch (_) {
            //     rethrow;
            //   } finally {
            //     try {
            //       searchYoutube.search();
            //     } catch (_) {
            //       rethrow;
            //     } finally {
            //       resultTable.isLoading = false;
            //     }
            //   }
            // }
          },
        );
      }, 
      suggestionsBuilder: (BuildContext context, SearchController controller) {       
        return <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
            child: Row(
              children: [ ],
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
