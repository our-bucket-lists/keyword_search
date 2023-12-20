import 'package:flutter/material.dart';

class MyExportDialog extends StatelessWidget {
  final Function() onSubmitted;
  final Set<String> selectedColumns;

  const MyExportDialog({
    super.key, 
    required this.onSubmitted, 
    required this.selectedColumns,
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
        children: <TableRow>[
          TableRow(
            children: <Widget>[
              ExportOption(text: "發布日期", selectedColumns: selectedColumns,),
              ExportOption(text: "影片標題", selectedColumns: selectedColumns,),
              ExportOption(text: "影片連結", selectedColumns: selectedColumns,),
              ExportOption(text: "觀看數", selectedColumns: selectedColumns,),
              ExportOption(text: "喜歡數", selectedColumns: selectedColumns,),
            ] 
          ), 
          TableRow( 
            children: <Widget>[
              ExportOption(text: "留言數", selectedColumns: selectedColumns,),
              ExportOption(text: "頻道名稱", selectedColumns: selectedColumns,),
              ExportOption(text: "頻道連結", selectedColumns: selectedColumns,),
              ExportOption(text: "訂閱數", selectedColumns: selectedColumns,),
              ExportOption(text: "Email", selectedColumns: selectedColumns,),
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

class ExportOption extends StatefulWidget {
  final String text;
  final Set<String> selectedColumns;

  const ExportOption({
    super.key, 
    required this.text, 
    required this.selectedColumns
  });

  @override
  State<ExportOption> createState() => _ExportOptionState();
}

class _ExportOptionState extends State<ExportOption> {
  bool _isSelected = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: [
          Checkbox(
            value: _isSelected,
            onChanged: (bool? value) {
              switch (value) {
                case true:
                  widget.selectedColumns.add(widget.text);
                  break;
                default:
                  widget.selectedColumns.remove(widget.text);
                  break;
              }
              setState(() {
                _isSelected = widget.selectedColumns.contains(widget.text);
              });
            },
          ), 
          Text(widget.text),
        ],
      ),
    );
  }
}