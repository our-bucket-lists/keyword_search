import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import 'package:keyword_project/provider/ig_provider.dart';
import 'package:keyword_project/widgets/infinite_scroll_controller.dart';

class InstagramResultTable extends StatefulWidget {
  const InstagramResultTable({super.key});

  @override
  State<InstagramResultTable> createState() => _InstagramResultTableState();
}

class _InstagramResultTableState extends State<InstagramResultTable> {
  late List<bool> sortedColumn;
  final List<double> _columnWidth = [120, 640, 160, 96, 96];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var searchInstagram = context.watch<InstagramSearchProvider>();
    sortedColumn = searchInstagram.isAscendingSortedColumn;
    var getDataRow = context.select<InstagramSearchProvider, List<DataRow>>(
      (search) {
        return List<DataRow>.generate(
          search.displayedData.length,
          (index) => DataRow(
            cells: [
              DataCell(SizedBox(
                width: _columnWidth[0]-40,
                child: Text(DateFormat('yyyy/MM/dd').format(search.displayedData[index].timestamp)),
              )),
              DataCell(
                SizedBox(
                  width: _columnWidth[1]-2,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    search.displayedData[index].caption.toString().replaceAll("\n", " "),
                  ),
                ),
                onTap: () async => await launchUrl(Uri.parse(search.displayedData[index].permalink.toString())),
              ),
              DataCell(
                SizedBox(
                    width: _columnWidth[2],
                    child: Tooltip(
                      message: search.displayedData[index].username,
                      child: Text(
                          overflow: TextOverflow.ellipsis,
                          search.displayedData[index].username,),
                    )),
                onTap: () async => await launchUrl(Uri.https('www.instagram.com',search.displayedData[index].username.toString())),),
              DataCell(SizedBox(
                width: _columnWidth[3],
                child: Text(overflow: TextOverflow.ellipsis,search.displayedData[index].likeCount
                    .toString()),
              )),
              DataCell(SizedBox(
                width: _columnWidth[4],
                child: Text(overflow: TextOverflow.ellipsis,search.displayedData[index].commentsCount
                    .toString()),
              )),
            ],
            selected: searchInstagram.selectedItems.contains(searchInstagram.displayedData[index].permalink),
            onSelectChanged: (bool? isSelected) => 
              searchInstagram.onSelectChanged(isSelected, searchInstagram.displayedData[index]),
          )
        );
      } 
    );

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
        controller: InfiniteListenerController(onLoadMore: () {
          searchInstagram.onLoadMore();
        }),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: DataTable(
            clipBehavior: Clip.antiAlias,

            // Header
            showCheckboxColumn: true,
            sortAscending: sortedColumn[searchInstagram.sortedColumnIndex],
            sortColumnIndex: searchInstagram.isSortByRelevance? null: searchInstagram.sortedColumnIndex,
            columns: <DataColumn>[
              DataColumn(
                label: const Text(
                  '發布日期',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onSort: (columnIndex, isAscending) =>
                  searchInstagram.onDisplayedDataSort(columnIndex, isAscending),
              ),
              DataColumn(
                label: const Text(
                  '摘要',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onSort: (columnIndex, isAscending) =>
                  searchInstagram.onDisplayedDataSort(columnIndex, isAscending),
              ),
              DataColumn(
                label: const Text(
                  '帳號',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onSort: (columnIndex, isAscending) =>
                  searchInstagram.onDisplayedDataSort(columnIndex, isAscending),
              ),
              DataColumn(
                label: const Text(
                  '喜歡數',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onSort: (columnIndex, isAscending) =>
                  searchInstagram.onDisplayedDataSort(columnIndex, isAscending),
              ),
              DataColumn(
                label: const Text(
                  '留言數',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onSort: (columnIndex, isAscending) =>
                  searchInstagram.onDisplayedDataSort(columnIndex, isAscending),
              )
            ],

            //Content
            rows: searchInstagram.displayedData.isNotEmpty?
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
                ],
              )
            )
          ),
        ),
      ),
    );
  }
}
