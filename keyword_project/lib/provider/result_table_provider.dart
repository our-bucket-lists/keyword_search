import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:keyword_project/widgets/ig_result_table.dart';
import 'package:keyword_project/widgets/pixnet_result_table.dart';
import 'package:keyword_project/widgets/youtube_result_table.dart';

enum Platforms { pixnet, youtube, instagram }

class ResultTableProvider extends ChangeNotifier {
  Set<Platforms> _selectedPlatform = <Platforms>{Platforms.youtube};
  bool _isLoading = false;

  Set<Platforms> get selectedPlatform => _selectedPlatform;
  set selectedPlatform(Set<Platforms> input) {
    _selectedPlatform = input;

    log("Selected platform: $_selectedPlatform");
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  set isLoading(bool input) {
    _isLoading = input;
    notifyListeners();
  }

  Widget get selectedTable {
    switch (_selectedPlatform.elementAt(0)) {
      case Platforms.pixnet:
        return const PixnetResultTable();
      case Platforms.instagram:
        return const InstagramResultTable();
      case Platforms.youtube:
        return const YoutubeResultTable();
      default:
        return const YoutubeResultTable();
    }
  }
}
