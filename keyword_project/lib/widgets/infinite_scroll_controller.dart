import 'package:flutter/material.dart';

class InfiniteListenerController extends ScrollController {
  final VoidCallback? onLoadMore;

  InfiniteListenerController({this.onLoadMore}) {
    if(onLoadMore != null) addListener(_endListener);
  }

  void _endListener() {
    if (position.pixels == position.maxScrollExtent) {
      print('onLoadMore is going to be called');
      onLoadMore?.call();
    }
  }

  @override
  void dispose() {
    if(onLoadMore != null) removeListener(_endListener);
    super.dispose();
  }
}