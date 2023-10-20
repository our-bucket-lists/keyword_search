import 'package:flutter/material.dart';

import 'package:keyword_project/widgets/filter.dart';
import 'package:keyword_project/widgets/result_table.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        MyBasicFilter(),
        MyResultTable(),
      ],
    );
  }
}