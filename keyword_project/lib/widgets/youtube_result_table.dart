import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import 'package:keyword_project/modles/youtube_search_model.dart';
import 'package:keyword_project/provider/youtube_provider.dart';
import 'package:keyword_project/widgets/infinite_scroll_controller.dart';

class YoutubeResultTable extends StatefulWidget {
  const YoutubeResultTable({Key? key}) : super(key: key);

  @override
  State<YoutubeResultTable> createState() => _YoutubeResultTableState();
}

class _YoutubeResultTableState extends State<YoutubeResultTable> {
  List<Item>? filterData;
  int rowsPerPage = 10;
  int currentPage = 0;
  int sortIndex = 0;
  List<bool> sortedColumn= [];
  final List<double> _columnWidth = [120, 288, 64, 64, 64, 120, 64, 160];

  onSortColum(int columnIndex, bool ascending) {
    switch (columnIndex) {
      case 0:
        if (ascending) {
          filterData!.sort((a, b) => a.snippet.publishTime.compareTo(b.snippet.publishTime));
        } else {
          filterData!.sort((a, b) => b.snippet.publishTime.compareTo(a.snippet.publishTime));
        }
      case 1:
        if (ascending) {
          filterData!.sort((a, b) => a.snippet.title.compareTo(b.snippet.title));
        } else {
          filterData!.sort((a, b) => b.snippet.title.compareTo(a.snippet.title));
        }
      case 2:
        if (ascending) {
          filterData!.sort((a, b) => int.parse(a.id.videoViewCount).compareTo(int.parse(b.id.videoViewCount)));
        } else {
          filterData!.sort((a, b) => int.parse(b.id.videoViewCount).compareTo(int.parse(a.id.videoViewCount)));
        }
      case 3:
        if (ascending) {
          filterData!.sort((a, b) => int.parse(a.id.videoLikeCount).compareTo(int.parse(b.id.videoLikeCount)));
        } else {
          filterData!.sort((a, b) => int.parse(b.id.videoLikeCount).compareTo(int.parse(a.id.videoLikeCount)));
        }
      case 4:
        if (ascending) {
          filterData!.sort((a, b) => int.parse(a.id.videoCommentCount).compareTo(int.parse(b.id.videoCommentCount)));
        } else {
          filterData!.sort((a, b) => int.parse(b.id.videoCommentCount).compareTo(int.parse(a.id.videoCommentCount)));
        }
      case 5:
        if (ascending) {
          filterData!.sort((a, b) => a.snippet.channelTitle.compareTo(b.snippet.channelTitle));
        } else {
          filterData!.sort((a, b) => b.snippet.channelTitle.compareTo(a.snippet.channelTitle));
        }
      case 6:
        if (ascending) {
          filterData!.sort((a, b) => int.parse(a.snippet.followerCount).compareTo(int.parse(b.snippet.followerCount)));
        } else {
          filterData!.sort((a, b) => int.parse(b.snippet.followerCount).compareTo(int.parse(a.snippet.followerCount)));
        }
      case 7:
        if (ascending) {
          filterData!.sort((a, b) => a.snippet.email.compareTo(b.snippet.email));
        } else {
          filterData!.sort((a, b) => b.snippet.email.compareTo(a.snippet.email));
        }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var searchYoutube = context.read<YoutubeSearchProvider>();
    var getDataRow = context.select<YoutubeSearchProvider, List<DataRow>>(
      (search) => List<DataRow>.generate(
        search.results.length, 
        (index) => DataRow(
          cells: [
            DataCell(SizedBox(
              width: _columnWidth[0]-40,
              child: Text(DateFormat('yyyy/MM/dd').format(search.results[index].snippet.publishTime)))),
            DataCell(
              SizedBox(
                width: _columnWidth[1]-2,
                child: Tooltip(
                  message: search.results[index].snippet.title.toString(),
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    search.results[index].snippet.title.toString(),
                  ),
                ),
              ),
              onTap: () => launchUrl(Uri.https('www.youtube.com','/watch', {'v': search.results[index].id.videoId.toString()})),
            ),
            DataCell(SizedBox(
              width: _columnWidth[2],child: Text(overflow: TextOverflow.ellipsis,search.results[index].id.videoViewCount.toString()))),
            DataCell(SizedBox(
              width: _columnWidth[3],child: Text(overflow: TextOverflow.ellipsis,search.results[index].id.videoLikeCount.toString()))),
            DataCell(SizedBox(
              width: _columnWidth[4],child: Text(overflow: TextOverflow.ellipsis,search.results[index].id.videoCommentCount.toString()))),
            DataCell(
              SizedBox(
                width: _columnWidth[5],
                child: Tooltip(
                  message: search.results[index].snippet.channelTitle,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    search.results[index].snippet.channelTitle
                  ),
                )
              ),
              onTap: () => launchUrl(Uri.https('www.youtube.com','channel/${search.results[index].snippet.channelId}')),
            ),
            DataCell(SizedBox(
              width: _columnWidth[6],child: Text(overflow: TextOverflow.ellipsis,search.results[index].snippet.followerCount.toString()))),
            DataCell(SizedBox(
              width: _columnWidth[7],child: Text(overflow: TextOverflow.ellipsis,search.results[index].snippet.email.toString()))),
            // DataCell(Text(search.results[index].replyCount.toString())),
          ],
          onSelectChanged: (bool? value) {
          },
        )
      ),
    );

    filterData = searchYoutube.results;
    sortedColumn = searchYoutube.sortedColumn;

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
            sortAscending: sortedColumn[sortIndex],
            sortColumnIndex: sortIndex,
            columns: <DataColumn>[
              DataColumn(
                label: const Text('發布日期', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sortIndex = columnIndex;
                    sortedColumn[columnIndex] = ascending;
                  });
                  onSortColum(columnIndex, ascending);
                },
              ),
              DataColumn(
                label: const Text('標題', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sortIndex = columnIndex;
                    sortedColumn[columnIndex] = ascending;
                  });
                  onSortColum(columnIndex, ascending);
                },
              ),
              DataColumn(
                label: const Text('觀看數', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sortIndex = columnIndex;
                    sortedColumn[columnIndex] = ascending;
                  });
                  onSortColum(columnIndex, ascending);
                },
              ),
              DataColumn(
                label: const Text('喜歡數', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sortIndex = columnIndex;
                    sortedColumn[columnIndex] = ascending;
                  });
                  onSortColum(columnIndex, ascending);
                },
              ),
              DataColumn(
                label: const Text('留言數', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sortIndex = columnIndex;
                    sortedColumn[columnIndex] = ascending;
                  });
                  onSortColum(columnIndex, ascending);
                },
              ),
              DataColumn(
                label: const Text('頻道', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sortIndex = columnIndex;
                    sortedColumn[columnIndex] = ascending;
                  });
                  onSortColum(columnIndex, ascending);
                },
              ),
              DataColumn(
                label: const Text('訂閱數', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sortIndex = columnIndex;
                    sortedColumn[columnIndex] = ascending;
                  });
                  onSortColum(columnIndex, ascending);
                },
              ),
              DataColumn(
                label: const Text('Email', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sortIndex = columnIndex;
                    sortedColumn[columnIndex] = ascending;
                  });
                  onSortColum(columnIndex, ascending);
                },
              ),
              // DataColumn(
              //   label: const Text('留言數', style: TextStyle(fontWeight: FontWeight.bold),),
              //   onSort: (columnIndex, ascending) {
              //     setState(() {
              //       sortIndex = columnIndex;
              //       sortedColumn[columnIndex] = ascending;
              //     });
              //     onSortColum(columnIndex, ascending);
              //   },
              // ),
            ],
            
            //Content
            rows: searchYoutube.results.isNotEmpty?
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
