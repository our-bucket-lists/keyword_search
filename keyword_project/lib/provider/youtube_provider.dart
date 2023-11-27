import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:keyword_project/modles/youtube_search_model.dart';

class YoutubeSearchProvider extends ChangeNotifier {
  static const apiEndpoint = 'youtube.googleapis.com';

  bool isLoading = true;
  String error = '';
  YoutubeSearch searchResults = YoutubeSearch(
    nextPageToken: '', 
    pageInfo: PageInfo(totalResults: 0, resultsPerPage: 0), 
    items: []
  );
  String _searchText = '';

  set input(String inputText) {
    _searchText = inputText;
    log("Recieve the input: $_searchText");
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  List<Item> get results => searchResults.items;

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
    var uri = Uri.https(
      apiEndpoint,
      '/youtube/v3/search', 
      {
        'part': 'snippet',
        'maxResults': '100',
        'key': 'AIzaSyDl6f1JPAAE59rp_ts7Al_fX7vMG7-_4Sk',
        'type':'video',
        'q': keyword
      }
    );
    log(uri.toString());
    try {
      http.Response response =
          await http.get(uri);
      if (response.statusCode == 200) {
        log(response.body.toString());
        searchResults = youtubeSearchFromJson(response.body);
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
