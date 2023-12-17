// To parse this JSON data, do
//
//     final youtubeSearch = youtubeSearchFromJson(jsonString);

import "dart:convert";

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
        nextPageToken: json.containsKey("nextPageToken")?json["nextPageToken"]:"",
        pageInfo: json.containsKey("pageInfo")?PageInfo.fromJson(json["pageInfo"]):PageInfo(totalResults: 0, resultsPerPage: 0),
        items: json.containsKey("items")?List<Item>.from(json["items"].map((x) => Item.fromJson(x))):[],
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
        id: json.containsKey("id")?Id.fromJson(json["id"]):Id(videoId: "", videoViewCount: "", videoLikeCount: "", videoCommentCount: ""),
        snippet: json.containsKey("snippet")?Snippet.fromJson(json["snippet"]):Snippet(publishedAt: DateTime.now(), channelId: "", title: "", description: "", channelTitle: "", publishTime: DateTime.now(), email: "", ig:"", followerCount: ""),
    );

    Map<String, dynamic> toJson() => {
        "id": id.toJson(),
        "snippet": snippet.toJson(),
    };
}

class Id {
    String videoId;
    String videoViewCount;
    String videoLikeCount;
    String videoCommentCount;

    Id({
        required this.videoId, 
        required this.videoViewCount, 
        required this.videoLikeCount, 
        required this.videoCommentCount,
    });

    factory Id.fromJson(Map<String, dynamic> json) => Id(
        videoId: json.containsKey("videoId")?json["videoId"]:"",
        videoViewCount: "",
        videoLikeCount: "",
        videoCommentCount: "",
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
    String ig;
    String followerCount;

    Snippet({
        required this.publishedAt,
        required this.channelId,
        required this.title,
        required this.description,
        required this.channelTitle,
        required this.publishTime,
        required this.email,
        required this.ig,
        required this.followerCount,
    });

    factory Snippet.fromJson(Map<String, dynamic> json) => Snippet(
        publishedAt: json.containsKey("publishedAt")?DateTime.parse(json["publishedAt"]):DateTime.now(),
        channelId: json.containsKey("channelId")?json["channelId"]:"",
        title: json.containsKey("title")?json["title"]:"",
        description: json.containsKey("description")?json["description"]:"",
        channelTitle: json.containsKey("channelTitle")?json["channelTitle"]:"",
        publishTime: json.containsKey("publishTime")?DateTime.parse(json["publishTime"]):DateTime.now(),
        email: "",
        ig: "",
        followerCount: "",
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
        totalResults: json.containsKey("totalResults")?json["totalResults"]:0,
        resultsPerPage: json.containsKey("resultsPerPage")?json["resultsPerPage"]:0,
    );

    Map<String, dynamic> toJson() => {
        "totalResults": totalResults,
        "resultsPerPage": resultsPerPage,
    };
}
