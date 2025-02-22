// To parse this JSON data, do
//
//     final shortModel = shortModelFromJson(jsonString);

import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import '../../../../core/singleton/singleton.dart';

List<ShortModel> shortModelFromJson(String str) => List<ShortModel>.from(json.decode(str).map((x) => ShortModel.fromJson(x)));

String shortModelToJson(List<ShortModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShortModel {
  int id;
  String videoName;
  String videoThumb;
  String videoUrl;
  bool isLiked;
  late int totalLike;

  ShortModel({
    required this.id,
    required this.videoName,
    required this.videoThumb,
    required this.videoUrl,
    this.isLiked = false,
  }) {
    totalLike = Singleton.instance.likeCount > 1
        ? Random().nextInt(Singleton.instance.likeCount - 1) + 1
        : 1;
  }


  factory ShortModel.fromJson(Map<String, dynamic> json) => ShortModel(
    id: json["id"],
    videoName: json["video_name"],
    videoThumb: json["video_thumb"],
    videoUrl: json["video_url"],
    isLiked:json["isLiked"]!=null?json["isLiked"]==1?true:false:false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "video_name": videoName,
    "video_thumb": videoThumb,
    "video_url": videoUrl,
    "isLiked": isLiked ? 1 : 0,
  };
}
