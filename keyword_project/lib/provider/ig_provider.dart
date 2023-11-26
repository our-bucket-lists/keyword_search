import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:keyword_project/modles/ig_search_model.dart';


class InstagramSearchProvider extends ChangeNotifier {
  static const apiEndpoint ='www.instagram.com';

  bool isLoading = true;
  String error = '';
  InstagramSearch searchResults = InstagramSearch(
    count: 0, 
    data: Data(
      mediaCount: 0,
      top: Top(),
    ), 
    status: ''
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
  
  List<Section> get results => searchResults.data.top.sections;

  search() async {
    if (_searchText.isNotEmpty) {
      log('Searching on Instagram...');
      await getSearchResultAPI(keyword: _searchText);
      log('Completed on Instagram!');
    } else {

    }
  }

  getSearchResultAPI({String keyword=''}) async {
    var uri = Uri.http(
      '127.0.0.1:5000',
      '/api/v1/ig',
      {'tag_name': keyword
      }
    );
    var headersList = {
      'authority': 'www.instagram.com',
      'accept': '*/*',
      'accept-language': 'en-US,en;q=0.9',
      'cookie': 'ig_did=550C8BF4-304D-4FD8-A345-E3A972F59A15; ig_nrcb=1; datr=gdvlZAj-NqukUm_bOV2ZGjrw; mid=ZOXbggAEAAFgD79ik0vu9a6OZpi6; locale=zh_TW; fbm_124024574287414=base_domain=.instagram.com; shbid="171850542814247470541732187079:01f7a0ded7d20d523107860a36adc89ac6e572d4e09c6858487c9ccf8c178c48d7e011ad"; shbts="17006510790542814247470541732187079:01f799d4d532edafadd1f11e28e26b350c4ab8b6d49d25f583fc1305710433c0a4026f9b"; csrftoken=wEQAfPqR2DNpWdLTRaH0nVofFKxsQCT0; ds_user_id=281424747; sessionid=281424747%3AyvDtL1wYTIEICR%3A5%3AAYdygacI7CJWlNnSFpfKl7NxcJvuUSLjprxOqy1gEQ; rur="CCO0542814247470541732216386:01f734a88ddf27e6a2b058da286c9e9de00ad5e4885d4b0d0e9b6dfefb79ffe27af7a210"',
      'dnt': '1',
      'dpr': '2',
      'referer': 'https://www.instagram.com/explore/tags/%E6%B8%AC%E8%A9%A6/',
      'sec-ch-prefers-color-scheme': 'dark',
      'sec-ch-ua': 'Microsoft Edge";v="119", "Chromium";v="119", "Not?A_Brand";v="24',
      'sec-ch-ua-full-version-list': 'Microsoft Edge";v="119.0.2151.58", "Chromium";v="119.0.6045.123", "Not?A_Brand";v="24.0.0.0',
      'sec-ch-ua-mobile': '?0',
      'sec-ch-ua-model': '',
      'sec-ch-ua-platform': 'macOS',
      'sec-ch-ua-platform-version': '13.6.2',
      'sec-fetch-dest': 'empty',
      'sec-fetch-mode': 'cors',
      'sec-fetch-site': 'same-origin',
      'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0',
      'viewport-width': '688',
      'x-asbd-id': '129477',
      'x-csrftoken': 'wEQAfPqR2DNpWdLTRaH0nVofFKxsQCT0',
      'x-ig-app-id': '936619743392459',
      'x-ig-www-claim': 'hmac.AR1MfMnTlsS4u5vssROtVRm1iMJ_9-6aG2p2SlobP0mbAB2z',
      'x-requested-with': 'XMLHttpRequest' 
      };
    isLoading = true;
    notifyListeners();
    log(uri.toString());

    try {
      http.Response response = await http.get(
        uri, 
        headers: headersList
      );
      if (response.statusCode == 200) {
        log('Response from Instegra: ${response.body}');
        searchResults = instagramSearchFromJson(response.body);
      } else {
        error = response.statusCode.toString();
        log('Http Response Error: $error');
      }
    } catch (e) {
      error = e.toString();
      log('Http Request Execution Error: $error');
    }

    isLoading = false;
    notifyListeners();
  }
}
