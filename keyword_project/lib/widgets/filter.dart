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

class YoutubeFilter extends StatefulWidget {
  const YoutubeFilter({super.key});

  @override
  State<YoutubeFilter> createState() => _YoutubeFilterState();
}

class _YoutubeFilterState extends State<YoutubeFilter> {
  Set<ExerciseFilter> filters = <ExerciseFilter>{};

  final titleFilterController = TextEditingController();
  final viewCountFilterController = TextEditingController();
  final likeCountFilterController = TextEditingController();
  final commentCountFilterController = TextEditingController();

  @override
  void dispose() {
    titleFilterController.dispose();
    viewCountFilterController.dispose();
    likeCountFilterController.dispose();
    commentCountFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var searchProvider = context.watch<YoutubeSearchProvider>();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Wrap(
        spacing: 4,
        children: [
          SizedBox(
            height: 32,
            width: 32,
            child: IconButton(
              icon: const Icon(Icons.restart_alt_outlined, size: 16,),
              tooltip: '重置篩選設定',
              onPressed: () {
                searchProvider.isSortByRelevance = true;
                searchProvider.mustSelected = false;
                searchProvider.mustContainsEmail = false;
                titleFilterController.clear();
                searchProvider.titleContainedText = '';
                viewCountFilterController.clear();
                searchProvider.viewCountLowerBound = '0';
                likeCountFilterController.clear();
                searchProvider.likeCountLowerBound = '0';
                commentCountFilterController.clear();
                searchProvider.commentCountLowerBound = '0';
                searchProvider.onDisplayedDataFilterSort();
              },
            ),
          ),
          MyFilterChip(
            hitText: '依相關度排序', 
            selected: searchProvider.isSortByRelevance, 
            onSelected: (bool selected) => searchProvider.onDisplayedDataSortByRelevance(),
          ),
          MyFilterChip(
            hitText: '有Email', 
            selected: searchProvider.mustContainsEmail, 
            onSelected: (bool selected) {
              searchProvider.mustContainsEmail = selected;
              searchProvider.onDisplayedDataFilterSort();
            }
          ),
          MyFilterChip(
            hitText: '已選取', 
            selected: searchProvider.mustSelected, 
            onSelected: (bool selected) {
              searchProvider.mustSelected = selected;
              searchProvider.onDisplayedDataFilterSort();
            }
          ),
          FilterTextField(
            hitText: '標題包含',
            controller: titleFilterController,
            width: 200,
            onSubmitted: (String text) {
              if (text.isNotEmpty) {
                searchProvider.titleContainedText = text;
              } else {
                searchProvider.titleContainedText = '';
              }
              searchProvider.onDisplayedDataFilterSort();
            },
          ),
          FilterTextField(
            hitText: '觀看數>=',
            controller: viewCountFilterController,
            width:88,
            onSubmitted: (String text) {
              if (text.isNotEmpty && isNumeric(text)) {
                searchProvider.viewCountLowerBound = (double.parse(text)*1000).toString();
              } else {
                searchProvider.viewCountLowerBound = '0';
              }
              searchProvider.onDisplayedDataFilterSort();
            },
          ),
          FilterTextField(
            hitText: '喜歡數>=',
            controller: likeCountFilterController,
            width: 88,
            onSubmitted: (String text) {
              if (text.isNotEmpty && isNumeric(text)) {
                searchProvider.likeCountLowerBound = text;
              } else {
                searchProvider.likeCountLowerBound = '0';
              }
              searchProvider.onDisplayedDataFilterSort();
            },
          ),
          FilterTextField(
            hitText: '留言數>=',
            controller: commentCountFilterController,
            width: 88,
            onSubmitted: (String text) {
              if (text.isNotEmpty && isNumeric(text)) {
                searchProvider.commentCountLowerBound = text;
              } else {
                searchProvider.commentCountLowerBound = '0';
              }
              searchProvider.onDisplayedDataFilterSort();
            },
          ),
        ]
      )
    );
  }
}

class PixnetFilter extends StatefulWidget {
  const PixnetFilter({super.key});

  @override
  State<PixnetFilter> createState() => _PixnetFilterState();
}

class _PixnetFilterState extends State<PixnetFilter> {
  Set<ExerciseFilter> filters = <ExerciseFilter>{};

  final titleFilterController = TextEditingController();
  final viewCountFilterController = TextEditingController();
  final commentCountFilterController = TextEditingController();

  @override
  void dispose() {
    titleFilterController.dispose();
    viewCountFilterController.dispose();
    commentCountFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var searchProvider = context.watch<PixnetSearchProvider>();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Wrap(
        spacing: 4,
        children: [
          SizedBox(
            height: 32,
            width: 32,
            child: IconButton(
              icon: const Icon(Icons.restart_alt_outlined, size: 16,),
              tooltip: '重置篩選設定',
              onPressed: () {
                searchProvider.isSortByRelevance = true;
                searchProvider.mustSelected = false;
                searchProvider.mustContainsEmail = false;
                titleFilterController.clear();
                searchProvider.titleContainedText = '';
                viewCountFilterController.clear();
                searchProvider.viewCountLowerBound = '0';
                commentCountFilterController.clear();
                searchProvider.commentCountLowerBound = '0';
                searchProvider.onDisplayedDataFilterSort();
              },
            ),
          ),
          MyFilterChip(
            hitText: '依相關度排序', 
            selected: searchProvider.isSortByRelevance, 
            onSelected: (bool selected) => searchProvider.onDisplayedDataSortByRelevance(),
          ),
          MyFilterChip(
            hitText: '有Email', 
            selected: searchProvider.mustContainsEmail, 
            onSelected: (bool selected) {
              searchProvider.mustContainsEmail = selected;
              searchProvider.onDisplayedDataFilterSort();
            }
          ),
          MyFilterChip(
            hitText: '有IG', 
            selected: searchProvider.mustContainsIg, 
            onSelected: (bool selected) {
              searchProvider.mustContainsIg = selected;
              searchProvider.onDisplayedDataFilterSort();
            }
          ),
          MyFilterChip(
            hitText: '已選取', 
            selected: searchProvider.mustSelected, 
            onSelected: (bool selected) {
              searchProvider.mustSelected = selected;
              searchProvider.onDisplayedDataFilterSort();
            }
          ),
          FilterTextField(
            hitText: '標題包含',
            controller: titleFilterController,
            width: 200,
            onSubmitted: (String text) {
              if (text.isNotEmpty) {
                searchProvider.titleContainedText = text;
              } else {
                searchProvider.titleContainedText = '';
              }
              searchProvider.onDisplayedDataFilterSort();
            },
          ),
          FilterTextField(
            hitText: '觀看數>=',
            controller: viewCountFilterController,
            width:88,
            onSubmitted: (String text) {
              if (text.isNotEmpty && isNumeric(text)) {
                searchProvider.viewCountLowerBound = text;
              } else {
                searchProvider.viewCountLowerBound = '0';
              }
              searchProvider.onDisplayedDataFilterSort();
            },
          ),
          FilterTextField(
            hitText: '留言數>=',
            controller: commentCountFilterController,
            width: 88,
            onSubmitted: (String text) {
              if (text.isNotEmpty && isNumeric(text)) {
                searchProvider.commentCountLowerBound = text;
              } else {
                searchProvider.commentCountLowerBound = '0';
              }
              searchProvider.onDisplayedDataFilterSort();
            },
          ),
        ]
      )
    );
  }
}

class FilterTextField extends StatelessWidget {

  final void Function(String) onSubmitted;
  final String hitText;
  final double width;
  final double height = 34;
  final TextEditingController controller;


  const FilterTextField({
    super.key,
    required this.hitText,
    required this.width,
    required this.onSubmitted, 
    required this.controller, 
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        controller: controller,
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
