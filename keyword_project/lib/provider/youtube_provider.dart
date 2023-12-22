import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';

import 'package:keyword_project/modles/youtube_search_model.dart';
import 'package:keyword_project/modles/youtube_channel_model.dart' as channel;
import 'package:keyword_project/modles/youtube_video_model.dart' as video;

class YoutubeSearchProvider extends ChangeNotifier {
  // For API request
  static const _apiEndpoint = 'youtube.googleapis.com';
  final Set<String> _youtubeApiKey = {
    'AIzaSyC9kt4Ck0fYEcuVRHQ-XfXqD-fJW0N6SL0',
    'xAIzaSyAHJRfka1IUbfrlsKfwsutxlD42CWW174Q',
    'AIzaSyDKCSzOe8AnvKwz4qQzYFjfmCDj6BFxHIQ',
    'AIzaSyBnGlaUIu5uvDWo6CzCHl1qqtyUdbtIQCg',
  };
  int _currentApiKeyIndex = 0;
  final int _resultsPerPage = 50;
  String _searchText = '';
  String _nextPageToken = '';
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
  var _originalData = <Item>[];
  var _displayedData = <Item>[];
  var _selectedItems = <String>{};
  final _selectedColumns = <String>{'發布日期', '影片標題', '影片連結', '觀看數', '喜歡數', '留言數', '頻道名稱', '頻道連結', '訂閱數', 'Email'};
  var _videoIdSet = HashSet<String>();

  // For data sorting and filtering
  FilterCriteria _filterCriteria = FilterCriteria();
  List<bool> _isAscendingSortedColumn = List.generate(8, (index) => false);
  bool _isSortByRelevance = true; 
  int _sortedColumnIndex = 0;
  bool isLoadMoreDisplayed = false;
  
  // Seter
  set searchText(String searchText) {
    // For API request
    _searchText = searchText;
    _nextPageToken = '';
    _currentPage = 0;
    notifyListeners();

    // For API response
    _searchResults = YoutubeSearch(
        nextPageToken: '', 
        pageInfo: PageInfo(totalResults: 0, resultsPerPage: 0), 
        items: []
      );
    _channelResponse = channel.YoutubeChannel(items: []);
    _videoResponse = video.YoutubeVideo(items: []);
    notifyListeners();

    // For Data storage
    _originalData = [];
    _displayedData = [];
    _selectedItems = <String>{};
    _videoIdSet = HashSet<String>();
    notifyListeners();

     // For data sorting and filtering
     _filterCriteria = FilterCriteria();   
    _isAscendingSortedColumn = List.generate(8, (index) => false);
    _isSortByRelevance = true;
    _sortedColumnIndex = 0;
    isLoadMoreDisplayed = false;
    notifyListeners();
  }
  set isSortByRelevance(bool input) {
    _isSortByRelevance = input;
    notifyListeners();
  }
  set titleContainedText(String input) {
    _filterCriteria.titleContainedText = input;
    notifyListeners();
  }
  set viewCountLowerBound(String input) {
    _filterCriteria.viewCountLowerBound = input;
    notifyListeners();
  }
  set likeCountLowerBound(String input) {
    _filterCriteria.likeCountLowerBound = input;
    notifyListeners();
  }
  set commentCountLowerBound(String input) {
    _filterCriteria.commentCountLowerBound = input;
    notifyListeners();
  }
  set mustContainsEmail(bool input) {
    _filterCriteria.mustContainsEmail = input;
    notifyListeners();
  }
  set mustSelected(bool input) {
    _filterCriteria.mustSelected = input;
    notifyListeners();
  }

  // Geter
  String get searchText => _searchText;
  List<Item> get originalData => _originalData;
  List<Item> get displayedData => _displayedData;
  Set<String> get selectedItems => _selectedItems;
  Set<String> get selectedColumns => _selectedColumns;
  List<bool> get isAscendingSortedColumn => _isAscendingSortedColumn;
  int get sortedColumnIndex => _sortedColumnIndex;
  bool get isSortByRelevance => _isSortByRelevance;
  bool get mustContainsEmail => _filterCriteria.mustContainsEmail;
  bool get mustSelected => _filterCriteria.mustSelected;
  String get exportCsv {
    List<String> header = [];
    if(_selectedColumns.contains("發布日期")) {
      header.add("發布日期");
    }
    if(_selectedColumns.contains("影片標題")) {
      header.add("影片標題");
    }
    if(_selectedColumns.contains("影片連結")) {
      header.add("影片連結");
    }
    if(_selectedColumns.contains("觀看數")) {
      header.add("觀看數");
    }
    if(_selectedColumns.contains("喜歡數")) {
      header.add("喜歡數");
    }
    if(_selectedColumns.contains("留言數")) {
      header.add("留言數");
    }
    if(_selectedColumns.contains("頻道名稱")) {
      header.add("頻道名稱");
    }
    if(_selectedColumns.contains("頻道連結")) {
      header.add("頻道連結");
    }
    if(_selectedColumns.contains("訂閱數")) {
      header.add("訂閱數");
    }
    if(_selectedColumns.contains("Email")) {
      header.add("Email");
    }

    return const ListToCsvConverter().convert(
      [header, ..._originalData.where((element) => _selectedItems.contains(element.id.videoId)).map((e) {
        List<String> item = [];
        if(_selectedColumns.contains("發布日期")) {
          item.add(DateFormat('yyyy/MM/dd').format(e.snippet.publishTime));
        }
        if(_selectedColumns.contains("影片標題")) {
          item.add(e.snippet.title);
        }
        if(_selectedColumns.contains("影片連結")) {
          item.add(Uri.https('www.youtube.com','/watch', {'v': e.id.videoId}).toString());
        }
        if(_selectedColumns.contains("觀看數")) {
          item.add(e.id.videoViewCount);
        }
        if(_selectedColumns.contains("喜歡數")) {
          item.add(e.id.videoLikeCount);
        }
        if(_selectedColumns.contains("留言數")) {
          item.add(e.id.videoCommentCount);
        }
        if(_selectedColumns.contains("頻道名稱")) {
          item.add(e.snippet.channelTitle);
        }
        if(_selectedColumns.contains("頻道連結")) {
          item.add(Uri.https('www.youtube.com','channel/${e.snippet.channelId}').toString());
        }
        if(_selectedColumns.contains("訂閱數")) {
          item.add(e.snippet.followerCount);
        }
        if(_selectedColumns.contains("Email")) {
          item.add(e.snippet.email);
        }
        return item;
      })]
      
    );
  }

  // Dealing with the data to be displayed
  void onDisplayedDataSort (int columnIndex, bool isAscending) {
    _isSortByRelevance = false;
    _sortedColumnIndex = columnIndex;
    _isAscendingSortedColumn[_sortedColumnIndex] = isAscending;
    notifyListeners();
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
    notifyListeners();
    _displayedData = _onFilter(_originalData);
    notifyListeners();
  }

  void onSelectChanged(bool? isSelected, Item item) {
    switch (isSelected) {
      case true:
        _selectedItems.add(item.id.videoId);
      default:
        _selectedItems.remove(item.id.videoId);
    } 
    notifyListeners();
    _displayedData = _onFilter(_displayedData);
  }

  void onAddToSelectedColumns(String header) {
    _selectedColumns.add(header);
    notifyListeners();
  }

  void onRemoveFromSelectedColumns(String header) {
    _selectedColumns.remove(header);
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
      where((element) => element.snippet.title.toLowerCase().contains(_filterCriteria.titleContainedText.toLowerCase())).
      where((element) => int.parse(element.id.videoViewCount)>=int.parse(_filterCriteria.viewCountLowerBound)).
      where((element) => int.parse(element.id.videoLikeCount)>=int.parse(_filterCriteria.likeCountLowerBound)).
      where((element) => int.parse(element.id.videoCommentCount)>=int.parse(_filterCriteria.commentCountLowerBound)).
      where((element) => _filterCriteria.mustContainsEmail?element.snippet.email.isNotEmpty:true).
      where((element) => _filterCriteria.mustSelected?_selectedItems.contains(element.id.videoId):true).toList();
  }

  // Getting data via API
  search() async {
    if (_searchText.isNotEmpty) {
      log('Searching Started on YouTube...');
      _currentPage += 1;
      await _getSearchResultApi();
      log('Searching Completed on YouTube!');
      log('Current Page = $_currentPage');

      notifyListeners();
    }
  }

  onLoadMore() async {
    if (_nextPageToken.isNotEmpty) {
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
        'key': _youtubeApiKey.elementAt(_currentApiKeyIndex),
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
          currentResults = _searchResults.items.where((element) => !_videoIdSet.contains(element.id.videoId)).toList();
          _videoIdSet.addAll(currentResults.map((e) => e.id.videoId).toSet());
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
          break;
        default:
          _currentApiKeyIndex = (_currentApiKeyIndex+1)%_youtubeApiKey.length;
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
        'key': _youtubeApiKey.elementAt(_currentApiKeyIndex),
      }
    );
    try {
      http.Response response = await http.get(uri);
      switch (response.statusCode) {
        case 200:
          _channelResponse = channel.youtubeChannelFromJson(response.body);
        default:
          _currentApiKeyIndex = (_currentApiKeyIndex+1)%_youtubeApiKey.length;
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
        'key': _youtubeApiKey.elementAt(_currentApiKeyIndex),
      }
    );
    try {
      http.Response response = await http.get(uri);
      switch (response.statusCode) {
        case 200:
          _videoResponse = video.youtubeVideoFromJson(response.body);
        default:
          _currentApiKeyIndex = (_currentApiKeyIndex+1)%_youtubeApiKey.length;
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
  String titleContainedText = '';
  String viewCountLowerBound = '0';
  String likeCountLowerBound = '0';
  String commentCountLowerBound = '0';
  bool mustContainsEmail = false;
  bool mustSelected = false;
}
