// To parse this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString);

import 'dart:convert';

List<DashboardModel> dashboardModelFromJson(String str) => List<DashboardModel>.from(json.decode(str).map((x) => DashboardModel.fromJson(x)));

String dashboardModelToJson(List<DashboardModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DashboardModel {
  bool ads;
  Shorts shorts;
  Version version;

  DashboardModel({
    required this.ads,
    required this.shorts,
    required this.version,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
    ads: json["ads"],
    shorts: Shorts.fromJson(json["shorts"]),
    version: Version.fromJson(json["version"]),
  );

  Map<String, dynamic> toJson() => {
    "ads": ads,
    "shorts": shorts.toJson(),
    "version": version.toJson(),
  };
}

class Shorts {
  int likeRange;
  int count;
  bool addShort;

  Shorts({
    required this.likeRange,
    required this.count,
    required this.addShort,
  });

  factory Shorts.fromJson(Map<String, dynamic> json) => Shorts(
    likeRange: json["like_range"],
    count: json["count"],
    addShort: json["add_short"],
  );

  Map<String, dynamic> toJson() => {
    "like_range": likeRange,
    "count": count,
    "add_short": addShort,
  };
}

class Version {
  String version;

  Version({
    required this.version,
  });

  factory Version.fromJson(Map<String, dynamic> json) => Version(
    version: json["version"],
  );

  Map<String, dynamic> toJson() => {
    "version": version,
  };
}
