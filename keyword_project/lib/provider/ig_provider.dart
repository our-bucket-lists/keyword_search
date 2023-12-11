import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:keyword_project/modles/ig_hashtag_search_model.dart' as hashtag;
import 'package:keyword_project/modles/ig_media_search_model.dart';


class InstagramSearchProvider extends ChangeNotifier {
  static const apiEndpoint = 'graph.facebook.com';
  static const userId = '17841400502414397';
  static const token = 'EAAYs6H9ZCiEEBO95RzZBFWOF3HO787oQbegx9mWyxhZBD5TZBW0ZBUxBO0u9vU7soXU7d4y3zy1gVSMJfefR5eVBYUzuNUif1jn5UmJfA3PG4af4hu56oACZB91dTxGERxeaAfN161KVdNQM9EmUyp28NwnhYcP5uLLl4vOCfWQQD5bMo9Jx7j0J9nVNvnBxZBBqZBs5hvaBzaVwvVhEnMF5YdMaBVoZD';
  bool isLoading = true;
  String error = '';
  hashtag.IgHashtagSearch hashtagResult = hashtag.IgHashtagSearch(data: []);
  IgMediaSearch searchResults = IgMediaSearch(data: [], paging: Paging(cursors: Cursors(after: ''), next: ''));
  String _searchText = '';
  List<Datum> _currentResults = [];

  set input(String inputText) {
    _searchText = inputText;
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }
  
  List<Datum> get results => searchResults.data;

  search() async {
    if (_searchText.isNotEmpty) {
      isLoading = true;
      notifyListeners();

      log('Searching Started on Instagram...');
      String hashtagId = await getHashTagIdApi(keyword: _searchText);
      await getSearchResultApi(hashtagId);
      log('Searching Completed on Instagram!');

      isLoading = false;
      notifyListeners();
    }
  }
  
  Future<String> getHashTagIdApi({String keyword=''}) async {
    var uri = Uri.http(
      apiEndpoint,
      '/v18.0/ig_hashtag_search',
      {
        'q': keyword,
        'user_id': userId,
        'access_token': token,
      }
    );

    try {
      http.Response response = await http.get(uri);
      switch (response.statusCode) {
        case 200:
          hashtagResult = hashtag.igHashtagSearchFromJson(response.body);
          return hashtagResult.data.first.id;
        default:
          log('[ERROR] Http Response Error: ${response.statusCode.toString()}');
          throw Exception(response.reasonPhrase);
      }
    } catch (err) {
      log('[ERROR] Http Request Execution Error: ${err.toString()}');
      rethrow;
    }
  }

  getSearchResultApi(String hashtagId) async {
    var uri = Uri.http(
      apiEndpoint,
      '/v18.0/$hashtagId/top_media',
      {
        'fields': 'caption,comments_count,like_count,permalink,timestamp',
        'user_id': userId,
        'access_token': token,
      }
    );

    try {
      http.Response response = await http.get(uri);
      switch (response.statusCode) {
        case 200:
          searchResults = igMediaSearchFromJson(response.body);
          _currentResults =  List.from(searchResults.data);
          await Future.wait(
            _currentResults.map(
              (element) async => element.username = await getMoreIgInfo(queryUrl: Uri.parse(element.permalink))
            )
          ).then(
            (List response) => log('All Instagram Searching processed.')
          ).catchError((err) {
            log('[ERROR] Http Request Execution Error: ${err.toString()}');
            throw Exception(throw err);
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

  getMoreIgInfo({required Uri queryUrl}) async {
    var uri = Uri.http(
      'ec2-13-210-189-82.ap-southeast-2.compute.amazonaws.com:5000',
      '/api/v1/instagram/profile', 
      {'url': queryUrl.toString()}
    );
    http.Response response = await http.get(uri);
    switch (response.statusCode) {
      case 200:
        return json.decode(response.body).containsKey('username')?json.decode(response.body)['username']:'';
      default:
        log('[ERROR] Http Response Error: ${response.statusCode.toString()}');
        throw Exception(response.reasonPhrase);
    }
  }
}
