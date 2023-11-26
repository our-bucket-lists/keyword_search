// To parse this JSON data, do
//
//     final instagramSearch = instagramSearchFromJson(jsonString);

import 'dart:convert';

InstagramSearch instagramSearchFromJson(String str) =>
    InstagramSearch.fromJson(json.decode(str));

String instagramSearchToJson(InstagramSearch data) =>
    json.encode(data.toJson());

class InstagramSearch {
  int count;
  Data data;
  String status;

  InstagramSearch({
    required this.count,
    required this.data,
    required this.status,
  });

  factory InstagramSearch.fromJson(Map<String, dynamic> json) =>
      InstagramSearch(
        count: json["count"],
        data: Data.fromJson(json["data"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "data": data.toJson(),
        "status": status,
      };
}

class Data {
  int mediaCount;
  Top top;

  Data({
    required this.mediaCount,
    required this.top,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        mediaCount: json["media_count"],
        top: Top.fromJson(json["top"]),
      );

  Map<String, dynamic> toJson() => {
        "media_count": mediaCount,
        "top": top.toJson(),
      };
}

class Top {
  List<Section> sections;

  Top({
    this.sections = const [],
  });

  factory Top.fromJson(Map<String, dynamic> json) => Top(
        sections: List<Section>.from(
            json["sections"].map((x) => Section.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sections": List<dynamic>.from(sections.map((x) => x.toJson())),
      };
}

class Section {
  LayoutContent layoutContent;
  Section({
    required this.layoutContent,
  });

  factory Section.fromJson(Map<String, dynamic> json) => Section(
        layoutContent: LayoutContent.fromJson(json["layout_content"]),
      );

  Map<String, dynamic> toJson() => {
        "layout_content": layoutContent.toJson(),
      };
}

class LayoutContent {
  OneByTwoItem? oneByTwoItem;
  List<MediaElement> fillItems;
  List<MediaElement> medias;

  LayoutContent({
    this.oneByTwoItem,
    this.fillItems = const [],
    this.medias = const [],
  });

  factory LayoutContent.fromJson(Map<String, dynamic> json) => LayoutContent(
        oneByTwoItem: json["one_by_two_item"] == null
            ? null
            : OneByTwoItem.fromJson(json["one_by_two_item"]),
        fillItems: json["fill_items"] == null
            ? []
            : List<MediaElement>.from(
                json["fill_items"]!.map((x) => MediaElement.fromJson(x))),
        medias: json["medias"] == null
            ? []
            : List<MediaElement>.from(
                json["medias"]!.map((x) => MediaElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "one_by_two_item": oneByTwoItem?.toJson(),
        "fill_items": List<dynamic>.from(fillItems.map((x) => x.toJson())),
        "medias": List<dynamic>.from(medias.map((x) => x.toJson())),
      };
}

class MediaElement {
  Media media;

  MediaElement({
    required this.media,
  });

  factory MediaElement.fromJson(Map<String, dynamic> json) => MediaElement(
        media: Media.fromJson(json["media"]),
      );

  Map<String, dynamic> toJson() => {
        "media": media.toJson(),
      };
}

class Media {
  Caption caption;
  String code;
  int likeCount;
  int commentCount;

  Media({
    required this.caption,
    required this.code,
    required this.likeCount,
    required this.commentCount,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        caption: Caption.fromJson(json["caption"]),
        code: json["code"],
        likeCount: json["like_count"],
        commentCount: json["comment_count"],
      );

  Map<String, dynamic> toJson() => {
        "caption": caption.toJson(),
        "code": code,
        "like_count": likeCount,
        "comment_count": commentCount,
      };
}

class Caption {
  User user;
  DateTime createdAtUtc;
  String text;

  Caption({
    required this.user,
    required this.text,
    required this.createdAtUtc,
  });

  factory Caption.fromJson(Map<String, dynamic> json) => Caption(
        user: User.fromJson(json["user"]),
        text: json["text"],
        createdAtUtc:
            DateTime.fromMillisecondsSinceEpoch(json["created_at_utc"] * 1000),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "text": text,
        "created_at_utc": createdAtUtc,
      };
}

class User {
  String fullName;
  String username;

  User({
    required this.fullName,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        fullName: json["full_name"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "username": username,
      };
}

class OneByTwoItem {
  Clips clips;

  OneByTwoItem({
    required this.clips,
  });

  factory OneByTwoItem.fromJson(Map<String, dynamic> json) => OneByTwoItem(
        clips: Clips.fromJson(json["clips"]),
      );

  Map<String, dynamic> toJson() => {
        "clips": clips.toJson(),
      };
}

class Clips {
  List<MediaElement> items;
  Clips({
    this.items = const [],
  });

  factory Clips.fromJson(Map<String, dynamic> json) => Clips(
        items: List<MediaElement>.from(
            json["items"].map((x) => MediaElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}
