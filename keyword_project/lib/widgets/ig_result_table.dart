import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:keyword_project/modles/ig_search_model.dart';
import 'package:keyword_project/provider/ig_provider.dart';
import 'package:provider/provider.dart';

class InstagramResultTable extends StatefulWidget {
  const InstagramResultTable({Key? key}) : super(key: key);

  @override
  State<InstagramResultTable> createState() => _InstagramResultTableState();
}

class _InstagramResultTableState extends State<InstagramResultTable> {
  List<MediaElement>? filterData;
  int rowsPerPage = 10;
  int currentPage = 0;
  int sortIndex = 0;
  List<bool> sortedColumn = [false, false, false, false, false, false];

  onSortColum(int columnIndex, bool ascending) {
    switch (columnIndex) {
      case 0:
        if (ascending) {
          filterData!.sort((a, b) => a.media.caption.createdAtUtc
              .compareTo(b.media.caption.createdAtUtc));
        } else {
          filterData!.sort((a, b) => b.media.caption.createdAtUtc
              .compareTo(a.media.caption.createdAtUtc));
        }
      case 1:
        if (ascending) {
          filterData!.sort(
              (a, b) => a.media.caption.text.compareTo(b.media.caption.text));
        } else {
          filterData!.sort(
              (a, b) => b.media.caption.text.compareTo(a.media.caption.text));
        }
      case 2:
        if (ascending) {
          filterData!.sort((a, b) => a.media.caption.user.fullName
              .compareTo(b.media.caption.user.fullName));
        } else {
          filterData!.sort((a, b) => b.media.caption.user.fullName
              .compareTo(a.media.caption.user.fullName));
        }
      case 3:
        if (ascending) {
          filterData!.sort((a, b) => a.media.caption.user.username
              .compareTo(b.media.caption.user.username));
        } else {
          filterData!.sort((a, b) => b.media.caption.user.username
              .compareTo(a.media.caption.user.username));
        }
      case 4:
        if (ascending) {
          filterData!
              .sort((a, b) => a.media.likeCount.compareTo(b.media.likeCount));
        } else {
          filterData!
              .sort((a, b) => b.media.likeCount.compareTo(a.media.likeCount));
        }
      case 5:
        if (ascending) {
          filterData!.sort(
              (a, b) => a.media.commentCount.compareTo(b.media.commentCount));
        } else {
          filterData!.sort(
              (a, b) => b.media.commentCount.compareTo(a.media.commentCount));
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
        DataRow(
          cells: [
            DataCell(Text('-')),
            DataCell(Text('-')),
            DataCell(Text('-')),
            DataCell(Text('-')),
            DataCell(Text('-')),
            DataCell(Text('-')),
          ]
        )
      ]: List<DataRow>.generate(
          search.results[0].layoutContent.fillItems.length,
          (index) => DataRow(
                cells: [
                  DataCell(Text(DateFormat('yyyy/MM/dd').format(search
                      .results[0]
                      .layoutContent
                      .oneByTwoItem!
                      .clips
                      .items[index]
                      .media
                      .caption
                      .createdAtUtc))),
                  DataCell(
                    SizedBox(
                      width: 544,
                      child: Tooltip(
                        message: search.results[0].layoutContent.fillItems[index].media.caption.text
                            .toString(),
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          search.results[0].layoutContent.oneByTwoItem!.clips
                              .items[index].media.caption.text
                              .toString().replaceAll("\n", " "),
                        ),
                      ),
                    ),
                    onTap: () => launchUrl(Uri.https(site,
                        '/p/${search.results[0].layoutContent.fillItems[index].media.code.toString()}')),
                  ),
                  DataCell(
                    SizedBox(
                        width: 96,
                        child: Tooltip(
                          message: search.results[0].layoutContent.fillItems[index].media.caption.user.fullName,
                          child: Text(
                              overflow: TextOverflow.ellipsis,
                              search
                                  .results[0]
                                  .layoutContent
                                  .oneByTwoItem!
                                  .clips
                                  .items[index]
                                  .media
                                  .caption
                                  .user
                                  .fullName),
                        )),
                    onTap: () => launchUrl(Uri.https(site,
                        '${search.results[0].layoutContent.fillItems[index].media.caption.user.username.toString()}')),
                  ),
                  DataCell(
                    SizedBox(
                        width: 96,
                        child: Tooltip(
                          message: search.results[0].layoutContent.fillItems[index].media.caption.user.username,
                          child: Text(
                              overflow: TextOverflow.ellipsis,
                              search
                                  .results[0]
                                  .layoutContent
                                  .oneByTwoItem!
                                  .clips
                                  .items[index]
                                  .media
                                  .caption
                                  .user
                                  .username),
                        )),
                    onTap: () => launchUrl(Uri.https(
                        site,
                        search.results[0].layoutContent.oneByTwoItem!.clips
                            .items[index].media.caption.user.username
                            .toString())),
                  ),
                  DataCell(Text(search.results[0].layoutContent.fillItems[index].media.likeCount
                      .toString())),
                  DataCell(Text(search.results[0].layoutContent.fillItems[index].media.commentCount
                      .toString())),
                ],
                onSelectChanged: (bool? value) {},
              )),
    );

    filterData = isNoResult? []:searchInstagram.results[0].layoutContent.fillItems;

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
                  '創作者',
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
            rows: isNoResult? []:getDataRow,
          ),
        ),
      ),
    );
  }
}
