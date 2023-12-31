import 'package:flutter/material.dart';

class InfiniteListenerController extends ScrollController {
  final VoidCallback? onLoadMore;

  InfiniteListenerController({this.onLoadMore}) {
    if(onLoadMore != null) addListener(_endListener);
  }

  void _endListener() {
    if (position.pixels == position.maxScrollExtent) {
      onLoadMore?.call();
    }
  }

  @override
  void dispose() {
    if(onLoadMore != null) removeListener(_endListener);
    super.dispose();
  }
}