import 'dart:developer';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:keyword_project/provider/result_table_provider.dart';



class TableSwitch extends StatelessWidget {
  const TableSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    var resultTable = context.watch<ResultTableProvider>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SegmentedButton<Platforms>(
        segments: const <ButtonSegment<Platforms>>[
          ButtonSegment<Platforms>(value: Platforms.pixnet, label: Text('Pixnet')),
          ButtonSegment<Platforms>(value: Platforms.instagram, label: Text('Instagram')),
          ButtonSegment<Platforms>(value: Platforms.youtube, label: Text('YouTube')),
        ],
        selected: resultTable.selectedPlatform,
        onSelectionChanged: (Set<Platforms> newSelection) {
          resultTable.selectedPlatform = newSelection;
        },
        multiSelectionEnabled: false,
        showSelectedIcon: false,
      ),
    );
  }
}
