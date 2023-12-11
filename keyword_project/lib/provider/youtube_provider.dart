import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:keyword_project/modles/youtube_search_model.dart';
import 'package:keyword_project/modles/youtube_channel_model.dart' as channel;
import 'package:keyword_project/modles/youtube_video_model.dart' as video;

class YoutubeSearchProvider extends ChangeNotifier {
  static const apiEndpoint = 'youtube.googleapis.com';
  final String _youtubeApiKey = 'AIzaSyDEnd1p2BskDTOYUfldRuHMTI5LeSKGEBI';
  bool isLoading = true;
  String error = '';
  YoutubeSearch _searchResults = YoutubeSearch(
    nextPageToken: '', 
    pageInfo: PageInfo(totalResults: 0, resultsPerPage: 0), 
    items: []
  );
  channel.YoutubeChannel channelResponse = channel.YoutubeChannel(items: []);
  video.YoutubeVideo videoResponse = video.YoutubeVideo(items: []);
  String _searchText = '';
  List<Item> _currentResults = [];
  List<Item> _originData = [];
  List<Item> _displayedData = [];
  String _nextPageToken = '';
  int _maxPage = 0;
  int _currentPage = 0;
  int _resultsPerPage = 50;
  List<bool> sortedColumn = List.generate(8, (index) => false);

  set input(String inputText) {
    _searchText = inputText;
    _displayedData = [];
    _nextPageToken = '';
    _maxPage = 0;
    _currentPage = 0;
  }

  List<Item> get results => _displayedData;

  onLoadMore() async {
    if (_currentPage < _maxPage) {
      isLoading = true;
      notifyListeners();

      log('Loading more is started on YouTube...');
      _currentPage += 1;
      await getSearchResultApi();
      log('Loading more is completed on YouTube!');
      log('Current Page = $_currentPage');

      isLoading = false;
      notifyListeners();
    }
  }

  getOriginOder() {
    _displayedData = List.from(_originData);
    sortedColumn = List.generate(8, (index) => false);
    notifyListeners();
  }

  search() async {
    if (_searchText.isNotEmpty) {
      isLoading = true;
      notifyListeners();

      log('Searching Started on YouTube...');
      sortedColumn = List.generate(8, (index) => false);
      _currentPage += 1;
      await getSearchResultApi();
      _maxPage = (_searchResults.pageInfo.totalResults/_resultsPerPage).ceil();
      log('Searching Completed on YouTube!');
      log('Max Page = $_maxPage');
      log('Current Page = $_currentPage');

      isLoading = false;
      notifyListeners();
    }
  }

  getSearchResultApi() async {
    var uri = Uri.https(
      apiEndpoint,
      '/youtube/v3/search', 
      {
        'part': 'snippet',
        'maxResults': '$_resultsPerPage',
        'key': _youtubeApiKey,
        'type':'video',
        'q': _searchText,
        'pageToken' : _nextPageToken,
      }
    );
    try {
      http.Response response = await http.get(uri);
      switch (response.statusCode) {
        case 200:
          _searchResults = youtubeSearchFromJson(response.body);
          _nextPageToken = _searchResults.nextPageToken;
          _currentResults = _searchResults.items;

          await Future.wait(
            _currentResults.map(
              (element) async {
                var channelInfo = await getYoutubeChannelInfo(element.snippet.channelId);
                var videoInfo = await getYoutubeVideoInfo(element.id.videoId);
                // Channel
                element.snippet.email = channelInfo['email'];
                element.snippet.followerCount = channelInfo['followerCount'];
                // Video
                element.id.videoViewCount = videoInfo['videoViewCount'];
                element.id.videoLikeCount = videoInfo['videoLikeCount'];
                element.id.videoCommentCount = videoInfo['videoCommentCount'];
              }
            )
          ).then(
            (List response) => log('All YouTube Searching processed.')
          ).catchError((err) {
            log('[ERROR] Http Request Execution Error: ${err.toString()}');
            throw Exception(err);
          });

          _displayedData.addAll(_currentResults);
          _originData.addAll(_currentResults);
        default:
          log('[ERROR] Http Response Error: ${response.statusCode.toString()}');
          log('[ERROR] Http Response Error: ${response.body}');
          throw Exception(response.reasonPhrase);
      }
    } catch (err) {
      log('[ERROR] Http Request Execution Error: ${err.toString()}');
      rethrow;
    }

  }

  getYoutubeChannelInfo(String channelId) async {
    var uri = Uri.https(
      apiEndpoint, 
      '/youtube/v3/channels',
      {
        'part': 'snippet,statistics',
        'id': channelId,
        'key': _youtubeApiKey,
      }
    );
    try {
      http.Response response = await http.get(uri);
      switch (response.statusCode) {
        case 200:
          channelResponse = channel.youtubeChannelFromJson(response.body);
        default:
          log('[ERROR] Http Response Error: ${response.statusCode.toString()}');
          throw Exception(response.reasonPhrase);
      }
    } catch (err) {
      log('[ERROR] Http Request Execution Error: ${err.toString()}');
    }

    return {
      'email': getEmail(channelResponse.items[0].snippet.description.replaceAll('\n', ' ')).join(', '),
      'followerCount': channelResponse.items[0].statistics.subscriberCount,
    };
  }

  getYoutubeVideoInfo(String videoId) async {
    var uri = Uri.https(
      apiEndpoint, 
      '/youtube/v3/videos',
      {
        'part': 'statistics',
        'id': videoId,
        'key': _youtubeApiKey,
      }
    );
    try {
      http.Response response = await http.get(uri);
      switch (response.statusCode) {
        case 200:
          videoResponse = video.youtubeVideoFromJson(response.body);
        default:
          log('[ERROR] Http Response Error: ${response.statusCode.toString()}');
          throw Exception(response.reasonPhrase);
      }
    } catch (err) {
      log('[ERROR] Http Request Execution Error: ${err.toString()}');
      rethrow;
    }

    return {
      'videoViewCount': videoResponse.items[0].statistics.viewCount,
      'videoLikeCount': videoResponse.items[0].statistics.likeCount,
      'videoCommentCount': videoResponse.items[0].statistics.commentCount,
    };
  }

  Set<String> getEmail(String data) {
    Set<String> result = <String>{};
    String regexString = r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@((?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)";
    RegExp regExp = RegExp(regexString);
    var matches = regExp.allMatches(data);
    
    for (var m in matches) {
      result.add(m.group(0).toString());
    }
    return result;
  }
}
