import 'package:flutter/material.dart';

import 'package:keyword_project/widgets/search_bar.dart';
import 'package:keyword_project/widgets/post_table.dart';
import 'package:keyword_project/widgets/filter.dart';



class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children:[
          // Search Bar
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('images/logo.jpeg'),
                  radius: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Kelivi',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(width: 128),
                const SizedBox(
                  width: 640,
                  child: PostSearchBar(),
                ),
                Expanded(child: Container(),),
              ],
            ),
          ),
          // Filter
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16))
            ),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: BasicFilter(),
            ),
          ),
          // Content
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16))
              ),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 16),
                child: PostTable(),
              ),
            )
          ),
        ]
      ),
    );
  }
}