// To parse this JSON data, do
//
//     final igMediaSearch = igMediaSearchFromJson(jsonString);

import 'dart:convert';

IgMediaSearch igMediaSearchFromJson(String str) => IgMediaSearch.fromJson(json.decode(str));

String igMediaSearchToJson(IgMediaSearch data) => json.encode(data.toJson());

class IgMediaSearch {
    List<Datum> data;
    Paging paging;

    IgMediaSearch({
        required this.data,
        required this.paging,
    });

    factory IgMediaSearch.fromJson(Map<String, dynamic> json) => IgMediaSearch(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        paging: Paging.fromJson(json["paging"]),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "paging": paging.toJson(),
    };
}

class Datum {
    String caption;
    int commentsCount;
    int likeCount;
    String permalink;
    DateTime timestamp;
    String id;
    String username = '';

    Datum({
        required this.caption,
        required this.commentsCount,
        required this.likeCount,
        required this.permalink,
        required this.timestamp,
        required this.id,
    });

    factory Datum.fromJson(Map<String, dynamic> data) => Datum(
        caption: data["caption"],
        commentsCount: data["comments_count"],
        likeCount: data.containsKey("like_count")?data["like_count"]:0,
        permalink: data["permalink"],
        timestamp: DateTime.parse(data["timestamp"]),
        id: data["id"],
    );

    Map<String, dynamic> toJson() => {
        "caption": caption,
        "comments_count": commentsCount,
        "like_count": likeCount,
        "permalink": permalink,
        "timestamp": timestamp,
        "id": id,
    };
}

class Paging {
    Cursors cursors;
    String next;

    Paging({
        required this.cursors,
        required this.next,
    });

    factory Paging.fromJson(Map<String, dynamic> json) => Paging(
        cursors: Cursors.fromJson(json["cursors"]),
        next: json["next"],
    );

    Map<String, dynamic> toJson() => {
        "cursors": cursors.toJson(),
        "next": next,
    };
}

class Cursors {
    String after;

    Cursors({
        required this.after,
    });

    factory Cursors.fromJson(Map<String, dynamic> json) => Cursors(
        after: json["after"],
    );

    Map<String, dynamic> toJson() => {
        "after": after,
    };
}
