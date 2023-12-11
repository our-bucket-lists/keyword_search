import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:keyword_project/modles/pixnet_search_model.dart';

class PixnetSearchProvider extends ChangeNotifier {
  static const apiEndpoint = 'ec2-13-210-189-82.ap-southeast-2.compute.amazonaws.com:5000';

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
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  List<Feed> get originResults => searchResults.data.results;
  List<Feed> get results => _currentResults;

  set results(List<Feed> inputList) {
    _currentResults = inputList;
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  search() async {
    if (_searchText.isNotEmpty) {
      isLoading = true;
      notifyListeners();

      log('Searching Started on Pixnet...');
      await getSearchResultApi(keyword: _searchText);
      log('Searching Completed on Pixnet!');

      isLoading = false;
      notifyListeners();
    }
  }

  getSearchResultApi({String keyword = ''}) async {
    var uri = Uri.http(apiEndpoint,'/api/v1/pixnet/media', {'keyword': keyword});
    try {
      http.Response response = await http.get(uri);
      switch (response.statusCode) {
        case 200:
          searchResults = pixnetSearchFromJson(response.body);
          _currentResults =  List.from(searchResults.data.results);
          await Future.wait(
            _currentResults.map(
              (element) async {
                var info = await getMorePixnetInfo(queryUrl: Uri.https('www.pixnet.net', '/pcard/${element.memberUniqid.toString()}/profile/info',));
                element.email = info['email'];
                element.ig = info['ig'];
              }
            )
          ).then(
            (List response) => log('All Pixnet Searching processed.')
          ).catchError((err) {
            log('[ERROR] Http Request Execution Error: ${err.toString()}');
            throw Exception(err);
          });
        default:
          log('[ERROR] Http Response Error: ${response.statusCode.toString()}');
          throw Exception(response.reasonPhrase);
      }
    } catch (err) {
      log('[ERROR] Http Request Execution Error: ${err.toString()}');
      rethrow;
    }
  }

  getMorePixnetInfo({required Uri queryUrl}) async {
    var uri = Uri.http(
      apiEndpoint,
      '/api/v1/pixnet/profile', 
      {'url': queryUrl.toString()}
    );
    http.Response response = await http.get(uri);
    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        log('[ERROR] Http Response Error: ${response.statusCode.toString()}');
        throw Exception(response.reasonPhrase);
    }
  }
}
