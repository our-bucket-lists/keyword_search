import 'package:flutter/material.dart';
import 'package:keyword_project/modles/pixnet_search_model.dart';
import 'package:keyword_project/provider/pixnet_provider.dart';
import 'package:provider/provider.dart';

class PixnetFilter extends StatefulWidget {
  const PixnetFilter({super.key});

  @override
  State<PixnetFilter> createState() => _PixnetFilterState();
}

class _PixnetFilterState extends State<PixnetFilter> {
  @override
  Widget build(BuildContext context) {
    var searchPixnet = context.watch<PixnetSearchProvider>();

    return Row(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 200,
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              hintText: '標題包含',
              hintStyle: Theme.of(context).textTheme.labelMedium,
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8))
              ),
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            onSubmitted: (String text) {
              searchPixnet.results = text.isEmpty
                  ? searchPixnet.originResults
                  : searchPixnet.results
                      .where((item) => item.title.toLowerCase().contains(text.toLowerCase())).toList();
            },
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 120,
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              hintText: '觀看數>=',
              hintStyle: Theme.of(context).textTheme.labelMedium,
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8))
              ),
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            onSubmitted: (String text) {
              searchPixnet.results = text.isEmpty
                  ? searchPixnet.originResults
                  : searchPixnet.results
                      .where((item) => item.hit>=int.parse(text)).toList();
            },
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 120,
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              hintText: '留言數>=',
              hintStyle: Theme.of(context).textTheme.labelMedium,
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8))
              ),
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            onSubmitted: (String text) {
              searchPixnet.results = text.isEmpty
                  ? searchPixnet.originResults
                  : searchPixnet.results
                      .where((item) => item.replyCount>=int.parse(text)).toList();
            },
          ),
        ),
      ),
    
    ]);
  }
}