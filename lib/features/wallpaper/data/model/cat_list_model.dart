// To parse this JSON data, do
//
//     final wallPaperCategoryList = wallPaperCategoryListFromJson(jsonString);

import 'dart:convert';

List<WallPaperCategoryList> wallPaperCategoryListFromJson(String str) => List<WallPaperCategoryList>.from(json.decode(str).map((x) => WallPaperCategoryList.fromJson(x)));

String wallPaperCategoryListToJson(List<WallPaperCategoryList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WallPaperCategoryList {
  String catName;

  WallPaperCategoryList({
    required this.catName,
  });

  factory WallPaperCategoryList.fromJson(Map<String, dynamic> json) => WallPaperCategoryList(
    catName: json["cat_name"],
  );

  Map<String, dynamic> toJson() => {
    "cat_name": catName,
  };
}
