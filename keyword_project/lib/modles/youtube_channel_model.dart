// To parse this JSON data, do
//
//     final youtubeChannel = youtubeChannelFromJson(jsonString);

import "dart:convert";

YoutubeChannel youtubeChannelFromJson(String str) => YoutubeChannel.fromJson(json.decode(str));

String youtubeChannelToJson(YoutubeChannel data) => json.encode(data.toJson());

class YoutubeChannel {
    // String kind;
    // String etag;
    // PageInfo pageInfo;
    List<Item> items;

    YoutubeChannel({
        // required this.kind,
        // required this.etag,
        // required this.pageInfo,
        required this.items,
    });

    factory YoutubeChannel.fromJson(Map<String, dynamic> json) => YoutubeChannel(
        // kind: json["kind"],
        // etag: json["etag"],
        // pageInfo: PageInfo.fromJson(json["pageInfo"]),
        items: json.containsKey("items")?List<Item>.from(json["items"].map((x) => Item.fromJson(x))):[],
    );

    Map<String, dynamic> toJson() => {
        // "kind": kind,
        // "etag": etag,
        // "pageInfo": pageInfo.toJson(),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
    };
}

class Item {
    // String kind;
    // String etag;
    // String id;
    Snippet snippet;
    Statistics statistics;

    Item({
        // required this.kind,
        // required this.etag,
        // required this.id,
        required this.snippet,
        required this.statistics,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        // kind: json["kind"],
        // etag: json["etag"],
        // id: json["id"],
        snippet: json.containsKey("snippet")?Snippet.fromJson(json["snippet"]):Snippet(title: "", description: "", customUrl: ""),
        statistics: json.containsKey("statistics")?Statistics.fromJson(json["statistics"]):Statistics(viewCount: "0", subscriberCount: "0"),
    );

    Map<String, dynamic> toJson() => {
        // "kind": kind,
        // "etag": etag,
        // "id": id,
        "snippet": snippet.toJson(),
        "statistics": statistics.toJson(),
    };
}

class Snippet {
    String title;
    String description;
    String customUrl;
    // DateTime publishedAt;
    // Thumbnails thumbnails;
    // String defaultLanguage;
    // Localized localized;
    // String country;

    Snippet({
        required this.title,
        required this.description,
        required this.customUrl,
        // required this.publishedAt,
        // required this.thumbnails,
        // required this.defaultLanguage,
        // required this.localized,
        // required this.country,
    });

    factory Snippet.fromJson(Map<String, dynamic> json) => Snippet(
        title: json.containsKey("title")?json["title"]:"",
        description: json.containsKey("description")?json["description"]:"",
        customUrl: json.containsKey("customUrl")?json["customUrl"]:"",
        // publishedAt: DateTime.parse(json["publishedAt"]),
        // thumbnails: Thumbnails.fromJson(json["thumbnails"]),
        // defaultLanguage: json["defaultLanguage"],
        // localized: Localized.fromJson(json["localized"]),
        // country: json["country"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "customUrl": customUrl,
        // "publishedAt": publishedAt.toIso8601String(),
        // "thumbnails": thumbnails.toJson(),
        // "defaultLanguage": defaultLanguage,
        // "localized": localized.toJson(),
        // "country": country,
    };
}


class Statistics {
    String viewCount;
    String subscriberCount;
    // bool hiddenSubscriberCount;
    // String videoCount;

    Statistics({
        required this.viewCount,
        required this.subscriberCount,
        // required this.hiddenSubscriberCount,
        // required this.videoCount,
    });

    factory Statistics.fromJson(Map<String, dynamic> json) => Statistics(
        viewCount: json.containsKey("viewCount")?json["viewCount"]:"0",
        subscriberCount: json.containsKey("subscriberCount")?json["subscriberCount"]:"0",
        // hiddenSubscriberCount: json.containsKey("hiddenSubscriberCount")?json["hiddenSubscriberCount"],
        // videoCount: json.containsKey("videoCount")?json["videoCount"],
    );

    Map<String, dynamic> toJson() => {
        "viewCount": viewCount,
        "subscriberCount": subscriberCount,
        // "hiddenSubscriberCount": hiddenSubscriberCount,
        // "videoCount": videoCount,
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
//         totalResults: json.containsKey("")?json["totalResults"]:0,
//         resultsPerPage: json.containsKey("resultsPerPage")?json["resultsPerPage"]:0,
//     );

//     Map<String, dynamic> toJson() => {
//         "totalResults": totalResults,
//         "resultsPerPage": resultsPerPage,
//     };
// }

// class Localized {
//     String title;
//     String description;

//     Localized({
//         required this.title,
//         required this.description,
//     });

//     factory Localized.fromJson(Map<String, dynamic> json) => Localized(
//         title: json.containsKey("")?json["title"],
//         description: json.containsKey("")?json["description"],
//     );

//     Map<String, dynamic> toJson() => {
//         "title": title,
//         "description": description,
//     };
// }

// class Thumbnails {
//     Default thumbnailsDefault;
//     Default medium;
//     Default high;

//     Thumbnails({
//         required this.thumbnailsDefault,
//         required this.medium,
//         required this.high,
//     });

//     factory Thumbnails.fromJson(Map<String, dynamic> json) => Thumbnails(
//         thumbnailsDefault: Default.fromJson(json.containsKey("")?json["default"]),
//         medium: Default.fromJson(json.containsKey("")?json["medium"]),
//         high: Default.fromJson(json.containsKey("")?json["high"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "default": thumbnailsDefault.toJson(),
//         "medium": medium.toJson(),
//         "high": high.toJson(),
//     };
// }

// class Default {
//     String url;
//     int width;
//     int height;

//     Default({
//         required this.url,
//         required this.width,
//         required this.height,
//     });

//     factory Default.fromJson(Map<String, dynamic> json) => Default(
//         url: json.containsKey("")?json["url"],
//         width: json.containsKey("")?json["width"],
//         height: json.containsKey("")?json["height"],
//     );

//     Map<String, dynamic> toJson() => {
//         "url": url,
//         "width": width,
//         "height": height,
//     };
// }

