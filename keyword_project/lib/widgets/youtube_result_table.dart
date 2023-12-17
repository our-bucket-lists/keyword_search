import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import 'package:keyword_project/provider/youtube_provider.dart';
import 'package:keyword_project/widgets/infinite_scroll_controller.dart';

class YoutubeResultTable extends StatefulWidget {
  const YoutubeResultTable({super.key});

  @override
  State<YoutubeResultTable> createState() => _YoutubeResultTableState();
}

class _YoutubeResultTableState extends State<YoutubeResultTable> {
  int rowsPerPage = 10;
  int currentPage = 0;
  late List<bool> sortedColumn;
  final List<double> _columnWidth = [120, 288, 64, 64, 64, 120, 64, 160];
  Set<String> selectedItems = {};

  @override
  void initState() {
    super.initState();
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    var searchYoutube = context.watch<YoutubeSearchProvider>();
    sortedColumn = searchYoutube.isAscendingSortedColumn;
    var getDataRow = context.select<YoutubeSearchProvider, List<DataRow>>(
      (search) {
        // List<String> displayedDataVedioId = search.displayedData.map((e) => e.id.videoId).toList();
        // isSelectedItemsMap.removeWhere((key, value)=>!displayedDataVedioId.contains(key));
        return List<DataRow>.generate(
          search.displayedData.length, 
          (index) => DataRow(
            cells: [
              DataCell(SizedBox(
                width: _columnWidth[0]-40,
                child: Text(DateFormat('yyyy/MM/dd').format(search.displayedData[index].snippet.publishTime)))),
              DataCell(
                SizedBox(
                  width: _columnWidth[1]-2,
                  child: Tooltip(
                    message: search.displayedData[index].snippet.title,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      search.displayedData[index].snippet.title,
                    ),
                  ),
                ),
                onTap: () async => await launchUrl(Uri.https('www.youtube.com','/watch', {'v': search.displayedData[index].id.videoId})),
              ),
              DataCell(SizedBox(
                width: _columnWidth[2],child: Text(overflow: TextOverflow.ellipsis,search.displayedData[index].id.videoViewCount))),
              DataCell(SizedBox(
                width: _columnWidth[3],child: Text(overflow: TextOverflow.ellipsis,search.displayedData[index].id.videoLikeCount))),
              DataCell(SizedBox(
                width: _columnWidth[4],child: Text(overflow: TextOverflow.ellipsis,search.displayedData[index].id.videoCommentCount))),
              DataCell(
                SizedBox(
                  width: _columnWidth[5],
                  child: Tooltip(
                    message: search.displayedData[index].snippet.channelTitle,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      search.displayedData[index].snippet.channelTitle
                    ),
                  )
                ),
                onTap: () async => await launchUrl(Uri.https('www.youtube.com','channel/${search.displayedData[index].snippet.channelId}')),
              ),
              DataCell(SizedBox(
                width: _columnWidth[6],child: Text(overflow: TextOverflow.ellipsis,search.displayedData[index].snippet.followerCount))),
              DataCell(
                SizedBox(
                  width: _columnWidth[7],
                  child: Tooltip(
                    message: search.displayedData[index].snippet.email,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      search.displayedData[index].snippet.email.isNotEmpty?
                      search.displayedData[index].snippet.email.split(',')[0]:''
                    )
                  )
                )
              ),
            ],
            selected: searchYoutube.displayedData[index].isSelected,
            onSelectChanged: (bool? isSelected) {
              switch (isSelected) {
                case true:
                  searchYoutube.displayedData[index].isSelected = true;
                  setState(() {
                    selectedItems.add(search.displayedData[index].id.videoId);
                  });
                default:
                  searchYoutube.displayedData[index].isSelected = false;
                  setState(() {
                    selectedItems.remove(search.displayedData[index].id.videoId);
                  });
              } 
            },
          )
        );
      }
    );
    
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
        controller: InfiniteListenerController(onLoadMore: () {
          searchYoutube.onLoadMore();
        }),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: DataTable(
            clipBehavior: Clip.antiAlias,
            
            // Header
            showCheckboxColumn: true,
            sortAscending: sortedColumn[searchYoutube.sortedColumnIndex],
            sortColumnIndex: searchYoutube.isSortByRelevance? null: searchYoutube.sortedColumnIndex,
            columns: <DataColumn>[
              DataColumn(
                label: const Text('發布日期', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, isAscending) =>
                  searchYoutube.onDisplayedDataSort(columnIndex, isAscending),
              ),
              DataColumn(
                label: const Text('標題', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, isAscending) =>
                  searchYoutube.onDisplayedDataSort(columnIndex, isAscending),
              ),
              DataColumn(
                label: const Text('觀看數', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, isAscending) =>
                  searchYoutube.onDisplayedDataSort(columnIndex, isAscending),
              ),
              DataColumn(
                label: const Text('喜歡數', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, isAscending) =>
                  searchYoutube.onDisplayedDataSort(columnIndex, isAscending),
              ),
              DataColumn(
                label: const Text('留言數', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, isAscending) =>
                  searchYoutube.onDisplayedDataSort(columnIndex, isAscending),
              ),
              DataColumn(
                label: const Text('頻道', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, isAscending) =>
                  searchYoutube.onDisplayedDataSort(columnIndex, isAscending),
              ),
              DataColumn(
                label: const Text('訂閱數', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, isAscending) =>
                  searchYoutube.onDisplayedDataSort(columnIndex, isAscending),
              ),
              DataColumn(
                label: const Text('Email', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, isAscending) =>
                  searchYoutube.onDisplayedDataSort(columnIndex, isAscending),
              ),
            ],
            
            //Content
            rows: searchYoutube.displayedData.isNotEmpty?
              getDataRow:
              List<DataRow>.generate(
              1, 
              (index) => DataRow(
                cells: [
                  DataCell(SizedBox(width: _columnWidth[0], child: Container(),)),
                  DataCell(SizedBox(width: _columnWidth[1], child: Container(),)),
                  DataCell(SizedBox(width: _columnWidth[2], child: Container(),)),
                  DataCell(SizedBox(width: _columnWidth[3], child: Container(),)),
                  DataCell(SizedBox(width: _columnWidth[4], child: Container(),)),
                  DataCell(SizedBox(width: _columnWidth[5], child: Container(),)),
                  DataCell(SizedBox(width: _columnWidth[6], child: Container(),)),
                  DataCell(SizedBox(width: _columnWidth[7], child: Container(),)),
                ],
              )
            )
          ),
        ),
      ),
    );
  }
}
