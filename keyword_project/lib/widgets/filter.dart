import 'package:flutter/material.dart';
import 'package:keyword_project/provider/pixnet_provider.dart';
import 'package:keyword_project/provider/youtube_provider.dart';
import 'package:provider/provider.dart';

enum ExerciseFilter { sortByRelevance, running, cycling, hiking }

bool isNumeric(String s) {
  try {
    double.parse(s);
    return true;
  } catch(_){
    return false;
  }
}

class YouTubeFilter extends StatefulWidget {
  const YouTubeFilter({super.key});

  @override
  State<YouTubeFilter> createState() => _YouTubeFilterState();
}

class _YouTubeFilterState extends State<YouTubeFilter> {
  Set<ExerciseFilter> filters = <ExerciseFilter>{};

  @override
  Widget build(BuildContext context) {
    var searchProvider = context.watch<YoutubeSearchProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Wrap(
        spacing: 4,
        children: [
          MyFilterChip(
            hitText: '依相關度排序', 
            selected: searchProvider.isSortByRelevance, 
            onSelected: (bool selected) => searchProvider.onDisplayedDataSortByRelevance(),
          ),
          MyFilterChip(
            hitText: '有Email', 
            selected: searchProvider.filterCriteria.mustContainsEmail, 
            onSelected: (bool selected) {
              searchProvider.filterCriteria.mustContainsEmail = selected;
              searchProvider.onDisplayedDataFilterSort();
            }
          ),
          FilterTextField(
            hitText: '標題包含',
            width: 200,
            onSubmitted: (String text) {
              if (text.isNotEmpty) {
                searchProvider.filterCriteria.titleContainedText = text;
              } else {
                searchProvider.filterCriteria.titleContainedText = '';
              }
              searchProvider.onDisplayedDataFilterSort();
            },
          ),
          FilterTextField(
            hitText: '觀看數>=',
            width:104,
            onSubmitted: (String text) {
              if (text.isNotEmpty && isNumeric(text)) {
                searchProvider.filterCriteria.viewCountLowerBound = text;
              } else {
                searchProvider.filterCriteria.viewCountLowerBound = '0';
              }
              searchProvider.onDisplayedDataFilterSort();
            },
          ),
          FilterTextField(
            hitText: '喜歡數>=',
            width: 88,
            onSubmitted: (String text) {
              if (text.isNotEmpty && isNumeric(text)) {
                searchProvider.filterCriteria.likeCountLowerBound = text;
              } else {
                searchProvider.filterCriteria.likeCountLowerBound = '0';
              }
              searchProvider.onDisplayedDataFilterSort();
            },
          ),
          FilterTextField(
            hitText: '留言數>=',
            width: 88,
            onSubmitted: (String text) {
              if (text.isNotEmpty && isNumeric(text)) {
                searchProvider.filterCriteria.commentCountLowerBound = text;
              } else {
                searchProvider.filterCriteria.commentCountLowerBound = '0';
              }
              searchProvider.onDisplayedDataFilterSort();
            },
          ),
        ]
      )
    );
  }
}

class PixnetFilter extends StatelessWidget {
  const PixnetFilter({super.key});

  @override
  Widget build(BuildContext context) {
    var searchProvider = context.watch<PixnetSearchProvider>();

    return Row(children: [
      FilterTextField(
        hitText: '標題包含',
        width: 200,
        onSubmitted: (String text) {
          searchProvider.displayedData = text.isEmpty
            ? searchProvider.originResults
            : searchProvider.displayedData
                .where((item) => item.title.toLowerCase().contains(text.toLowerCase())).toList();
        },
      ),
      FilterTextField(
        hitText: '觀看數>=',
        width: 120,
        onSubmitted: (String text) {
          searchProvider.displayedData = text.isEmpty
            ? searchProvider.originResults
            : searchProvider.displayedData
                .where((item) => item.hit>=int.parse(text)).toList();
        },
      ),
      FilterTextField(
        hitText: '留言數>=',
        width: 120,
        onSubmitted: (String text) {
          searchProvider.displayedData = text.isEmpty
            ? searchProvider.originResults
            : searchProvider.displayedData
                .where((item) => item.replyCount>=int.parse(text)).toList();
        },
      ),
    ]);
  }
}

class FilterTextField extends StatelessWidget {

  final void Function(String) onSubmitted;
  final String hitText;
  final double width;
  final double height = 34;


  const FilterTextField({
    super.key,
    required this.hitText,
    required this.width,
    required this.onSubmitted, 
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        decoration: InputDecoration(
          hintText: hitText,
          hintStyle: Theme.of(context).textTheme.labelMedium,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
        onChanged: onSubmitted,
      ),
    );
  }
}

class FilterOutlinedButton extends StatelessWidget {

  final void Function() onPressed;
  final String hitText;
  final double height = 34;


  const FilterOutlinedButton({
    super.key,
    required this.hitText,
    required this.onPressed, 
  });

  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: height,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
        ),
        onPressed: onPressed,
        child: Text(
          hitText,
          style: Theme.of(context).textTheme.labelMedium,
        )
      ),
    );
  }
}

class MyFilterChip extends StatelessWidget {
  final String hitText;
  final double height = 34;
  final bool selected;
  final void Function(bool)? onSelected;


  const MyFilterChip({
    super.key,
    required this.hitText,
    required this.selected, 
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: height,
      child: FilterChip(
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical:2),
          child: Text(
            hitText,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        selected: selected,
        onSelected: onSelected,
      ),
    );
  }
}
