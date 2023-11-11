import 'dart:js_util';

import 'package:flutter/material.dart';

class MyExportDialog extends StatefulWidget {
  const MyExportDialog({super.key});

  @override
  State<MyExportDialog> createState() => _MyExportDialogState();
}

class _MyExportDialogState extends State<MyExportDialog> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('輸出欄位'),
      content: Table(
        border: TableBorder.all(
          //color: Colors.white,
          style: BorderStyle.none
        ),
        columnWidths: const <int, TableColumnWidth>{
          0: IntrinsicColumnWidth(),
          1: IntrinsicColumnWidth(),
          2: IntrinsicColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: const <TableRow>[
          TableRow(
            children: <Widget>[
              ExportOption(text: "創作者",),
              ExportOption(text: "首頁連結",),
              ExportOption(text: "發文連結",),
            ],
          ),
          TableRow(
            children: <Widget>[
              ExportOption(text: "發布日期",),
              ExportOption(text: "Email",),
              ExportOption(text: "觀看數",),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class ExportOption extends StatefulWidget {
  const ExportOption({super.key, required this.text});
  final String text;

  @override
  State<ExportOption> createState() => _ExportOption();
}

class _ExportOption extends State<ExportOption> {
  bool _isChecked = false;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: [
          Checkbox(
            value: _isChecked,
            onChanged: (bool? value){
              setState(() {
                _isChecked = value!;
              });
            },
          ), 
          Text(widget.text),
        ],
      ),
    );
  }
  
}