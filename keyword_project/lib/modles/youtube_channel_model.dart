// To parse this JSON data, do
//
//     final youtubeChannel = youtubeChannelFromJson(jsonString);

import "dart:convert";

YoutubeChannel youtubeChannelFromJson(String str) => YoutubeChannel.fromJson(json.decode(str));

String youtubeChannelToJson(YoutubeChannel data) => json.encode(data.toJson());

class YoutubeChannel {
    List<Item> items;

    YoutubeChannel({
        required this.items,
    });

    factory YoutubeChannel.fromJson(Map<String, dynamic> json) => YoutubeChannel(
        items: json.containsKey("items")?List<Item>.from(json["items"].map((x) => Item.fromJson(x))):[],
    );

    Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
    };
}

class Item {
    Snippet snippet;
    Statistics statistics;

    Item({
        required this.snippet,
        required this.statistics,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        snippet: json.containsKey("snippet")?Snippet.fromJson(json["snippet"]):Snippet(title: "", description: "", customUrl: ""),
        statistics: json.containsKey("statistics")?Statistics.fromJson(json["statistics"]):Statistics(viewCount: "0", subscriberCount: "0"),
    );

    Map<String, dynamic> toJson() => {
        "snippet": snippet.toJson(),
        "statistics": statistics.toJson(),
    };
}

class Snippet {
    String title;
    String description;
    String customUrl;

    Snippet({
        required this.title,
        required this.description,
        required this.customUrl,
    });

    factory Snippet.fromJson(Map<String, dynamic> json) => Snippet(
        title: json.containsKey("title")?json["title"]:"",
        description: json.containsKey("description")?json["description"]:"",
        customUrl: json.containsKey("customUrl")?json["customUrl"]:"",
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "customUrl": customUrl,
    };
}


class Statistics {
    String viewCount;
    String subscriberCount;

    Statistics({
        required this.viewCount,
        required this.subscriberCount,
    });

    factory Statistics.fromJson(Map<String, dynamic> json) => Statistics(
        viewCount: json.containsKey("viewCount")?json["viewCount"]:"0",
        subscriberCount: json.containsKey("subscriberCount")?json["subscriberCount"]:"0",
    );

    Map<String, dynamic> toJson() => {
        "viewCount": viewCount,
        "subscriberCount": subscriberCount,
    };
}
