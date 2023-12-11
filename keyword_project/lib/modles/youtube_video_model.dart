// To parse this JSON data, do
//
//     final youtubeVideo = youtubeVideoFromJson(jsonString);

import "dart:convert";

YoutubeVideo youtubeVideoFromJson(String str) => YoutubeVideo.fromJson(json.decode(str));

String youtubeVideoToJson(YoutubeVideo data) => json.encode(data.toJson());

class YoutubeVideo {
    // String kind;
    // String etag;
    List<Item> items;
    // PageInfo pageInfo;

    YoutubeVideo({
        // required this.kind,
        // required this.etag,
        required this.items,
        // required this.pageInfo,
    });

    factory YoutubeVideo.fromJson(Map<String, dynamic> json) => YoutubeVideo(
        // kind: json["kind"],
        // etag: json["etag"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        // pageInfo: PageInfo.fromJson(json["pageInfo"]),
    );

    Map<String, dynamic> toJson() => {
        // "kind": kind,
        // "etag": etag,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        // "pageInfo": pageInfo.toJson(),
    };
}

class Item {
    // String kind;
    // String etag;
    // String id;
    Statistics statistics;

    Item({
        // required this.kind,
        // required this.etag,
        // required this.id,
        required this.statistics,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        // kind: json["kind"],
        // etag: json["etag"],
        // id: json["id"],
        statistics: json.containsKey("statistics")?Statistics.fromJson(json["statistics"]):Statistics(viewCount: "0", likeCount: "0", favoriteCount: "0", commentCount: "0"),
    );

    Map<String, dynamic> toJson() => {
        // "kind": kind,
        // "etag": etag,
        // "id": id,
        "statistics": statistics.toJson(),
    };
}

class Statistics {
    String viewCount;
    String likeCount;
    String favoriteCount;
    String commentCount;

    Statistics({
        required this.viewCount,
        required this.likeCount,
        required this.favoriteCount,
        required this.commentCount,
    });

    factory Statistics.fromJson(Map<String, dynamic> json) => Statistics(
        viewCount: json.containsKey("viewCount")?json["viewCount"]:"0",
        likeCount: json.containsKey("likeCount")?json["likeCount"]:"0",
        favoriteCount: json.containsKey("favoriteCount")?json["favoriteCount"]:"0",
        commentCount: json.containsKey("commentCount")?json["commentCount"]:"0",
    );

    Map<String, dynamic> toJson() => {
        "viewCount": viewCount,
        "likeCount": likeCount,
        "favoriteCount": favoriteCount,
        "commentCount": commentCount,
    };
}

// class PageInfo {
//     int totalResults;
//     int resultsPerPage;

//     PageInfo({
//         required this.totalResults,
//         required this.resultsPerPage,
//     });

//     factory PageInfo.fromJson(Map<String, dynamic> json) => PageInfo(
//         totalResults: json["totalResults"],
//         resultsPerPage: json["resultsPerPage"],
//     );

//     Map<String, dynamic> toJson() => {
//         "totalResults": totalResults,
//         "resultsPerPage": resultsPerPage,
//     };
// }
