// To parse this JSON data, do
//
//     final youtubeVideo = youtubeVideoFromJson(jsonString);

import "dart:convert";

YoutubeVideo youtubeVideoFromJson(String str) => YoutubeVideo.fromJson(json.decode(str));

String youtubeVideoToJson(YoutubeVideo data) => json.encode(data.toJson());

class YoutubeVideo {
    List<Item> items;

    YoutubeVideo({
        required this.items,
    });

    factory YoutubeVideo.fromJson(Map<String, dynamic> json) => YoutubeVideo(
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
    };
}

class Item {
    Statistics statistics;

    Item({
        required this.statistics,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        statistics: json.containsKey("statistics")?Statistics.fromJson(json["statistics"]):Statistics(viewCount: "0", likeCount: "0", favoriteCount: "0", commentCount: "0"),
    );

    Map<String, dynamic> toJson() => {
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
