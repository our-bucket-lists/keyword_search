import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';

import 'package:keyword_project/modles/ig_hashtag_search_model.dart' as hashtag;
import 'package:keyword_project/modles/ig_media_search_model.dart';


class InstagramSearchProvider extends ChangeNotifier {
  // For API request
  static const _apiEndpoint = 'graph.facebook.com';
  static const _userId = '17841400502414397';
  static const _token = 'EAAYs6H9ZCiEEBO6wLy00PaWQS9GtP5yyCV2ZCZC7YcI9yk00xRhwaQY1YQl8J3grLsCZCoFInftsRLqlpNSs9nIyOFLWCT6xvTaGlOrxj9t8FcTiwVSQqqQB2kC617AP2HeeQM6QyG6Po8YQZBFdaZBCi27DAZCpUhbOQXqOkaorYQbzo7yJdOvTZAjR8IpoqTYtbG287MhI8DkyJtJWMO5u9nRpHQqg';
  String _searchText = '';
  String _nextPageLink = '';
  int _currentPage = 0;

  // For API response
  String _hashtagId = '';
  IgMediaSearch _searchResults = IgMediaSearch(data: [], paging: Paging(cursors: Cursors(after: ''), next: ''));
  
  // For Data storage
  var _originalData = <Datum>[];
  var _displayedData = <Datum>[];
  var _selectedItems = <String>{};
  final _selectedColumns = <String>{'發布日期', '文章摘要', '文章連結', '帳號', '主頁連結', '喜歡數', '留言數',};
  var _postIdSet = HashSet<String>();

  // For data sorting and filtering
  FilterCriteria _filterCriteria = FilterCriteria();
  List<bool> _isAscendingSortedColumn = List.generate(5, (index) => false);
  bool _isSortByRelevance = true; 
  int _sortedColumnIndex = 0;
  bool isLoadMoreDisplayed = false;

  // For loading indicator
  bool _isLoading = false;

  // Seter
  set searchText(String searchText) {
    _searchText = searchText;
    // For API request
    _searchText = searchText;
    _nextPageLink = '';
    _currentPage = 0;
    notifyListeners();

    // For API response
    _hashtagId = '';
    _searchResults = IgMediaSearch(data: [], paging: Paging(cursors: Cursors(after: ''), next: ''));
    notifyListeners();

    // For Data storage
    _originalData = <Datum>[];
    _displayedData = <Datum>[];
    _selectedItems = <String>{};
    _postIdSet = HashSet<String>();
    notifyListeners();    

    // For data sorting and filtering
    _filterCriteria = FilterCriteria();
    _isAscendingSortedColumn = List.generate(5, (index) => false);
    _isSortByRelevance = true; 
    _sortedColumnIndex = 0;
    isLoadMoreDisplayed = false;

    // For loading indicator
    _isLoading = false;

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
  set likeCountLowerBound(String input) {
    _filterCriteria.likeCountLowerBound = input;
    notifyListeners();
  }
  set commentCountLowerBound(String input) {
    _filterCriteria.commentCountLowerBound = input;
    notifyListeners();
  }
  set mustSelected(bool input) {
    _filterCriteria.mustSelected = input;
    notifyListeners();
  }
  set isLoading(bool input) {
    _isLoading = input;
    notifyListeners();
  }


  // Geter
  String get searchText => _searchText;
  List<Datum> get originalData => _originalData;
  List<Datum> get displayedData => _displayedData;
  Set<String> get selectedItems => _selectedItems;
  Set<String> get selectedColumns => _selectedColumns;
  List<bool> get isAscendingSortedColumn => _isAscendingSortedColumn;
  int get sortedColumnIndex => _sortedColumnIndex;
  bool get isSortByRelevance => _isSortByRelevance;
  bool get mustSelected => _filterCriteria.mustSelected;
  bool get isLoading => _isLoading;
  String get exportCsv {
    List<String> header = [];
    if(_selectedColumns.contains("發布日期")) {
      header.add("發布日期");
    }
    if(_selectedColumns.contains("文章摘要")) {
      header.add("文章摘要");
    }
    if(_selectedColumns.contains("文章連結")) {
      header.add("文章連結");
    }
    if(_selectedColumns.contains("帳號")) {
      header.add("帳號");
    }
    if(_selectedColumns.contains("主頁連結")) {
      header.add("主頁連結");
    }
    if(_selectedColumns.contains("喜歡數")) {
      header.add("喜歡數");
    }
    if(_selectedColumns.contains("留言數")) {
      header.add("留言數");
    }

    return const ListToCsvConverter().convert(
      [header, ..._originalData.where((element) => _selectedItems.contains(element.permalink)).map((e) {
        List<String> item = [];
        if(_selectedColumns.contains("發布日期")) {
          item.add(DateFormat('yyyy/MM/dd').format(e.timestamp));
        }
        if(_selectedColumns.contains("文章摘要")) {
          item.add(e.caption);
        }
        if(_selectedColumns.contains("文章連結")) {
          item.add(e.permalink.toString());
        }
        if(_selectedColumns.contains("帳號")) {
          item.add(e.username);
        }
        if(_selectedColumns.contains("主頁連結")) {
          item.add(Uri.https('www.instagram.com',e.username).toString());
        }
        if(_selectedColumns.contains("喜歡數")) {
          item.add(e.likeCount.toString());
        }
        if(_selectedColumns.contains("留言數")) {
          item.add(e.commentsCount.toString());
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
        _displayedData.sort((a, b) => _onCompare(isAscending, a.timestamp, b.timestamp));
      case 1:
        _displayedData.sort((a, b) => _onCompare(isAscending, a.caption, b.caption));
      case 2:
        _displayedData.sort((a, b) => _onCompare(isAscending, a.username, b.username));
      case 3:
        _displayedData.sort((a, b) => _onCompare(isAscending, a.likeCount, b.likeCount));
      case 4:
        _displayedData.sort((a, b) => _onCompare(isAscending, a.commentsCount, b.commentsCount));
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

  void onSelectChanged(bool? isSelected, Datum item) {
    switch (isSelected) {
      case true:
        _selectedItems.add(item.permalink);
      default:
        _selectedItems.remove(item.permalink);
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

  List<Datum> _onFilter (List<Datum> inputList) {
    return inputList.
      where((element) => element.caption.toLowerCase().contains(_filterCriteria.titleContainedText.toLowerCase())).
      where((element) => element.likeCount>=int.parse(_filterCriteria.likeCountLowerBound)).
      where((element) => element.commentsCount>=int.parse(_filterCriteria.commentCountLowerBound)).
      where((element) => _filterCriteria.mustSelected?_selectedItems.contains(element.permalink):true).toList();
  }

  // Getting data via API
  search() async {
    if (_searchText.isNotEmpty) {
      try {
        isLoading = true;
        log('Searching Started on Instagram...');
        _currentPage += 1;
        await _getHashTagIdApi();
        await _getSearchResultApi();

        log('Searching Completed on Instagram!');
        log('Current Page = $_currentPage');
        notifyListeners();
      } finally {
        isLoading = false;
      }
     
      
    }
  }

  onLoadMore() async {
    if (_nextPageLink.isNotEmpty) {
      try {
        isLoading = true;
        log('Loading more is started on YouTube...');
        _currentPage += 1;
        await _getSearchResultApi();

        log('Loading more is completed on YouTube!');
        log('Current Page = $_currentPage');
        notifyListeners();
      } finally {
        isLoading = false;
      }
    }
  }

  _getHashTagIdApi() async {
    var uri = Uri.http(
      _apiEndpoint,
      '/v18.0/ig_hashtag_search',
      {
        'q': _searchText,
        'user_id': _userId,
        'access_token': _token,
      }
    );

    try {
      http.Response response = await http.get(uri);
      switch (response.statusCode) {
        case 200:
          _hashtagId = hashtag.igHashtagSearchFromJson(response.body).data.first.id;
        default:
          log('[ERROR] Http Response Error: ${response.statusCode.toString()}');
          throw Exception(response.reasonPhrase);
      }
    } catch (err) {
      log('[ERROR] Http Request Execution Error: ${err.toString()}');
      rethrow;
    }
  }

  _getSearchResultApi() async {
    List<Datum> currentResults = [];
    Uri uri;
    
    if (_nextPageLink.isEmpty) {
      uri = Uri.http(
        _apiEndpoint,
        '/v18.0/$_hashtagId/top_media',
        {
          'fields': 'caption,comments_count,like_count,permalink,timestamp',
          'user_id': _userId,
          'access_token': _token,
          'limit': '50',
        }
      );
    } else {
      uri = Uri.parse(_nextPageLink);
    }

    try {
      http.Response response = await http.get(uri);
      switch (response.statusCode) {
        case 200:
          _searchResults = igMediaSearchFromJson(response.body);
          _nextPageLink = _searchResults.paging.next;
          currentResults =  _searchResults.data.where((element) => !_postIdSet.contains(element.id)).toList();
          _postIdSet.addAll(currentResults.map((e) => e.id).toSet());
          await Future.wait(
            currentResults.map(
              (element) async => element.username = await _getMoreIgInfo(queryUrl: Uri.parse(element.permalink))
            )
          ).then(
            (List response) => log('All Instagram Searching processed.')
          ).catchError((err) {
            log('[ERROR] Http Request Execution Error: ${err.toString()}');
            throw Exception(throw err);
          });

          _displayedData.addAll(_onFilter(currentResults));
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

  _getMoreIgInfo({required Uri queryUrl}) async {
    var uri = Uri.http(
      'ec2-13-210-189-82.ap-southeast-2.compute.amazonaws.com:5000',
      '/api/v1/instagram/profile', 
      {'url': queryUrl.toString()}
    );
    http.Response response = await http.get(uri);
    switch (response.statusCode) {
      case 200:
        if (json.decode(response.body)!=null){
          return json.decode(response.body).containsKey('username')?json.decode(response.body)['username']:'';
        } else {
          return '';
        }
        
      default:
        log('[ERROR] Http Response Error: ${response.statusCode.toString()}');
        throw Exception(response.reasonPhrase);
    }
  }
}

class FilterCriteria {
  String titleContainedText = '';
  String likeCountLowerBound = '0';
  String commentCountLowerBound = '0';
  bool mustSelected = false;
}
