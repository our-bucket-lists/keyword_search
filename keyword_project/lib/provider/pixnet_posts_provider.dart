import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:keyword_project/modles/pixnet_posts_model.dart';


class PixnetSearchProvider extends ChangeNotifier {
  static const apiEndpoint =
    'https://emma.pixnet.cc/blog/articles/search';

  bool isLoading = true;
  String error = '';
  PixnetSearch searchResults = PixnetSearch(articles: []);
  String _searchText = '';

  set input(String inputText) {
    _searchText = inputText;
    print("Recieve the input: $_searchText");
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }
  
  List<Article> get posts => searchResults.articles;

  search() async {
    if (_searchText.isNotEmpty) {
      print('Searching...');
      await getSearchResultAPI(keyword: _searchText);
      print('Completed!');
    } else {

    }
  }

  getSearchResultAPI({String keyword=''}) async {
    isLoading = true;
    notifyListeners();
    
    try {
      http.Response response = await http.get(
        Uri.parse('$apiEndpoint?keyword=$keyword')
      );
      if (response.statusCode == 200) {
        searchResults = pixnetSearchFromJson(response.body);
        print(searchResults.toJson());
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