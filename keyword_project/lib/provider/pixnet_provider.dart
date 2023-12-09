import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:keyword_project/common/global.dart';

import 'package:keyword_project/modles/pixnet_search_model.dart';

class PixnetSearchProvider extends ChangeNotifier {
  static const apiEndpoint = 'www.pixnet.net';

  bool isLoading = true;
  String error = '';
  PixnetSearch searchResults = PixnetSearch(
      error: false,
      data:
          Data(results: [], page: 0, perPage: 0, totalPage: 0, totalFeeds: 0));
  String _searchText = '';
  List<Feed> _currentResults = [];

  set input(String inputText) {
    _searchText = inputText;
    log("Recieve the input: $_searchText");
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  List<Feed> get originResults => searchResults.data.results;
  List<Feed> get results => _currentResults;

  set results(List<Feed> inputList) {
    _currentResults = inputList;
    log("Pixnet Current Result Changed: $_currentResults");
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  search() async {
    if (_searchText.isNotEmpty) {
      log('Searching...');
      await getSearchResultAPI(keyword: _searchText);
      log('Completed!');
    } else {}
  }

  getSearchResultAPI({String keyword = ''}) async {
    isLoading = true;
    notifyListeners();
    var uri = Uri.https(apiEndpoint,'/mainpage/api/ppage/$keyword/feeds', {'per_page': '25', 'sort': 'related'});
    log(uri.toString());
    try {
      http.Response response =
          await http.get(uri);
      if (response.statusCode == 200) {
        log(response.body.toString());
        searchResults = pixnetSearchFromJson(response.body);
        _currentResults =  List.from(searchResults.data.results);
        Map tmp;
        for (var element in _currentResults) {
          tmp = await getMorePixnetInfo(
            Uri.https(
              'www.pixnet.net',
              '/pcard/${element.memberUniqid.toString()}/profile/info',
            )
          );
          element.email = tmp['email'];
          element.ig = tmp['ig'];
        }
      } else {
        error = response.statusCode.toString();
      }
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
