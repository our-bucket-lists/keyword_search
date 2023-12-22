import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';

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
  var _selectedItems = <String>{};
  final _selectedColumns = <String>{'發布日期', '文章標題', '文章連結', '創作者名稱', '創作者主頁連結', 'IG', 'Email', '觀看數', '留言數'};

  // For data sorting and filtering
  FilterCriteria _filterCriteria = FilterCriteria();
  List<bool> _isAscendingSortedColumn = List.generate(7, (index) => false);
  bool _isSortByRelevance = true; 
  int _sortedColumnIndex = 0;
  bool isLoadMoreDisplayed = false;

  // For loading indicator
  bool _isLoading = false;

  // Setter
  set searchText(String searchText) {
    // For API request
    _searchText = searchText;
    _maxPage = 0;
    _currentPage = 0;
    notifyListeners();

    // For API response
    _searchResults = PixnetSearch(
        error: false,
        data: Data(results: [], page: 0, perPage: 0, totalPage: 0, totalFeeds: 0));
    notifyListeners();

    // For Data storage
    _originalData = <Feed>[];
    _displayedData = <Feed>[];
    _selectedItems = <String>{};
    notifyListeners();

    // For data sorting and filtering
    _filterCriteria = FilterCriteria();
    _isAscendingSortedColumn = List.generate(7, (index) => false);
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
  set viewCountLowerBound(String input) {
    _filterCriteria.viewCountLowerBound = input;
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
  set mustContainsIg(bool input) {
    _filterCriteria.mustContainsIg = input;
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
  List<Feed> get originalData => _originalData;
  List<Feed> get displayedData => _displayedData;
  Set<String> get selectedItems => _selectedItems;
  Set<String> get selectedColumns => _selectedColumns;
  List<bool> get isAscendingSortedColumn => _isAscendingSortedColumn;
  int get sortedColumnIndex => _sortedColumnIndex;
  bool get isSortByRelevance => _isSortByRelevance;
  bool get mustContainsEmail => _filterCriteria.mustContainsEmail;
  bool get mustContainsIg => _filterCriteria.mustContainsIg;
  bool get mustSelected => _filterCriteria.mustSelected;
  bool get isLoading => _isLoading;
  String get exportCsv {
    List<String> header = [];
    if(_selectedColumns.contains("發布日期")) {
      header.add("發布日期");
    }
    if(_selectedColumns.contains("文章標題")) {
      header.add("文章標題");
    }
    if(_selectedColumns.contains("文章連結")) {
      header.add("文章連結");
    }
    if(_selectedColumns.contains("創作者名稱")) {
      header.add("創作者名稱");
    }
    if(_selectedColumns.contains("創作者主頁連結")) {
      header.add("創作者主頁連結");
    }
    if(_selectedColumns.contains("IG")) {
      header.add("IG");
    }
    if(_selectedColumns.contains("Email")) {
      header.add("Email");
    }
    if(_selectedColumns.contains("觀看數")) {
      header.add("觀看數");
    }
    if(_selectedColumns.contains("留言數")) {
      header.add("留言數");
    }

    return const ListToCsvConverter().convert(
      [header, ..._originalData.where((element) => _selectedItems.contains(element.link)).map((e) {
        List<String> item = [];
        if(_selectedColumns.contains("發布日期")) {
          item.add(DateFormat('yyyy/MM/dd').format(e.createdAt));
        }
        if(_selectedColumns.contains("文章標題")) {
          item.add(e.title);
        }
        if(_selectedColumns.contains("文章連結")) {
          item.add(e.link);
        }
        if(_selectedColumns.contains("創作者名稱")) {
          item.add(e.displayName);
        }
        if(_selectedColumns.contains("創作者主頁連結")) {
          item.add('https://www.pixnet.net/pcard/${e.memberUniqid}');
        }
        if(_selectedColumns.contains("IG")) {
          item.add(e.ig);
        }
        if(_selectedColumns.contains("Email")) {
          item.add(e.email);
        }
        if(_selectedColumns.contains("觀看數")) {
          item.add(e.hit.toString());
        }
        if(_selectedColumns.contains("留言數")) {
          item.add(e.replyCount.toString());
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
        _displayedData.sort((a, b) => _onCompare(isAscending, a.createdAt, b.createdAt));
      case 1:
        _displayedData.sort((a, b) => _onCompare(isAscending, a.title, b.title));
      case 2:
        _displayedData.sort((a, b) => _onCompare(isAscending, a.displayName, b.displayName));
      case 3:
        _displayedData.sort((a, b) => _onCompare(isAscending, a.ig, b.ig));
      case 4:
        _displayedData.sort((a, b) => _onCompare(isAscending, a.email, b.email));
      case 5:
        _displayedData.sort((a, b) => _onCompare(isAscending, a.hit, b.hit));
      case 6:
        _displayedData.sort((a, b) => _onCompare(isAscending, a.replyCount, b.replyCount));
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
    _isAscendingSortedColumn = List.generate(7, (index) => false);
    notifyListeners();
    _displayedData = _onFilter(_originalData);
    notifyListeners();
  }

  void onSelectChanged(bool? isSelected, Feed item) {
    switch (isSelected) {
      case true:
        _selectedItems.add(item.link);
      default:
        _selectedItems.remove(item.link);
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

  List<Feed> _onFilter (List<Feed> inputList) {
    return inputList.
      where((element) => element.title.toLowerCase().contains(_filterCriteria.titleContainedText.toLowerCase())).
      where((element) => element.hit>=int.parse(_filterCriteria.viewCountLowerBound)).
      where((element) => element.replyCount>=int.parse(_filterCriteria.commentCountLowerBound)).
      where((element) => _filterCriteria.mustContainsEmail?element.email.isNotEmpty:true).
      where((element) => _filterCriteria.mustContainsIg?element.ig.isNotEmpty:true).
      where((element) => _filterCriteria.mustSelected?_selectedItems.contains(element.link):true).toList();
  }

  // Getting data via API
  search() async {
    if (_searchText.isNotEmpty) {
      isLoading = true;
      log('Searching Started on Pixnet...');
      _currentPage += 1;
      await _getSearchResultApi();
      log('Searching Completed on Pixnet!');
      log('Max Page = $_maxPage');
      log('Current Page = $_currentPage');

      notifyListeners();
      isLoading = false;
    }
  }

  onLoadMore() async {
    if (_currentPage<_maxPage) {
      isLoading = true;
      log('Loading more is started on Pixnet...');
      _currentPage += 1;
      await _getSearchResultApi();
      log('Loading more is completed on Pixnet!');
      log('Current Page = $_currentPage');

      notifyListeners();
      isLoading = false;
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

class FilterCriteria {
  String titleContainedText = '';
  String viewCountLowerBound = '0';
  String commentCountLowerBound = '0';
  bool mustContainsEmail = false;
  bool mustContainsIg = false;
  bool mustSelected = false;
}
