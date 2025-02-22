// To parse this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString);

import 'dart:convert';

import 'package:k_drama/features/home/data/model/home_response_model.dart';
import 'package:k_drama/features/shorts/data/model/short_model.dart';

HomeResponseModelRt dashboardModelFromJson(String str) => HomeResponseModelRt.fromJson(json.decode(str));

String dashboardModelToJson(HomeResponseModelRt data) => json.encode(data.toJson());

class HomeResponseModelRt {
  bool ads;
  bool inReview;
  SliderList sliderList;
  List<SingleMovieModel> movieList;
  Shorts shorts;
  String version;

  HomeResponseModelRt({
    required this.ads,
    required this.inReview,
    required this.sliderList,
    required this.movieList,
    required this.shorts,
    required this.version,
  });

  factory HomeResponseModelRt.fromJson(Map<String, dynamic> json) => HomeResponseModelRt(
    ads: json["ads"],
    inReview: json["in_review"],
    sliderList: SliderList.fromJson(json["slider_list"]),
    movieList: List<SingleMovieModel>.from(json["movie_list"].map((x) => SingleMovieModel.fromJson(x))),
    shorts:Shorts.fromJson(json["shorts"]),
    version: json["version"],
  );

  Map<String, dynamic> toJson() => {
    "ads": ads,
    "in_review": inReview,
    "slider_list": sliderList.toJson(),
    "movie_list": List<dynamic>.from(movieList.map((x) => x.toJson())),
    "shorts": shorts.toJson(),
    "version": version,
  };
}


class SliderList {
  List<SingleMovieModel> slider;
  List<ShortModel> shorts;

  SliderList({
    required this.slider,
    required this.shorts,
  });

  factory SliderList.fromJson(Map<String, dynamic> json) => SliderList(
    slider: List<SingleMovieModel>.from(json["slider"].map((x) => SingleMovieModel.fromJson(x))),
    shorts: List<ShortModel>.from(json["shorts"].map((x) => ShortModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "slider": List<dynamic>.from(slider.map((x) => x.toJson())),
    "shorts": List<dynamic>.from(shorts.map((x) => x.toJson())),
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

