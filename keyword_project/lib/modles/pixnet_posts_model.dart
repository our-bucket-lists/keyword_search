// To parse this JSON data, do
//
//     final pixnetSearch = pixnetSearchFromJson(jsonString);

import 'dart:convert';

PixnetSearch pixnetSearchFromJson(String str) => PixnetSearch.fromJson(json.decode(str));

String pixnetSearchToJson(PixnetSearch data) => json.encode(data.toJson());

class PixnetSearch {
    List<Article> articles;
    int? total;
    int? perPage;
    int? page;
    String? message;
    int? error;
    int? apiVersion;

    PixnetSearch({
        required this.articles,
        this.total,
        this.perPage,
        this.page,
        this.message,
        this.error,
        this.apiVersion,
    });

    factory PixnetSearch.fromJson(Map<String, dynamic> json) => PixnetSearch(
        articles: List<Article>.from(json["articles"].map((x) => Article.fromJson(x))),
        total: json["total"],
        perPage: json["per_page"],
        page: json["page"],
        message: json["message"],
        error: json["error"],
        apiVersion: json["api_version"],
    );

    Map<String, dynamic> toJson() => {
        "articles": List<dynamic>.from(articles!.map((x) => x.toJson())),
        "total": total,
        "per_page": perPage,
        "page": page,
        "message": message,
        "error": error,
        "api_version": apiVersion,
    };
}

class Article {
    String id;
    User user;
    DateTime publicAt;
    String title;
    String link;
    Info info;
    Hits hits;
    String? lastModified;
    String? siteCategory;
    String? siteCategoryId;
    SubSiteCategory? subSiteCategory;
    String? subSiteCategoryId;
    Category? category;
    String? categoryId;
    String? status;
    String? isTop;
    String? isNl2Br;
    String? commentPerm;
    String? commentHidden;
    String? thumb;
    String? cover;
    String? hitUri;
    Sns? sns;
    List<Tag>? tags;
    String? tagsString;
    dynamic firstPublishedAt;

    Article({
        required this.id,
        required this.user,
        required this.publicAt,
        required this.title,
        required this.link,
        required this.info,
        required this.hits,
        this.lastModified,
        this.siteCategory,
        this.siteCategoryId,
        this.subSiteCategory,
        this.subSiteCategoryId,
        this.category,
        this.categoryId,
        this.status,
        this.isTop,
        this.isNl2Br,
        this.commentPerm,
        this.commentHidden,
        this.thumb,
        this.cover,
        this.hitUri,
        this.sns,
        this.tags,
        this.tagsString,
        this.firstPublishedAt,
    });

    factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json["id"],
        publicAt: DateTime.fromMillisecondsSinceEpoch(int.parse(json["public_at"]) * 1000),
        lastModified: json["last_modified"],
        siteCategory: json["site_category"],
        siteCategoryId: json["site_category_id"],
        subSiteCategory: subSiteCategoryValues.map[json["sub_site_category"]],
        subSiteCategoryId: json["sub_site_category_id"],
        category: categoryValues.map[json["category"]],
        categoryId: json["category_id"],
        link: json["link"],
        status: json["status"],
        isTop: json["is_top"],
        isNl2Br: json["is_nl2br"],
        commentPerm: json["comment_perm"],
        commentHidden: json["comment_hidden"],
        title: json["title"],
        thumb: json["thumb"],
        cover: json["cover"],
        hits: Hits.fromJson(json["hits"]),
        info: Info.fromJson(json["info"]),
        hitUri: json["hit_uri"],
        sns: Sns.fromJson(json["sns"]),
        tags: List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
        tagsString: json["tags_string"],
        user: User.fromJson(json["user"]),
        firstPublishedAt: json["first_published_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "public_at": publicAt,
        "last_modified": lastModified,
        "site_category": siteCategory,
        "site_category_id": siteCategoryId,
        "sub_site_category": subSiteCategoryValues.reverse[subSiteCategory],
        "sub_site_category_id": subSiteCategoryId,
        "category": categoryValues.reverse[category],
        "category_id": categoryId,
        "link": link,
        "status": status,
        "is_top": isTop,
        "is_nl2br": isNl2Br,
        "comment_perm": commentPerm,
        "comment_hidden": commentHidden,
        "title": title,
        "thumb": thumb,
        "cover": cover,
        "hits": hits.toJson(),
        "info": info.toJson(),
        "hit_uri": hitUri,
        "sns": sns?.toJson(),
        "tags": List<dynamic>.from(tags!.map((x) => x.toJson())),
        "tags_string": tagsString,
        "user": user.toJson(),
        "first_published_at": firstPublishedAt,
    };
}

enum Category {
    CATEGORY,
    EMPTY,
    FLUFFY,
    PURPLE
}

final categoryValues = EnumValues({
    "除濕機@常見問題及解答": Category.CATEGORY,
    "未分類": Category.EMPTY,
    "除濕機": Category.FLUFFY,
    "乖乖~": Category.PURPLE
});

class Hits {
    int total;
    int daily;

    Hits({
        required this.total,
        required this.daily,
    });

    factory Hits.fromJson(Map<String, dynamic> json) => Hits(
        total: json["total"],
        daily: json["daily"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "daily": daily,
    };
}

class Info {
    int? trackbacksCount;
    int? commentsCount;
    int? sharedsCount;
    int? hit;

    Info({
        this.trackbacksCount,
        this.commentsCount,
        this.sharedsCount,
        this.hit,
    });

    factory Info.fromJson(Map<String, dynamic> json) => Info(
        trackbacksCount: json["trackbacks_count"],
        commentsCount: json["comments_count"],
        sharedsCount: json["shareds_count"],
        hit: json["hit"],
    );

    Map<String, dynamic> toJson() => {
        "trackbacks_count": trackbacksCount,
        "comments_count": commentsCount,
        "shareds_count": sharedsCount,
        "hit": hit,
    };
}

class Sns {
    dynamic twitter;
    dynamic facebook;
    dynamic plurk;

    Sns({
        this.twitter,
        this.facebook,
        this.plurk,
    });

    factory Sns.fromJson(Map<String, dynamic> json) => Sns(
        twitter: json["twitter"],
        facebook: json["facebook"],
        plurk: json["plurk"],
    );

    Map<String, dynamic> toJson() => {
        "twitter": twitter,
        "facebook": facebook,
        "plurk": plurk,
    };
}

enum SubSiteCategory {
    EMPTY
}

final subSiteCategoryValues = EnumValues({
    "未選擇": SubSiteCategory.EMPTY
});

class Tag {
    String tag;
    int locked;
    String addedBy;
    bool isPoi;

    Tag({
        required this.tag,
        required this.locked,
        required this.addedBy,
        required this.isPoi,
    });

    factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        tag: json["tag"],
        locked: json["locked"],
        addedBy: json["added_by"],
        isPoi: json["is_poi"],
    );

    Map<String, dynamic> toJson() => {
        "tag": tag,
        "locked": locked,
        "added_by": addedBy,
        "is_poi": isPoi,
    };
}

class User {
    String name;
    String displayName;
    String avatar;
    String cavatar;
    String link;
    String memberUniqid;
    bool isVip;
    bool hasAd;
    int avatarRoleId;
    String avatarRoleUrl;

    User({
        required this.name,
        required this.displayName,
        required this.avatar,
        required this.cavatar,
        required this.link,
        required this.memberUniqid,
        required this.isVip,
        required this.hasAd,
        required this.avatarRoleId,
        required this.avatarRoleUrl,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        displayName: json["display_name"],
        avatar: json["avatar"],
        cavatar: json["cavatar"],
        link: json["link"],
        memberUniqid: json["member_uniqid"],
        isVip: json["is_vip"],
        hasAd: json["has_ad"],
        avatarRoleId: json["avatar_role_id"],
        avatarRoleUrl: json["avatar_role_url"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "display_name": displayName,
        "avatar": avatar,
        "cavatar": cavatar,
        "link": link,
        "member_uniqid": memberUniqid,
        "is_vip": isVip,
        "has_ad": hasAd,
        "avatar_role_id": avatarRoleId,
        "avatar_role_url": avatarRoleUrl,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
