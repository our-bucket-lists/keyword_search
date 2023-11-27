// To parse this JSON data, do
//
//     final youtubeSearch = youtubeSearchFromJson(jsonString);

import 'dart:convert';

YoutubeSearch youtubeSearchFromJson(String str) => YoutubeSearch.fromJson(json.decode(str));

String youtubeSearchToJson(YoutubeSearch data) => json.encode(data.toJson());

class YoutubeSearch {
    String nextPageToken;
    PageInfo pageInfo;
    List<Item> items;

    YoutubeSearch({
        required this.nextPageToken,
        required this.pageInfo,
        required this.items,
    });

    factory YoutubeSearch.fromJson(Map<String, dynamic> json) => YoutubeSearch(
        nextPageToken: json["nextPageToken"],
        pageInfo: PageInfo.fromJson(json["pageInfo"]),
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "nextPageToken": nextPageToken,
        "pageInfo": pageInfo.toJson(),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
    };
}

class Item {
    Id id;
    Snippet snippet;

    Item({
        required this.id,
        required this.snippet,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: Id.fromJson(json["id"]),
        snippet: Snippet.fromJson(json["snippet"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id.toJson(),
        "snippet": snippet.toJson(),
    };
}

class Id {
    String videoId;

    Id({
        required this.videoId,
    });

    factory Id.fromJson(Map<String, dynamic> json) => Id(
        videoId: json["videoId"],
    );

    Map<String, dynamic> toJson() => {
        "videoId": videoId,
    };
}

class Snippet {
    DateTime publishedAt;
    String channelId;
    String title;
    String description;
    String channelTitle;
    DateTime publishTime;
    String email;

    Snippet({
        required this.publishedAt,
        required this.channelId,
        required this.title,
        required this.description,
        required this.channelTitle,
        required this.publishTime,
        required this.email,
    });

    factory Snippet.fromJson(Map<String, dynamic> json) => Snippet(
        publishedAt: DateTime.parse(json["publishedAt"]),
        channelId: json["channelId"],
        title: json["title"],
        description: json["description"],
        channelTitle: json["channelTitle"],
        publishTime: DateTime.parse(json["publishTime"]),
        email: 'user@email.com',
    );

    Map<String, dynamic> toJson() => {
        "publishedAt": publishedAt.toIso8601String(),
        "channelId": channelId,
        "title": title,
        "description": description,
        "channelTitle": channelTitle,
        "publishTime": publishTime.toIso8601String(),
    };
}

class PageInfo {
    int totalResults;
    int resultsPerPage;

    PageInfo({
        required this.totalResults,
        required this.resultsPerPage,
    });

    factory PageInfo.fromJson(Map<String, dynamic> json) => PageInfo(
        totalResults: json["totalResults"],
        resultsPerPage: json["resultsPerPage"],
    );

    Map<String, dynamic> toJson() => {
        "totalResults": totalResults,
        "resultsPerPage": resultsPerPage,
    };
}
