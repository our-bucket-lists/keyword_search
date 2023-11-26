// To parse this JSON data, do
//
//     final pixnetSearch = pixnetSearchFromJson(jsonString);

import 'dart:convert';

PixnetSearch pixnetSearchFromJson(String str) => PixnetSearch.fromJson(json.decode(str));

String pixnetSearchToJson(PixnetSearch data) => json.encode(data.toJson());

class PixnetSearch {
    bool error;
    Data data;

    PixnetSearch({
        required this.error,
        required this.data,
    });

    factory PixnetSearch.fromJson(Map<String, dynamic> json) => PixnetSearch(
        error: json["error"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "data": data.toJson(),
    };
}

class Data {
    // List<dynamic> headlines;
    List<Feed> results;
    // String feedsType;
    // String apiVersion;
    int page;
    int perPage;
    int totalPage;
    int totalFeeds;
    // String time;

    Data({
        // required this.headlines,
        required this.results,
        // required this.resultsType,
        // required this.apiVersion,
        required this.page,
        required this.perPage,
        required this.totalPage,
        required this.totalFeeds,
        // required this.time,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        // headlines: List<dynamic>.from(json["headlines"].map((x) => x)),
        results: List<Feed>.from(json["feeds"].map((x) => Feed.fromJson(x))),
        // feedsType: json["feeds_type"],
        // apiVersion: json["api_version"],
        page: json["page"],
        perPage: json["per_page"],
        totalPage: json["total_page"],
        totalFeeds: json["total_feeds"],
        // time: json["time"],
    );

    Map<String, dynamic> toJson() => {
        // "headlines": List<dynamic>.from(headlines.map((x) => x)),
        "feeds": List<dynamic>.from(results.map((x) => x.toJson())),
        // "feeds_type": feedsType,
        // "api_version": apiVersion,
        "page": page,
        "per_page": perPage,
        "total_page": totalPage,
        "total_feeds": totalFeeds,
        // "time": time,
    };
}

class Feed {
    String email;
    // String type;
    String memberUniqid;
    String displayName;
    // String avatar;
    // int avatarRole;
    // String avatarRoleUrl;
    String title;
    // String description;
    String link;
    int hit;
    DateTime createdAt;
    // List<String> imagesUrl;
    // bool canComment;
    int replyCount;
    // List<String> tags;
    // Poi video;
    // Poi poi;
    // bool isAdult;

    Feed({
        required this.email,
        // required this.type,
        required this.memberUniqid,
        required this.displayName,
        // required this.avatar,
        // required this.avatarRole,
        // required this.avatarRoleUrl,
        required this.title,
        // required this.description,
        required this.link,
        required this.hit,
        required this.createdAt,
        // required this.imagesUrl,
        // required this.canComment,
        required this.replyCount,
        // required this.tags,
        // required this.video,
        // required this.poi,
        // required this.isAdult,
    });

    factory Feed.fromJson(Map<String, dynamic> json) => Feed(
        email: 'mock@email.com',
        // type: json["type"],
        memberUniqid: json["member_uniqid"],
        displayName: json["display_name"],
        // avatar: json["avatar"],
        // avatarRole: json["avatar_role"],
        // avatarRoleUrl: json["avatar_role_url"],
        title: json["title"],
        // description: json["description"],
        link: json["link"],
        hit: json["hit"],
        createdAt: DateTime.fromMillisecondsSinceEpoch(json["created_at"]*1000),
        // imagesUrl: List<String>.from(json["images_url"].map((x) => x)),
        // canComment: json["can_comment"],
        replyCount: json["reply_count"],
        // tags: List<String>.from(json["tags"].map((x) => x)),
        // video: Poi.fromJson(json["video"]),
        // poi: Poi.fromJson(json["poi"]),
        // isAdult: json["is_adult"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        // "type": type,
        "member_uniqid": memberUniqid,
        "display_name": displayName,
        // "avatar": avatar,
        // "avatar_role": avatarRole,
        // "avatar_role_url": avatarRoleUrl,
        "title": title,
        // "description": description,
        "link": link,
        "hit": hit,
        "created_at": createdAt,
        // "images_url": List<dynamic>.from(imagesUrl.map((x) => x)),
        // "can_comment": canComment,
        "reply_count": replyCount,
        // "tags": List<dynamic>.from(tags.map((x) => x)),
        // "video": video.toJson(),
        // "poi": poi.toJson(),
        // "is_adult": isAdult,
    };
}

class Poi {
    Poi();

    factory Poi.fromJson(Map<String, dynamic> json) => Poi(
    );

    Map<String, dynamic> toJson() => {
    };
}
