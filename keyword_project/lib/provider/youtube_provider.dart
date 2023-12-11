import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:keyword_project/modles/youtube_search_model.dart';
import 'package:keyword_project/modles/youtube_channel_model.dart' as channel;
import 'package:keyword_project/modles/youtube_video_model.dart' as video;

class YoutubeSearchProvider extends ChangeNotifier {
  static const apiEndpoint = 'youtube.googleapis.com';
  final String _youtubeApiKey = 'AIzaSyDl6f1JPAAE59rp_ts7Al_fX7vMG7-_4Sk';
  bool isLoading = true;
  String error = '';
  YoutubeSearch searchResults = YoutubeSearch(
    nextPageToken: '', 
    pageInfo: PageInfo(totalResults: 0, resultsPerPage: 0), 
    items: []
  );
  channel.YoutubeChannel channelResponse = channel.YoutubeChannel(items: []);
  video.YoutubeVideo videoResponse = video.YoutubeVideo(items: []);
  String _searchText = '';
  List<Item> _currentResults = [];

  set input(String inputText) {
    _searchText = inputText;
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  List<Item> get results => searchResults.items;

  search() async {
    if (_searchText.isNotEmpty) {
      isLoading = true;
      notifyListeners();

      log('Searching Started on YouTube...');
      await getSearchResultApi(keyword: _searchText);
      log('Searching Completed on YouTube!');

      isLoading = false;
      notifyListeners();
    }
  }

  getSearchResultApi({String keyword = ''}) async {
    var uri = Uri.https(
      apiEndpoint,
      '/youtube/v3/search', 
      {
        'part': 'snippet',
        'maxResults': '30',
        'key': _youtubeApiKey,
        'type':'video',
        'q': keyword
      }
    );
    try {
      http.Response response = await http.get(uri);
      switch (response.statusCode) {
        case 200:
          searchResults = youtubeSearchFromJson(response.body);
          _currentResults =  List.from(searchResults.items);
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
        default:
          log('[ERROR] Http Response Error: ${response.statusCode.toString()}');
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
