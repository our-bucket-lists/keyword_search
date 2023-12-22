import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyword_project/provider/pixnet_provider.dart';
import 'package:keyword_project/provider/youtube_provider.dart';

class YoutubeExportDialog extends StatelessWidget {
  final Function() onSubmitted;
  final dynamic provider;

  const YoutubeExportDialog({
    super.key, 
    required this.onSubmitted, 
    required this.provider,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('YouTube 輸出欄位'),
      content: Table(
        border: TableBorder.all(
          //color: Colors.white,
          style: BorderStyle.none
        ),
        columnWidths: const <int, TableColumnWidth>{
          0: IntrinsicColumnWidth(),
          1: IntrinsicColumnWidth(),
          2: IntrinsicColumnWidth(),
          3: IntrinsicColumnWidth(),
          4: IntrinsicColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: const <TableRow>[
          TableRow(
            children: <Widget>[
              YoutubeExportOption(text: "發布日期",),
              YoutubeExportOption(text: "影片標題",),
              YoutubeExportOption(text: "影片連結",),
              YoutubeExportOption(text: "觀看數",),
              YoutubeExportOption(text: "喜歡數",),
            ] 
          ), 
          TableRow( 
            children: <Widget>[
              YoutubeExportOption(text: "留言數",),
              YoutubeExportOption(text: "頻道名稱",),
              YoutubeExportOption(text: "頻道連結",),
              YoutubeExportOption(text: "訂閱數",),
              YoutubeExportOption(text: "Email",),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: onSubmitted, 
          child: const Text('匯出'),
        ),
      ],
    );
  }
}

class YoutubeExportOption extends StatelessWidget {
  final String text;

  const YoutubeExportOption({
    super.key, 
    required this.text, 
  });

  @override
  Widget build(BuildContext context) {
    var youtubeProvider = context.watch<YoutubeSearchProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: [
          Checkbox(
            value: youtubeProvider.selectedColumns.contains(text),
            onChanged: (bool? value) {
              switch (value) {
                case true:
                  youtubeProvider.onAddToSelectedColumns(text);
                  break;
                default:
                  youtubeProvider.onRemoveFromSelectedColumns(text);
                  break;
              }
            },
          ), 
          Text(text),
        ],
      ),
    );
  }
}

class PixnetExportDialog extends StatelessWidget {
  final Function() onSubmitted;
  final dynamic provider;

  const PixnetExportDialog({
    super.key, 
    required this.onSubmitted, 
    required this.provider,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('痞客邦 輸出欄位'),
      content: Table(
        border: TableBorder.all(
          //color: Colors.white,
          style: BorderStyle.none
        ),
        columnWidths: const <int, TableColumnWidth>{
          0: IntrinsicColumnWidth(),
          1: IntrinsicColumnWidth(),
          2: IntrinsicColumnWidth(),
          3: IntrinsicColumnWidth(),
          4: IntrinsicColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: <TableRow>[
          const TableRow(
            children: <Widget>[
              PixnetExportOption(text: "發布日期",),
              PixnetExportOption(text: "文章標題",),
              PixnetExportOption(text: "文章連結",),
              PixnetExportOption(text: "創作者名稱",),
              PixnetExportOption(text: "創作者主頁連結",),
            ] 
          ), 
          TableRow( 
            children: <Widget>[
              const PixnetExportOption(text: "IG",),
              const PixnetExportOption(text: "Email",),
              const PixnetExportOption(text: "觀看數",),
              const PixnetExportOption(text: "留言數",),
              Container(),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: onSubmitted, 
          child: const Text('匯出'),
        ),
      ],
    );
  }
}

class PixnetExportOption extends StatelessWidget {
  final String text;

  const PixnetExportOption({
    super.key, 
    required this.text, 
  });

  @override
  Widget build(BuildContext context) {
    var youtubeProvider = context.watch<PixnetSearchProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: [
          Checkbox(
            value: youtubeProvider.selectedColumns.contains(text),
            onChanged: (bool? value) {
              switch (value) {
                case true:
                  youtubeProvider.onAddToSelectedColumns(text);
                  break;
                default:
                  youtubeProvider.onRemoveFromSelectedColumns(text);
                  break;
              }
            },
          ), 
          Text(text),
        ],
      ),
    );
  }
}