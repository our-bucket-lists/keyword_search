import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:keyword_project/common/global.dart';

import 'package:keyword_project/modles/youtube_search_model.dart';
import 'package:keyword_project/modles/youtube_channel_model.dart' as channel;
import 'package:keyword_project/modles/youtube_video_model.dart' as video;

class YoutubeSearchProvider extends ChangeNotifier {
  static const apiEndpoint = 'youtube.googleapis.com';
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
  final String _youtubeApiKey = 'AIzaSyDl6f1JPAAE59rp_ts7Al_fX7vMG7-_4Sk';

  set input(String inputText) {
    _searchText = inputText;
    log("Recieve the input: $_searchText");
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  List<Item> get results => searchResults.items;

  search() async {
    if (_searchText.isNotEmpty) {
      log('Searching...');
      await getSearchResultAPI(keyword: _searchText);
      log('Completed!');
    } else {}
  }

  getSearchResultAPI({String keyword = ''}) async {
    isLoading = true;
    notifyListeners();
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
    log(uri.toString());
    try {
      http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        log(response.body.toString());
        searchResults = youtubeSearchFromJson(response.body);
        
        Map tmp;
        for (var element in searchResults.items) {
          tmp = await getYoutubeChannelInfo(element.snippet.channelId);
          element.snippet.email = tmp['email'];
          element.snippet.followerCount = tmp['followerCount'];
          tmp = await getYoutubeVideoInfo(element.id.videoId);
          element.id.videoViewCount = tmp['videoViewCount'];
          element.id.videoLikeCount = tmp['videoLikeCount'];
          element.id.videoCommentCount = tmp['videoCommentCount'];
        }
      } else {
        error = response.statusCode.toString();
      }
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
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
    log(uri.toString());
    try {
      http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        log(response.body.toString());
        channelResponse = channel.youtubeChannelFromJson(response.body);
      } else {
        error = response.statusCode.toString();
      }
    } catch (e) {
      error = e.toString();
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
    log(uri.toString());
    try {
      http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        log(response.body.toString());
        videoResponse = video.youtubeVideoFromJson(response.body);
      } else {
        error = response.statusCode.toString();
      }
    } catch (e) {
      error = e.toString();
    }

    return {
      'videoViewCount': videoResponse.items[0].statistics.viewCount,
      'videoLikeCount': videoResponse.items[0].statistics.likeCount,
      'videoCommentCount': videoResponse.items[0].statistics.commentCount,
    };
  }


}
