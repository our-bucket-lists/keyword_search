import 'package:flutter/material.dart';

class MyResultTable extends StatefulWidget {
  const MyResultTable({super.key});

  @override
  State<MyResultTable> createState() => _MyResultTableState();
}

class _MyResultTableState extends State<MyResultTable> {
  static const int numItems = 10;
  List<bool> selected = List<bool>.generate(numItems, (int index) => false);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DataTable(
        // headingRowColor: MaterialStateColor.resolveWith((states) => Colors.white.withAlpha(40)),
        border: TableBorder(
          horizontalInside: BorderSide(
            width: 2, 
            color: Theme.of(context).colorScheme.onBackground,
            style: BorderStyle.solid
          )
        ),
        headingTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
        dataTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        columns: const <DataColumn>[
          DataColumn(
            label: Text('創作者'),
          ),
          DataColumn(
            label: Text('Email'),
          ),
          DataColumn(
            label: Text('連結'),
          ),
          DataColumn(
            label: Text('觀看次'),
          ),
        ],
        rows: List<DataRow>.generate(
          numItems,
          (int index) => DataRow(
            color: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              // All rows will have the same selected color.
              if (states.contains(MaterialState.selected)) {
                return Colors.white.withOpacity(0.2);
              }
              // Even rows will have a grey color.
              if (index.isEven) {
                return Colors.white.withOpacity(0.03);
              }
              // Odd rows will have a grey color.
              if (index.isOdd) {
                return Colors.white.withOpacity(0.06);
              }
              return null; // Use default value for other states and odd rows.
            }),
            cells: <DataCell>[
              DataCell(Text('Row $index')),
              DataCell(Text('Row $index')),
              DataCell(Text('Row $index')),
              DataCell(Text('Row $index')),
            ],
            selected: selected[index],
            onSelectChanged: (bool? value) {
              setState(() {
                selected[index] = value!;
              });
            },
          ),
        ),
      ),
    );
  }
}
