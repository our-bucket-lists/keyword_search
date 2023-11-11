import 'package:flutter/material.dart';

import 'package:keyword_project/widgets/export_dialog.dart';

enum PlatformFilter { creator, date, warching, likes }

class BasicFilterChip extends StatefulWidget {
  const BasicFilterChip({super.key});

  @override
  State<BasicFilterChip> createState() => _BasicFilterChipState();
}

class _BasicFilterChipState extends State<BasicFilterChip> {
  Set<PlatformFilter> filters = <PlatformFilter>{};

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8.0,
        children: PlatformFilter.values.map((PlatformFilter platform) {
          return FilterChip(
            label: Text(platform.name),
            selected: filters.contains(platform),
            onSelected: (bool selected) {
              setState(() {
                if (selected) {
                  filters.add(platform);
                } else {
                  filters.remove(platform);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }
}

enum Sizes { youtube, instegram, pixnet }

class PlatformOptions extends StatefulWidget{
  const PlatformOptions({super.key});

  @override
  State<PlatformOptions> createState() => _PlatformOptionsState();

}

class _PlatformOptionsState extends State<PlatformOptions> {
  Set<Sizes> selection = <Sizes>{Sizes.youtube};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SegmentedButton<Sizes>(
        segments: const <ButtonSegment<Sizes>>[
          ButtonSegment<Sizes>(value: Sizes.youtube, label: Text('YouTube')),
          ButtonSegment<Sizes>(value: Sizes.instegram, label: Text('Instegram')),
          ButtonSegment<Sizes>(value: Sizes.pixnet, label: Text('Pixnet')),
        ],
        selected: selection,
        onSelectionChanged: (Set<Sizes> newSelection) {
          setState(() {
            selection = newSelection;
          });
        },
        multiSelectionEnabled: true,
        showSelectedIcon: false,
      ),
    );
  }
}

class BasicFilter extends StatefulWidget {
  const BasicFilter({super.key});

  @override
  State<BasicFilter> createState() => _BasicFilterState();

}

class _BasicFilterState extends State<BasicFilter> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            PlatformOptions(),
            SizedBox(
              height: 32,
              child: VerticalDivider(
                width: 16,
                thickness: 1,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            BasicFilterChip(),  
          ],
        ),
        FilledButton.icon(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => MyExportDialog()
          ),
          label: const Text('Show Dialog'),
          icon: Icon(
            Icons.file_download,
          ),
        )
      ],
    );
  }

}
