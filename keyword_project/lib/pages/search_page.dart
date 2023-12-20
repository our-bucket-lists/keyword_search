import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';

import 'package:keyword_project/provider/youtube_provider.dart';
import 'package:keyword_project/provider/ig_provider.dart';
import 'package:keyword_project/provider/pixnet_provider.dart';

import 'package:keyword_project/widgets/filter.dart';
import 'package:keyword_project/widgets/export_dialog.dart';
import 'package:keyword_project/widgets/search_bar.dart';
import 'package:keyword_project/widgets/ig_result_table.dart';
import 'package:keyword_project/widgets/pixnet_result_table.dart';
import 'package:keyword_project/widgets/youtube_result_table.dart';


enum Platforms { pixnet, youtube, instagram }

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  late AnimationController controller;
  bool determinate = false;
  Set<Platforms> _selectedPlatform = <Platforms>{Platforms.youtube};
  bool _isLoading = false;
  Set<String> youtubeSelectedItems = {};

  Widget _getSelectedFilter() {
    switch (_selectedPlatform.elementAt(0)) {
      case Platforms.pixnet:
        return const PixnetFilter();
      case Platforms.instagram:
        return Container();
      case Platforms.youtube:
        return const YouTubeFilter();
      default:
        return const YouTubeFilter();
    }
  }

  Widget _getSelectedTable() {
    switch (_selectedPlatform.elementAt(0)) {
      case Platforms.pixnet:
        return const PixnetResultTable();
      case Platforms.instagram:
        return const InstagramResultTable();
      case Platforms.youtube:
        return const YoutubeResultTable();
      default:
        return const YoutubeResultTable();
    }
  }
  
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

  // Download and save CSV to your Device
  downloadCSV(String file, String fileNmae) async {
    // Convert your CSV string to a Uint8List for downloading.
    Uint8List bytes = Uint8List.fromList(utf8.encode(file));

    // This will download the file on the device.
    await FileSaver.instance.saveFile(
      name: fileNmae, // you can give the CSV file name here.
      bytes: bytes,
      ext: 'csv',
      mimeType: MimeType.csv,
    );
  }

  @override
  Widget build(BuildContext context) {
    var pixnetProvider = context.read<PixnetSearchProvider>();
    var instagramProvider = context.read<InstagramSearchProvider>();
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
                SizedBox(
                  width: 640,
                  child: PostSearchBar(
                    onSubmitted: (value) async {
                      setState(() {
                        _isLoading = true;
                      });
                      log('Search Keyword: $value');
                      pixnetProvider.searchText = instagramProvider.searchText = youtubeProvider.searchText = value;
                      await youtubeProvider.search();
                      setState(() {
                        _isLoading = false;
                      });
                      // try {
                      //   pixnetProvider.search();
                      // } catch (_) {
                      //   rethrow;
                      // } finally {
                      //   try {
                      //     instagramProvider.search();
                      //   } catch (_) {
                      //     rethrow;
                      //   } finally {
                      //     try {
                      //       youtubeProvider.search();
                      //     } catch (_) {
                      //       rethrow;
                      //     } finally {
                      //       resultTable.isLoading = false;
                      //     }
                      //   }
                      // }
                    },
                  ),
                ),
                Expanded(child: Container(),),
              ],
            ),
          ),
          // Table Switch & Filter & Export
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: SegmentedButton<Platforms>(
                      segments: const <ButtonSegment<Platforms>>[
                        ButtonSegment<Platforms>(value: Platforms.youtube, label: Text('YouTube')),
                        ButtonSegment<Platforms>(value: Platforms.instagram, label: Text('Instagram')),
                        ButtonSegment<Platforms>(value: Platforms.pixnet, label: Text('Pixnet')),
                      ],
                      selected: _selectedPlatform,
                      onSelectionChanged: (Set<Platforms> newSelection) {
                        setState(() {
                          _selectedPlatform = newSelection;
                        });
                      },
                      multiSelectionEnabled: false,
                      showSelectedIcon: false,
                    ),
                  ),
                  SizedBox(
                    height: 32,
                    child: VerticalDivider(
                      width: 16,
                      thickness: 1,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Expanded(
                    child: _getSelectedFilter(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilledButton.tonalIcon(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => MyExportDialog(
                          selectedColumns: youtubeProvider.selectedColumns,
                          onSubmitted: () async {
                            log(youtubeProvider.selectedColumns.toString());
                            Navigator.pop(context);
                            await downloadCSV(youtubeProvider.exportCsv, 'YouTube_${youtubeProvider.searchText}_${DateFormat('yyMMddhhmmss').format(DateTime.now())}');
                          },
                        )
                      ),
                      label: Text(
                        '匯出',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      icon: const Icon(
                        Icons.file_download,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // Progress Indicator
          LinearProgressIndicator(
            value: _isLoading?
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
                child: _getSelectedTable(),
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
                '顯示${youtubeProvider.displayedData.length}筆/載入${youtubeProvider.originalData.length}筆',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          )
        ]
      ),
    );
  }
}