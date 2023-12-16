import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyword_project/provider/result_table_provider.dart';
import 'package:keyword_project/provider/youtube_provider.dart';

import 'package:keyword_project/widgets/filter.dart';
import 'package:keyword_project/widgets/export_dialog.dart';
import 'package:keyword_project/widgets/search_bar.dart';
import 'package:keyword_project/widgets/table_switcher.dart';




class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  late AnimationController controller;
  bool determinate = false;
  
  @override
  void initState() {
    controller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tableProvider = context.watch<ResultTableProvider>();
    var youtubeProvider = context.watch<YoutubeSearchProvider>();
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
                  backgroundImage: AssetImage('assets/images/logo.jpeg'),
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
          // Table Switch & Filter
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16))
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const TableSwitch(),
                  SizedBox(
                    height: 32,
                    child: VerticalDivider(
                      width: 16,
                      thickness: 1,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const Expanded(
                    child: YouTubeFilter()
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: FilledButton.tonalIcon(
                  //     onPressed: () => showDialog<String>(
                  //       context: context,
                  //       builder: (BuildContext context) => const MyExportDialog()
                  //     ),
                  //     label: Text(
                  //       '匯出',
                  //       style: Theme.of(context).textTheme.labelMedium,
                  //     ),
                  //     icon: const Icon(
                  //       Icons.file_download,
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
          // Progress Indicator
          LinearProgressIndicator(
            value: context.watch<ResultTableProvider>().isLoading?
              controller.value:0,
          ),
          // Content
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                // borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16))
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                child: tableProvider.selectedTable,
              ),
            )
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: youtubeProvider.originalData.isNotEmpty&&youtubeProvider.displayedData.length<11?
            FilledButton.tonal(
              child: Text(
                '載入更多',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              onPressed: () => youtubeProvider.onLoadMore(),
            ):Container(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16))
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '顯示${youtubeProvider.displayedData.length}筆/共${youtubeProvider.originalData.length}筆',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          )
        ]
      ),
    );
  }
}