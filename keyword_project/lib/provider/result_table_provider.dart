import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:keyword_project/widgets/ig_result_table.dart';
import 'package:keyword_project/widgets/pixnet_result_table.dart';

enum Platforms { pixnet, youtube, instagram }

class ResultTableProvider extends ChangeNotifier {
  Set<Platforms> _selectedPlatform = <Platforms>{Platforms.pixnet};

  Set<Platforms> get selectedPlatform => _selectedPlatform;

  set selectedPlatform(Set<Platforms> input) {
    _selectedPlatform = input;

    log("Selected platform: $_selectedPlatform");
    notifyListeners();
  }

  Widget get selectedTable {
    log('Start to switching the table to $_selectedPlatform');
    log('Pixnet [${_selectedPlatform.elementAt(0) == Platforms.pixnet}]');
    log('Instagram [${_selectedPlatform.elementAt(0) == Platforms.instagram}]');

    switch (_selectedPlatform.elementAt(0)) {
      case Platforms.pixnet:
        log('Display the Pixnet Result Table.');
        return const PixnetResultTable();
      case Platforms.instagram:
        log('Display the Pixnet Result Table.');
        return const InstagramResultTable();
      default:
        log('Display the Default Result Table, which is Pixnet Result Table.');
        return const PixnetResultTable();
    }
  }
}
