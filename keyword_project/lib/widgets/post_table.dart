import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:keyword_project/modles/pixnet_posts_model.dart';
import 'package:keyword_project/provider/pixnet_posts_provider.dart';
import 'package:provider/provider.dart';

class Data {
  Data({
    required this.name, 
    required this.date, 
    required this.email, 
    required this.url,
    required this.watch,
    required this.like,
  });

  String? name;
  DateTime? date;
  String? email;
  String? url;
  int? watch;
  int? like;
}

List<Data> rawData = List<Data>.generate(
  295, 
  (index) => Data(
    name: 'Creator ${index+1} with hyperlink',
    date: DateTime(2023, index+1 ,index,),
    email: 'user${index+1}@mail.com',
    url: 'www.url.user${index+1}',
    watch: Random().nextInt(99999),
    like: Random().nextInt(99999),
  ),
);

class PostTable extends StatefulWidget {
  const PostTable({Key? key}) : super(key: key);

  @override
  State<PostTable> createState() => _PostTableState();
}

class _PostTableState extends State<PostTable> {
  List<Article> filterData = [];
  int rowsPerPage = 10;
  int currentPage = 0;
  int sortIndex = 0;
  bool sort = true;
  List<bool> sortedColumn= [true, false, false, false, false, false];
  
  onSortColum(int columnIndex, bool ascending) {
    switch (columnIndex) {
      case 0:
        if (ascending) {
          filterData.sort((a, b) => a.user.name.compareTo(b.user.name!));
        } else {
          filterData.sort((a, b) => b.user.name.compareTo(a.user.name!));
        }
      // case 1:
      //   if (ascending) {
      //     filterData!.sort((a, b) => a.date!.compareTo(b.date!));
      //   } else {
      //     filterData!.sort((a, b) => b.date!.compareTo(a.date!));
      //   }
      // case 2:
      //   if (ascending) {
      //     filterData!.sort((a, b) => a.email!.compareTo(b.email!));
      //   } else {
      //     filterData!.sort((a, b) => b.email!.compareTo(a.email!));
      //   }
      // case 3:
      //   if (ascending) {
      //     filterData!.sort((a, b) => a.url!.compareTo(b.url!));
      //   } else {
      //     filterData!.sort((a, b) => b.url!.compareTo(a.url!));
      //   }
      // case 4:
      //   if (ascending) {
      //     filterData!.sort((a, b) => a.watch!.compareTo(b.watch!));
      //   } else {
      //     filterData!.sort((a, b) => b.watch!.compareTo(a.watch!));
      //   }
      // case 5:
      //   if (ascending) {
      //     filterData!.sort((a, b) => a.like!.compareTo(b.like!));
      //   } else {
      //     filterData!.sort((a, b) => b.like!.compareTo(a.like!));
      //   }
    
    }
  }

  onUpdateTable() {

  }

  @override
  void initState() {
    // filterData = rawData;
    super.initState();
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var searchPixnet = context.read<PixnetSearchProvider>();

    var isResultEmpty = context.select<PixnetSearchProvider, bool>(
      (result) => result.posts.isEmpty,
    );

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
        child: DataTable(
          // Prefix
          // header: TextField(
          //   controller: controller,
          //   decoration: const InputDecoration(hintText: "Enter something to filter"),
          //   onChanged: (value) {
          //     setState(() {
          //       myData = filterData!
          //           .where((element) => element.name!.contains(value))
          //           .toList();
          //     });
          //   },
          // ),
          clipBehavior: Clip.antiAlias,
          
          // Header
          showCheckboxColumn: true,
          sortAscending: sort,
          sortColumnIndex: sortIndex,
          columns: <DataColumn>[
            DataColumn(
              label: const Text('發布日期'),
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sortedColumn[columnIndex];
                  sortedColumn[columnIndex] = sort;
                  sortIndex = columnIndex;
                });
                onSortColum(columnIndex, ascending);
              },
            ),
            DataColumn(
              label: const Text('標題（文章連結）'),
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sortedColumn[columnIndex];
                  sortedColumn[columnIndex] = sort;
                  sortIndex = columnIndex;
                });
                onSortColum(columnIndex, ascending);
              },
            ),
            DataColumn(
              label: const Text('創作者（首頁連結）'),
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sortedColumn[columnIndex];
                  sortedColumn[columnIndex] = sort;
                  sortIndex = columnIndex;
                });
                onSortColum(columnIndex, ascending);
              },
            ),
            DataColumn(
              label: const Text('Email'),
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sortedColumn[columnIndex];
                  sortedColumn[columnIndex] = sort;
                  sortIndex = columnIndex;
                });
                onSortColum(columnIndex, ascending);
              },
            ),
            DataColumn(
              label: const Text('觀看數'),onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sortedColumn[columnIndex];
                  sortedColumn[columnIndex] = sort;
                  sortIndex = columnIndex;
                });
                onSortColum(columnIndex, ascending);
              },
            ),
            DataColumn(
              label: const Text('留言數'),
              onSort: (columnIndex, ascending) {
                setState(() {
                  sort = !sortedColumn[columnIndex];
                  sortedColumn[columnIndex] = sort;
                  sortIndex = columnIndex;
                });
                onSortColum(columnIndex, ascending);
              },
            ),
          ],
          
          //Content
          rows: isResultEmpty? [
            DataRow(cells: [
              DataCell(Text("-")),
              DataCell(Text("-")),
              DataCell(Text("-")),
              DataCell(Text("-")),
              DataCell(Text("-")),
              DataCell(Text("-")),
            ])
          ]: List<DataRow>.generate(
            searchPixnet.posts!.length, 
            (index) => DataRow(
              cells: [
                DataCell(Text(DateFormat('yyyy/MM/dd').format(searchPixnet.posts[index].publicAt))),
                DataCell(
                  InkWell(
                    onTap: () => launchUrl(Uri.parse(searchPixnet.posts[index].link.toString())),
                    child: Text(searchPixnet.posts[index].title.toString(),),
                  )
                ),
                DataCell(
                  InkWell(
                    onTap: () => launchUrl(Uri.parse(searchPixnet.posts[index].user.link.toString())),
                    child: Text(searchPixnet.posts[index].user.displayName),
                  )
                ),
                DataCell(Text(searchPixnet.posts[index].user.link.toString())),
                DataCell(Text(searchPixnet.posts[index].info.hit.toString())),
                DataCell(Text(searchPixnet.posts[index].info.commentsCount.toString())),
              ],
              onSelectChanged: (bool? value) {
              },
            )
          ),
        ),
      ),
    );
  }
}
