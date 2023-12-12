import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import 'package:keyword_project/modles/pixnet_search_model.dart';
import 'package:keyword_project/provider/pixnet_provider.dart';

class PixnetResultTable extends StatefulWidget {
  const PixnetResultTable({Key? key}) : super(key: key);

  @override
  State<PixnetResultTable> createState() => _PixnetResultTableState();
}

class _PixnetResultTableState extends State<PixnetResultTable> {
  List<Feed>? filterData;
  int rowsPerPage = 10;
  int currentPage = 0;
  int sortedIndex = 0;
  List<bool> sortedColumn= [false, false, false, false, false, false, false];
  List<bool> selected =  List<bool>.generate(25 , (int index) => false);
  final List<double> _columnWidth = [120, 296, 112, 112, 200, 80, 80];
  

  onSortColum(int columnIndex, bool ascending) {
    switch (columnIndex) {
      case 0:
        if (ascending) {
          filterData!.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        } else {
          filterData!.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        }
      case 1:
        if (ascending) {
          filterData!.sort((a, b) => a.title.compareTo(b.title));
        } else {
          filterData!.sort((a, b) => b.title.compareTo(a.title));
        }
      case 2:
        if (ascending) {
          filterData!.sort((a, b) => a.displayName.compareTo(b.displayName));
        } else {
          filterData!.sort((a, b) => b.displayName.compareTo(a.displayName));
        }
      case 3:
        if (ascending) {
          filterData!.sort((a, b) => a.ig.compareTo(b.ig));
        } else {
          filterData!.sort((a, b) => b.ig.compareTo(a.ig));
        }
      case 4:
        if (ascending) {
          filterData!.sort((a, b) => a.email.compareTo(b.email));
        } else {
          filterData!.sort((a, b) => b.email.compareTo(a.email));
        }
      case 5:
        if (ascending) {
          filterData!.sort((a, b) => a.hit.compareTo(b.hit));
        } else {
          filterData!.sort((a, b) => b.hit.compareTo(a.hit));
        }
      case 6:
        if (ascending) {
          filterData!.sort((a, b) => a.replyCount.compareTo(b.replyCount));
        } else {
          filterData!.sort((a, b) => b.replyCount.compareTo(a.replyCount));
        }
    
    }
  }

  onUpdateTable() {

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var searchPixnet = context.read<PixnetSearchProvider>();
    var getDataRow = context.select<PixnetSearchProvider, List<DataRow>>(
      (search) => List<DataRow>.generate(
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
          selected: selected[index],
          onSelectChanged: (bool? value) {
            log('Row #$value is selected');
            setState(() {
              selected[index] = value!;
            });
          },
        )
      ),
    );

    filterData = searchPixnet.displayedData;

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
            sortAscending: sortedColumn[sortedIndex],
            sortColumnIndex: sortedIndex,
            columns: <DataColumn>[
              DataColumn(
                label: const Text('發布日期', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sortedIndex = columnIndex;
                    sortedColumn[columnIndex] = ascending;
                  });
                  onSortColum(columnIndex, ascending);
                },
              ),
              DataColumn(
                label: const Text('標題', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sortedIndex = columnIndex;
                    sortedColumn[columnIndex] = ascending;
                  });
                  onSortColum(columnIndex, ascending);
                },
              ),
              DataColumn(
                label: const Text('創作者', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sortedIndex = columnIndex;
                    sortedColumn[columnIndex] = ascending;
                  });
                  onSortColum(columnIndex, ascending);
                },
              ),
              DataColumn(
                label: const Text('IG', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sortedIndex = columnIndex;
                    sortedColumn[columnIndex] = ascending;
                  });
                  onSortColum(columnIndex, ascending);
                },
              ),
              DataColumn(
                label: const Text('Email', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sortedIndex = columnIndex;
                    sortedColumn[columnIndex] = ascending;
                  });
                  onSortColum(columnIndex, ascending);
                },
              ),
              DataColumn(
                label: const Text('觀看數', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sortedIndex = columnIndex;
                    sortedColumn[columnIndex] = ascending;
                  });
                  onSortColum(columnIndex, ascending);
                },
              ),
              DataColumn(
                label: const Text('留言數', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sortedIndex = columnIndex;
                    sortedColumn[columnIndex] = ascending;
                  });
                  onSortColum(columnIndex, ascending);
                },
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
