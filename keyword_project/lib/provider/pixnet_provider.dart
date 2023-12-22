import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:keyword_project/modles/pixnet_search_model.dart';

class PixnetSearchProvider extends ChangeNotifier {
  // For API request
  static const _apiEndpoint = 'ec2-13-210-189-82.ap-southeast-2.compute.amazonaws.com:5000';
  String _searchText = '';
  int _maxPage = 0;
  int _currentPage = 0;

  // For API response
  PixnetSearch _searchResults = PixnetSearch(
      error: false,
      data: Data(results: [], page: 0, perPage: 0, totalPage: 0, totalFeeds: 0));
  
  // For Data storage
  var _originalData = <Feed>[];
  var _displayedData = <Feed>[];

  // Setter
  set searchText(String searchText) {
    // For API request
    _searchText = searchText;
    _maxPage = 0;
    _currentPage = 0;
    // For API response
    _searchResults = PixnetSearch(
        error: false,
        data: Data(results: [], page: 0, perPage: 0, totalPage: 0, totalFeeds: 0));
  
    // For Data storage
    _originalData = <Feed>[];
    _displayedData = <Feed>[];
    notifyListeners();
  }

  // Geter
  List<Feed> get originalData => _originalData;
  List<Feed> get displayedData => _displayedData;

  // Getting data via API
  search() async {
    if (_searchText.isNotEmpty) {
      log('Searching Started on Pixnet...');
      _currentPage += 1;
      await _getSearchResultApi();
      log('Searching Completed on Pixnet!');
      log('Max Page = $_maxPage');
      log('Current Page = $_currentPage');

      notifyListeners();
    }
  }

  onLoadMore() async {
    if (_currentPage<_maxPage) {
      log('Loading more is started on Pixnet...');
      _currentPage += 1;
      await _getSearchResultApi();
      log('Loading more is completed on Pixnet!');
      log('Current Page = $_currentPage');

      notifyListeners();
    }
  }

  _getSearchResultApi() async {
    List<Feed> currentResults = [];
    var uri = Uri.http(
      _apiEndpoint,
      '/api/v1/pixnet/media', 
      {
        'keyword': _searchText,
        'page': _currentPage.toString(),
      }
    );
    try {
      http.Response response = await http.get(uri);
      switch (response.statusCode) {
        case 200:
          _searchResults = pixnetSearchFromJson(response.body);
          _currentPage = _searchResults.data.page;
          _maxPage = _searchResults.data.totalPage;
          currentResults =  List.from(_searchResults.data.results);
          await Future.wait(
            currentResults.map(
              (element) async {
                var info = await getMorePixnetInfo(
                  queryUrl: Uri.https(
                    'www.pixnet.net', 
                    '/pcard/${element.memberUniqid.toString()}/profile/info',
                  )
                );
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
          _displayedData.addAll(currentResults);
          _originalData.addAll(currentResults);
          break;
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
      _apiEndpoint,
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
