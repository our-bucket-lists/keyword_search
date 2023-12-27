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
  Set<Platforms> _selectedPlatform = <Platforms>{Platforms.youtube};

  late AnimationController pixnetProgressIndicator;
  late AnimationController youtubeProgressIndicator;
  late AnimationController instagramProgressIndicator;

  Widget _getSelectedFilter() {
    switch (_selectedPlatform.elementAt(0)) {
      case Platforms.pixnet:
        return const PixnetFilter();
      case Platforms.instagram:
        return const InstagramFilter();
      default:
        return const YoutubeFilter();
    }
  }
  
  Widget _getSelectedTable() {
    switch (_selectedPlatform.elementAt(0)) {
      case Platforms.pixnet:
        return const PixnetResultTable();
      case Platforms.instagram:
        return const InstagramResultTable();
      default:
        return const YoutubeResultTable();
    }
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
  void initState() {
    pixnetProgressIndicator = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    pixnetProgressIndicator.repeat();
    youtubeProgressIndicator = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    youtubeProgressIndicator.repeat();
    instagramProgressIndicator = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    instagramProgressIndicator.repeat();
    super.initState();
  }

  @override
  void dispose() {
    pixnetProgressIndicator.dispose();
    youtubeProgressIndicator.dispose();
    instagramProgressIndicator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var pixnetProvider = context.watch<PixnetSearchProvider>();
    var instagramProvider = context.watch<InstagramSearchProvider>();
    var youtubeProvider = context.watch<YoutubeSearchProvider>();

    Widget getSelectedLoadingCounter() {
      switch (_selectedPlatform.elementAt(0)) {
        case Platforms.pixnet:
          return Text(
            '顯示${pixnetProvider.displayedData.length}筆/載入${pixnetProvider.originalData.length}筆',
            style: Theme.of(context).textTheme.labelMedium,
          );
        case Platforms.instagram:
          return Text(
            '顯示${instagramProvider.displayedData.length}筆/載入${instagramProvider.originalData.length}筆',
            style: Theme.of(context).textTheme.labelMedium,
          );
        default:
          return Text(
            '顯示${youtubeProvider.displayedData.length}筆/載入${youtubeProvider.originalData.length}筆',
            style: Theme.of(context).textTheme.labelMedium,
          );
      }
    }

    Widget getSelectedExportButton() {
      switch (_selectedPlatform.elementAt(0)) {
        case Platforms.pixnet:
          return FilledButton.tonalIcon(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => PixnetExportDialog(
                onSubmitted: () async {
                  log(pixnetProvider.selectedColumns.toString());
                  Navigator.pop(context);
                  await downloadCSV(pixnetProvider.exportCsv, 'Pixnet_${pixnetProvider.searchText}_${DateFormat('yyMMddhhmmss').format(DateTime.now())}');
                },
              )
            ),
            label: Text('匯出', style: Theme.of(context).textTheme.labelMedium,),
            icon: const Icon(Icons.file_download,),
          );
        case Platforms.instagram:
          return FilledButton.tonalIcon(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => InstagramExportDialog(
                onSubmitted: () async {
                  log(instagramProvider.selectedColumns.toString());
                  Navigator.pop(context);
                  await downloadCSV(instagramProvider.exportCsv, 'Instagram_${instagramProvider.searchText}_${DateFormat('yyMMddhhmmss').format(DateTime.now())}');
                },
              )
            ),
            label: Text('匯出', style: Theme.of(context).textTheme.labelMedium,),
            icon: const Icon(Icons.file_download,),
          );
        default:
          return FilledButton.tonalIcon(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => YoutubeExportDialog(
                onSubmitted: () async {
                  log(youtubeProvider.selectedColumns.toString());
                  Navigator.pop(context);
                  await downloadCSV(youtubeProvider.exportCsv, 'YouTube_${youtubeProvider.searchText}_${DateFormat('yyMMddhhmmss').format(DateTime.now())}');
                },
              )
            ),
            label: Text('匯出', style: Theme.of(context).textTheme.labelMedium,),
            icon: const Icon(Icons.file_download,),
          );
      }
    }

    Widget getSelectedProgressIndicator() {
      switch (_selectedPlatform.elementAt(0)) {
        case Platforms.pixnet:
          return LinearProgressIndicator(value: pixnetProvider.isLoading?pixnetProgressIndicator.value:0,);
        case Platforms.instagram:
          return LinearProgressIndicator(value: instagramProvider.isLoading?instagramProgressIndicator.value:0,);
        default:
          return LinearProgressIndicator(value: youtubeProvider.isLoading?youtubeProgressIndicator.value:0,);
      }
    }

    Widget getSelectedLoadMoreButton() {
      switch (_selectedPlatform.elementAt(0)) {
        case Platforms.pixnet:
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: pixnetProvider.originalData.isNotEmpty&&pixnetProvider.displayedData.length<12?
            FilledButton.tonal(
              child: Text(
                '載入更多',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              onPressed: () {
                switch (_selectedPlatform.elementAt(0)) {
                  case Platforms.pixnet:
                    pixnetProvider.onLoadMore();
                    break;
                  case Platforms.instagram:
                    break;
                  case Platforms.youtube:
                    pixnetProvider.onLoadMore();
                  default:
                    break;
                }
              },
            ):Container(),
          );
        case Platforms.instagram:
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: instagramProvider.originalData.isNotEmpty&&instagramProvider.displayedData.length<12?
            FilledButton.tonal(
              child: Text(
                '載入更多',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              onPressed: () {
                switch (_selectedPlatform.elementAt(0)) {
                  case Platforms.pixnet:
                    pixnetProvider.onLoadMore();
                    break;
                  case Platforms.instagram:
                    instagramProvider.onLoadMore();
                    break;
                  case Platforms.youtube:
                    youtubeProvider.onLoadMore();
                  default:
                    break;
                }
              },
            ):Container(),
          );
        default:
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: youtubeProvider.originalData.isNotEmpty&&youtubeProvider.displayedData.length<12?
            FilledButton.tonal(
              child: Text(
                '載入更多',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              onPressed: () {
                switch (_selectedPlatform.elementAt(0)) {
                  case Platforms.pixnet:
                    pixnetProvider.onLoadMore();
                    break;
                  case Platforms.instagram:
                    break;
                  case Platforms.youtube:
                    youtubeProvider.onLoadMore();
                  default:
                    break;
                }
              },
            ):Container(),
          );
      }
    }

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
                      log('Search Keyword: $value');
                      pixnetProvider.searchText = instagramProvider.searchText = youtubeProvider.searchText = value;
                      try {
                        pixnetProvider.search();
                      } finally {
                        try {
                          instagramProvider.search();
                        } finally {
                          try {
                            youtubeProvider.search();
                          }
                          finally {

                          }
                        }
                      }
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
                  // Table Switch
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
                  // Filter
                  Expanded(
                    child: _getSelectedFilter(),
                  ),
                  // Export
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: getSelectedExportButton(),
                  )
                ],
              ),
            ),
          ),
          // Progress Indicator
          getSelectedProgressIndicator(),
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
          // Load More
          getSelectedLoadMoreButton(),
          // Counter
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16))
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:  getSelectedLoadingCounter(),
            ),
          )
        ]
      ),
    );
  }
}