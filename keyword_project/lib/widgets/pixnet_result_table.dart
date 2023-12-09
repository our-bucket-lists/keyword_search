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
  int sortIndex = 0;
  List<bool> sortedColumn= [false, false, false, false, false, false, false];
  List<bool> selected =  List<bool>.generate(25 , (int index) => false);
  

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
          filterData!.sort((a, b) => a.email.compareTo(b.email));
        } else {
          filterData!.sort((a, b) => b.email.compareTo(a.email));
        }
      case 4:
        if (ascending) {
          filterData!.sort((a, b) => a.ig.compareTo(b.ig));
        } else {
          filterData!.sort((a, b) => b.ig.compareTo(a.ig));
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
        search.results.length, 
        (index) => DataRow(
          cells: [
            DataCell(
              SizedBox(
                width: 80,
                child: Text(DateFormat('yyyy/MM/dd').format(search.results[index].createdAt)))),
            DataCell(
              SizedBox(
                width: 320,
                child: Tooltip(
                  message: search.results[index].title.toString(),
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    search.results[index].title.toString(),
                  ),
                ),
              ),
              onTap: () => launchUrl(Uri.parse(search.results[index].link.toString())),
            ),
            DataCell(
              SizedBox(
                width: 120,
                child: Tooltip(
                  message: search.results[index].displayName,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    search.results[index].displayName
                  ),
                )
              ),
              onTap: () => launchUrl(Uri.parse('https://www.pixnet.net/pcard/${search.results[index].memberUniqid.toString()}')),
            ),
            DataCell(SizedBox(width: 188, child: Text(search.results[index].email.toString()))),
            DataCell(
              SizedBox(
                width: 96,
                child: Text(overflow: TextOverflow.ellipsis,search.results[index].ig.toString())),
              onTap: () {
                if (search.results[index].ig.toString().isNotEmpty) {
                  launchUrl(Uri.https('www.instagram.com','/${search.results[index].ig}'));
                }
              }
            ),
            DataCell(SizedBox(width: 72, child: Text(overflow: TextOverflow.ellipsis,search.results[index].hit.toString()))),
            DataCell(SizedBox(width:72, child: Text(overflow: TextOverflow.ellipsis,search.results[index].replyCount.toString()))),
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

    filterData = searchPixnet.results;

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
                label: const Text('創作者', style: TextStyle(fontWeight: FontWeight.bold),),
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
              DataColumn(
                label: const Text('Instagram', style: TextStyle(fontWeight: FontWeight.bold),),
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
                label: const Text('留言數', style: TextStyle(fontWeight: FontWeight.bold),),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sortIndex = columnIndex;
                    sortedColumn[columnIndex] = ascending;
                  });
                  onSortColum(columnIndex, ascending);
                },
              ),
            ],
            
            //Content
            rows: searchPixnet.results.isNotEmpty? 
              getDataRow:
              List<DataRow>.generate(
              1, 
              (index) => DataRow(
                cells: [
                  DataCell(SizedBox(width: 120, child: Container(),)),
                  DataCell(SizedBox(width: 320, child: Container(),)),
                  DataCell(SizedBox(width: 120, child: Container(),)),
                  DataCell(SizedBox(width: 188, child: Container(),)),
                  DataCell(SizedBox(width: 96, child: Container(),)),
                  DataCell(SizedBox(width: 72, child: Container(),)),
                  DataCell(SizedBox(width: 72, child: Container(),)),
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}
