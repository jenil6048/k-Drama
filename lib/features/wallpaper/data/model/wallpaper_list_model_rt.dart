// To parse this JSON data, do
//
//     final WallpaperListRt = WallpaperListRtFromJson(jsonString);

import 'dart:convert';

List<WallpaperListRt> wallpaperListRtFromJson(String str) => List<WallpaperListRt>.from(json.decode(str).map((x) => WallpaperListRt.fromJson(x)));

String wallpaperListRtToJson(List<WallpaperListRt> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WallpaperListRt {
  List<Wallpapers> images;
  String name;

  WallpaperListRt({
    required this.images,
    required this.name,
  });

  factory WallpaperListRt.fromJson(Map<String, dynamic> json) => WallpaperListRt(
    images: List<Wallpapers>.from(json["images"].map((x) => Wallpapers.fromJson(x))),
    name:json["name"],
  );

  Map<String, dynamic> toJson() => {
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
    "name": name,
  };
}

class Wallpapers {
  Map<String, WallpaperData> wallpapers;
  String type;
  String membername;

  Wallpapers({
    required this.wallpapers,
    required this.type,
    required this.membername,
  });

  factory Wallpapers.fromJson(Map<String, dynamic> json) => Wallpapers(
    wallpapers: Map.from(json["Wallpapers"]).map((k, v) => MapEntry<String, WallpaperData>(k, WallpaperData.fromJson(v))),
    type:json["type"],
    membername: json["membername"],
  );

  Map<String, dynamic> toJson() => {
    "Wallpapers": Map.from(wallpapers).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "type":type,
    "membername": membername,
  };
}


class WallpaperData {
  String image;
  String premimum;
  bool isFavorite;

  WallpaperData({
    required this.image,
    required this.premimum,
    this.isFavorite=false
  });

  factory WallpaperData.fromJson(Map<String, dynamic> json) => WallpaperData(
    image: json["image"],
    premimum: json["premimum"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "premimum":premimum,
  };
}
