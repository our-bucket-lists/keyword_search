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
    List<Feed> results;
    int page;
    int perPage;
    int totalPage;
    int totalFeeds;

    Data({
        required this.results,
        required this.page,
        required this.perPage,
        required this.totalPage,
        required this.totalFeeds,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        results: List<Feed>.from(json["feeds"].map((x) => Feed.fromJson(x))),
        page: json["page"],
        perPage: json["per_page"],
        totalPage: json["total_page"],
        totalFeeds: json["total_feeds"],
    );

    Map<String, dynamic> toJson() => {
        "feeds": List<dynamic>.from(results.map((x) => x.toJson())),
        "page": page,
        "per_page": perPage,
        "total_page": totalPage,
        "total_feeds": totalFeeds,
    };
}

class Feed {
    String email;
    String ig;
    String memberUniqid;
    String displayName;
    String title;
    String link;
    int hit;
    DateTime createdAt;
    int replyCount;

    Feed({
        required this.email,
        required this.ig,
        required this.memberUniqid,
        required this.displayName,
        required this.title,
        required this.link,
        required this.hit,
        required this.createdAt,
        required this.replyCount,
    });

    factory Feed.fromJson(Map<String, dynamic> json) => Feed(
        email: '',
        ig: '',
        memberUniqid: json.containsKey("member_uniqid")?json["member_uniqid"]:"",
        displayName: json.containsKey("display_name")?json["display_name"]:"",
        title: json.containsKey("title")?json["title"]:"",
        link: json.containsKey("link")?json["link"]:"",
        hit: json.containsKey("hit")?json["hit"]:0,
        createdAt: json.containsKey("created_at")?DateTime.fromMillisecondsSinceEpoch(json["created_at"]*1000):DateTime.now(),
        replyCount: json.containsKey("reply_count")?json["reply_count"]:0,
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "member_uniqid": memberUniqid,
        "display_name": displayName,
        "title": title,
        "link": link,
        "hit": hit,
        "created_at": createdAt,
        "reply_count": replyCount,
    };
}
