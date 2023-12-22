import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import 'package:keyword_project/provider/pixnet_provider.dart';
import 'package:keyword_project/widgets/infinite_scroll_controller.dart';

class PixnetResultTable extends StatefulWidget {
  const PixnetResultTable({super.key});

  @override
  State<PixnetResultTable> createState() => _PixnetResultTableState();
}

class _PixnetResultTableState extends State<PixnetResultTable> {
  late List<bool> sortedColumn;
  final List<double> _columnWidth = [120, 296, 112, 112, 200, 80, 80];
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var searchPixnet = context.watch<PixnetSearchProvider>();
    sortedColumn = searchPixnet.isAscendingSortedColumn;
    var getDataRow = context.select<PixnetSearchProvider, List<DataRow>>(
      (search) { 
        return List<DataRow>.generate(
          search.displayedData.length, 
          (index) => DataRow(
            cells: [
              DataCell(
                SizedBox(
                  width: _columnWidth[0]-40,
                  child: Text(DateFormat('yyyy/MM/dd').format(search.displayedData[index].createdAt)))),
              DataCell(
                SizedBox(
                  width: _columnWidth[1]-2,
                  child: Tooltip(
                    message: search.displayedData[index].title.toString(),
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      search.displayedData[index].title.toString(),
                    ),
                  ),
                ),
                onTap: () async => await launchUrl(Uri.parse(search.displayedData[index].link.toString())),
              ),
              DataCell(
                SizedBox(
                  width: _columnWidth[2],
                  child: Tooltip(
                    message: search.displayedData[index].displayName,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      search.displayedData[index].displayName
                    ),
                  )
                ),
                onTap: () async => await launchUrl(Uri.parse('https://www.pixnet.net/pcard/${search.displayedData[index].memberUniqid.toString()}')),
              ),
              DataCell(
                SizedBox(
                  width: _columnWidth[3],
                  child: Text(overflow: TextOverflow.ellipsis,search.displayedData[index].ig.toString())),
                onTap: () {
                  if (search.displayedData[index].ig.toString().isNotEmpty) {
                    launchUrl(Uri.https('www.instagram.com','/${search.displayedData[index].ig}'));
                  }
                }
              ),
              DataCell(SizedBox(width: _columnWidth[4], child: Text(search.displayedData[index].email.toString()))),
              DataCell(SizedBox(width: _columnWidth[5], child: Text(overflow: TextOverflow.ellipsis,search.displayedData[index].hit.toString()))),
              DataCell(SizedBox(width: _columnWidth[6], child: Text(overflow: TextOverflow.ellipsis,search.displayedData[index].replyCount.toString()))),
            ],
            selected: searchPixnet.selectedItems.contains(searchPixnet.displayedData[index].link),
            onSelectChanged: (bool? isSelected) => 
              searchPixnet.onSelectChanged(isSelected, searchPixnet.displayedData[index]),
          )
        );
      }
    );

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
        controller: InfiniteListenerController(onLoadMore: () {
          searchPixnet.onLoadMore();
        }),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: DataTable(
            clipBehavior: Clip.antiAlias,
            
            // Header
            showCheckboxColumn: true,
            sortAscending: sortedColumn[searchPixnet.sortedColumnIndex],
            sortColumnIndex: searchPixnet.isSortByRelevance? null: searchPixnet.sortedColumnIndex,
            columns: <DataColumn>[
              DataColumn(
                label: const Text('發布日期', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, isAscending) =>
                  searchPixnet.onDisplayedDataSort(columnIndex, isAscending),
              ),
              DataColumn(
                label: const Text('標題', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, isAscending) =>
                  searchPixnet.onDisplayedDataSort(columnIndex, isAscending),
              ),
              DataColumn(
                label: const Text('創作者', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, isAscending) =>
                  searchPixnet.onDisplayedDataSort(columnIndex, isAscending),
              ),
              DataColumn(
                label: const Text('IG', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, isAscending) =>
                  searchPixnet.onDisplayedDataSort(columnIndex, isAscending),
              ),
              DataColumn(
                label: const Text('Email', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, isAscending) =>
                  searchPixnet.onDisplayedDataSort(columnIndex, isAscending),
              ),
              DataColumn(
                label: const Text('觀看數', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, isAscending) =>
                  searchPixnet.onDisplayedDataSort(columnIndex, isAscending),
              ),
              DataColumn(
                label: const Text('留言數', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, isAscending) =>
                  searchPixnet.onDisplayedDataSort(columnIndex, isAscending),
              ),
            ],
            
            //Content
            rows: searchPixnet.displayedData.isNotEmpty? 
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
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}
