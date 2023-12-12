import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:keyword_project/modles/youtube_search_model.dart';
import 'package:keyword_project/modles/youtube_channel_model.dart' as channel;
import 'package:keyword_project/modles/youtube_video_model.dart' as video;

class YoutubeSearchProvider extends ChangeNotifier {
  // For API request
  static const _apiEndpoint = 'youtube.googleapis.com';
  final String _youtubeApiKey = 'AIzaSyDl6f1JPAAE59rp_ts7Al_fX7vMG7-_4Sk';
  final int _resultsPerPage = 50;
  String _searchText = '';
  String _nextPageToken = '';
  int _maxPage = 0;
  int _currentPage = 0;

  // For API response
  YoutubeSearch _searchResults = YoutubeSearch(
      nextPageToken: '', 
      pageInfo: PageInfo(totalResults: 0, resultsPerPage: 0), 
      items: []
    );
  channel.YoutubeChannel _channelResponse = channel.YoutubeChannel(items: []);
  video.YoutubeVideo _videoResponse = video.YoutubeVideo(items: []);
  
  // For Data storage
  final List<Item> _originalData = [];
  List<Item> _displayedData = [];
  
  // For data sorting and filtering
  FilterCriteria filterCriteria = FilterCriteria(
    titleContainedText: '', 
    viewCountLowerBound: '0', 
    likeCountLowerBound: '0', 
    commentCountLowerBound: '0',
    mustContainsEmail: false
  );
  List<bool> _isAscendingSortedColumn = List.generate(8, (index) => false);
  bool _isSortByRelevance = false;
  int _sortedColumnIndex = 0;
  bool isLoadMoreDisplayed = false;
  
  // Seter
  set searchText(String searchText) {
    _searchText = searchText;
    _nextPageToken = '';
    _maxPage = 0;
    _currentPage = 0;
    _displayedData = [];
    _isAscendingSortedColumn = List.generate(8, (index) => false);
    _isSortByRelevance = true;
  }

  // Geter
  List<Item> get originalData => _originalData;
  List<Item> get displayedData => _displayedData;
  List<bool> get isAscendingSortedColumn => _isAscendingSortedColumn;
  int get sortedColumnIndex => _sortedColumnIndex;
  bool get isSortByRelevance => _isSortByRelevance;

  // Dealing with the data to be displayed
  void onDisplayedDataSort (int columnIndex, bool isAscending) {
    _isSortByRelevance = false;
    _sortedColumnIndex = columnIndex;
    _isAscendingSortedColumn[_sortedColumnIndex] = isAscending;
    switch (_sortedColumnIndex) {
      case 0:
        _displayedData.sort((a, b) => _onCompare(isAscending, a.snippet.publishTime, b.snippet.publishTime));
      case 1:
        _displayedData.sort((a, b) => _onCompare(isAscending, a.snippet.title, b.snippet.title));
      case 2:
        _displayedData.sort((a, b) => _onCompare(isAscending, int.parse(a.id.videoViewCount), int.parse(b.id.videoViewCount)));
      case 3:
        _displayedData.sort((a, b) => _onCompare(isAscending, int.parse(a.id.videoLikeCount), int.parse(b.id.videoLikeCount)));
      case 4:
        _displayedData.sort((a, b) => _onCompare(isAscending, int.parse(a.id.videoCommentCount), int.parse(b.id.videoCommentCount)));
      case 5:
        _displayedData.sort((a, b) => _onCompare(isAscending, a.snippet.channelTitle, b.snippet.channelTitle));
      case 6:
        _displayedData.sort((a, b) => _onCompare(isAscending, int.parse(a.snippet.followerCount), int.parse(b.snippet.followerCount)));
      case 7:
        _displayedData.sort((a, b) => _onCompare(isAscending, a.snippet.email, b.snippet.email));
    }
    notifyListeners();
  }

  void onDisplayedDataFilterSort () {
    _displayedData = _onFilter(_originalData);
    if (_isSortByRelevance) {
      notifyListeners();
    } else {
      onDisplayedDataSort(_sortedColumnIndex, isAscendingSortedColumn[_sortedColumnIndex]);
    }
  }

  void onDisplayedDataSortByRelevance () {
    _isSortByRelevance = true;
    _isAscendingSortedColumn = List.generate(8, (index) => false);
    _displayedData = _onFilter(_originalData);
    notifyListeners();
  }

  int _onCompare(bool isAscending, var a, var b) {
    if (isAscending) {
      return a.compareTo(b);
    } else {
      return b.compareTo(a);
    }
  }

  List<Item> _onFilter (List<Item> inputList) {
    return inputList.
      where((element) => element.snippet.title.toLowerCase().contains(filterCriteria.titleContainedText.toLowerCase())).
      where((element) => int.parse(element.id.videoViewCount)>=int.parse(filterCriteria.viewCountLowerBound)).
      where((element) => int.parse(element.id.videoLikeCount)>=int.parse(filterCriteria.likeCountLowerBound)).
      where((element) => int.parse(element.id.videoCommentCount)>=int.parse(filterCriteria.commentCountLowerBound)).
      where((element) => filterCriteria.mustContainsEmail?element.snippet.email.isNotEmpty:true).toList();
  }

  // Getting data via API
  search() async {
    if (_searchText.isNotEmpty) {
      log('Searching Started on YouTube...');
      _currentPage += 1;
      await _getSearchResultApi();
      _maxPage = (_searchResults.pageInfo.totalResults/_resultsPerPage).ceil();
      log('Searching Completed on YouTube!');
      log('Max Page = $_maxPage');
      log('Current Page = $_currentPage');

      notifyListeners();
    }
  }

  onLoadMore() async {
    if (_currentPage < _maxPage) {
      log('Loading more is started on YouTube...');
      _currentPage += 1;
      await _getSearchResultApi();
      log('Loading more is completed on YouTube!');
      log('Current Page = $_currentPage');

      notifyListeners();
    }
  }

  _getSearchResultApi() async {
    List<Item> currentResults = [];
    var uri = Uri.https(
      _apiEndpoint,
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
          currentResults = _searchResults.items;

          await Future.wait(
            currentResults.map(
              (element) async {
                var channelInfo = await _getYoutubeChannelInfo(element.snippet.channelId);
                var videoInfo = await _getYoutubeVideoInfo(element.id.videoId);
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

          _displayedData.addAll(_onFilter(currentResults));
          _originalData.addAll(currentResults);
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

  _getYoutubeChannelInfo(String channelId) async {
    var uri = Uri.https(
      _apiEndpoint, 
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
          _channelResponse = channel.youtubeChannelFromJson(response.body);
        default:
          log('[ERROR] Http Response Error: ${response.statusCode.toString()}');
          throw Exception(response.reasonPhrase);
      }
    } catch (err) {
      log('[ERROR] Http Request Execution Error: ${err.toString()}');
    }

    return {
      'email': _getEmail(_channelResponse.items[0].snippet.description.replaceAll('\n', ' ')).join(', '),
      'followerCount': _channelResponse.items[0].statistics.subscriberCount,
    };
  }

  _getYoutubeVideoInfo(String videoId) async {
    var uri = Uri.https(
      _apiEndpoint, 
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
          _videoResponse = video.youtubeVideoFromJson(response.body);
        default:
          log('[ERROR] Http Response Error: ${response.statusCode.toString()}');
          throw Exception(response.reasonPhrase);
      }
    } catch (err) {
      log('[ERROR] Http Request Execution Error: ${err.toString()}');
      rethrow;
    }

    return {
      'videoViewCount': _videoResponse.items[0].statistics.viewCount,
      'videoLikeCount': _videoResponse.items[0].statistics.likeCount,
      'videoCommentCount': _videoResponse.items[0].statistics.commentCount,
    };
  }

  Set<String> _getEmail(String data) {
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

class FilterCriteria {
  String titleContainedText;
  String viewCountLowerBound;
  String likeCountLowerBound;
  String commentCountLowerBound;
  bool mustContainsEmail;

  FilterCriteria({
    required this.titleContainedText,
    required this.viewCountLowerBound,
    required this.likeCountLowerBound,
    required this.commentCountLowerBound,
    required this.mustContainsEmail,
  });
}
