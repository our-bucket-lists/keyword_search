// To parse this JSON data, do
//
//     final igHashtagSearch = igHashtagSearchFromJson(jsonString);

import 'dart:convert';

IgHashtagSearch igHashtagSearchFromJson(String str) => IgHashtagSearch.fromJson(json.decode(str));

String igHashtagSearchToJson(IgHashtagSearch data) => json.encode(data.toJson());

class IgHashtagSearch {
    List<Datum> data;

    IgHashtagSearch({
        required this.data,
    });

    factory IgHashtagSearch.fromJson(Map<String, dynamic> json) => IgHashtagSearch(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String id;

    Datum({
        required this.id,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json.containsKey("id")?json["id"]:"",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
    };
}
