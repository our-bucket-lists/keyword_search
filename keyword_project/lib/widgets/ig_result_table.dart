import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:keyword_project/modles/ig_media_search_model.dart';
import 'package:keyword_project/provider/ig_provider.dart';
import 'package:provider/provider.dart';

class InstagramResultTable extends StatefulWidget {
  const InstagramResultTable({Key? key}) : super(key: key);

  @override
  State<InstagramResultTable> createState() => _InstagramResultTableState();
}

class _InstagramResultTableState extends State<InstagramResultTable> {
  List<Datum>? filterData;
  int rowsPerPage = 10;
  int currentPage = 0;
  int sortIndex = 0;
  List<bool> sortedColumn = [false, false, false, false, false, false];
  final List<double> _columnWidth = [120, 640, 160, 96, 96];

  onSortColum(int columnIndex, bool ascending) {
    switch (columnIndex) {
      case 0:
        if (ascending) {
          filterData!.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        } else {
          filterData!.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        }
      case 1:
        if (ascending) {
          filterData!.sort(
              (a, b) => a.caption.compareTo(b.caption));
        } else {
          filterData!.sort(
              (a, b) => b.caption.compareTo(a.caption));
        }
      case 2:
        if (ascending) {
          filterData!.sort((a, b) => a.username.compareTo(b.username));
        } else {
          filterData!.sort((a, b) => b.username.compareTo(a.username));
        }
      case 3:
        if (ascending) {
          filterData!
              .sort((a, b) => a.likeCount.compareTo(b.likeCount));
        } else {
          filterData!
              .sort((a, b) => b.likeCount.compareTo(a.likeCount));
        }
      case 4:
        if (ascending) {
          filterData!.sort(
              (a, b) => a.commentsCount.compareTo(b.commentsCount));
        } else {
          filterData!.sort(
              (a, b) => b.commentsCount.compareTo(a.commentsCount));
        }
    }
  }

  onUpdateTable() {}

  @override
  void initState() {
    super.initState();
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String site = 'www.instagram.com';
    var searchInstagram = context.read<InstagramSearchProvider>();

    var isNoResult = context.select<InstagramSearchProvider, bool>(
      (result) => searchInstagram.results.isEmpty
    );

    var getDataRow = context.select<InstagramSearchProvider, List<DataRow>>(
      (search) => isNoResult? [
        const DataRow(
          cells: [
            DataCell(Text('-')),
            DataCell(Text('-')),
            DataCell(Text('-')),
            DataCell(Text('-')),
            DataCell(Text('-')),
          ]
        )
      ]: List<DataRow>.generate(
          search.results.length,
          (index) => DataRow(
                cells: [
                  DataCell(SizedBox(
                    width: _columnWidth[0]-40,
                    child: Text(DateFormat('yyyy/MM/dd').format(search.results[index].timestamp)),
                  )),
                  DataCell(
                    SizedBox(
                      width: _columnWidth[1]-2,
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        search.results[index].caption.toString().replaceAll("\n", " "),
                      ),
                    ),
                    onTap: () => launchUrl(Uri.parse(search.results[index].permalink.toString())),
                  ),
                  DataCell(
                    SizedBox(
                        width: _columnWidth[2],
                        child: Tooltip(
                          message: search.results[index].username,
                          child: Text(
                              overflow: TextOverflow.ellipsis,
                              search.results[index].username,),
                        )),
                    onTap: () => launchUrl(Uri.https(site,search.results[index].username.toString())),),
                  DataCell(SizedBox(
                    width: _columnWidth[3],
                    child: Text(overflow: TextOverflow.ellipsis,search.results[index].likeCount
                        .toString()),
                  )),
                  DataCell(SizedBox(
                    width: _columnWidth[4],
                    child: Text(overflow: TextOverflow.ellipsis,search.results[index].commentsCount
                        .toString()),
                  )),
                ],
                onSelectChanged: (bool? value) {},
              )),
    );

    filterData = isNoResult? []:searchInstagram.results;

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
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
                label: const Text(
                  '發布日期',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sortIndex = columnIndex;
                    sortedColumn[columnIndex] = ascending;
                  });
                  onSortColum(columnIndex, ascending);
                },
              ),
              DataColumn(
                label: const Text(
                  '摘要',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sortIndex = columnIndex;
                    sortedColumn[columnIndex] = ascending;
                  });
                  onSortColum(columnIndex, ascending);
                },
              ),
              DataColumn(
                label: const Text(
                  '帳號',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sortIndex = columnIndex;
                    sortedColumn[columnIndex] = ascending;
                  });
                  onSortColum(columnIndex, ascending);
                },
              ),
              DataColumn(
                label: const Text(
                  '喜歡數',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sortIndex = columnIndex;
                    sortedColumn[columnIndex] = ascending;
                  });
                  onSortColum(columnIndex, ascending);
                },
              ),
              DataColumn(
                label: const Text(
                  '留言數',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sortIndex = columnIndex;
                    sortedColumn[columnIndex] = ascending;
                  });
                  onSortColum(columnIndex, ascending);
                },
              )
            ],

            //Content
            rows: isNoResult? 
              List<DataRow>.generate(
                1, 
                (index) => DataRow(
                  cells: [
                    DataCell(SizedBox(width: _columnWidth[0], child: Container(),)),
                    DataCell(SizedBox(width: _columnWidth[1], child: Container(),)),
                    DataCell(SizedBox(width: _columnWidth[2], child: Container(),)),
                    DataCell(SizedBox(width: _columnWidth[3], child: Container(),)),
                    DataCell(SizedBox(width: _columnWidth[4], child: Container(),)),
                    // DataCell(SizedBox(width: 120, child: Container(),)),
                    // DataCell(SizedBox(width: 600, child: Container(),)),
                    // DataCell(SizedBox(width: 168, child: Container(),)),
                    // DataCell(SizedBox(width: 120, child: Container(),)),
                    // DataCell(SizedBox(width: 120, child: Container(),)),
                  ],
                )
              ):
              getDataRow,
          ),
        ),
      ),
    );
  }
}
