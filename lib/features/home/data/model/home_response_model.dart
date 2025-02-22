// To parse this JSON data, do
//
//     final homeResponseModel = homeResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:k_drama/core/constants/constants.dart';
import 'package:k_drama/features/shorts/data/model/short_model.dart';

List<HomeResponseModel> homeResponseModelFromJson(String str) => List<HomeResponseModel>.from(json.decode(str).map((x) => HomeResponseModel.fromJson(x)));

String homeResponseModelToJson(List<HomeResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HomeResponseModel {
  List<SingleMovieModel>? movieList;
  List<SingleMovieModel>? slider;
  List<ShortModel>? shorts;

  HomeResponseModel({
    this.movieList,
    this.slider,
    this.shorts,
  });

  factory HomeResponseModel.fromJson(Map<String, dynamic> json) => HomeResponseModel(
    movieList: json["movie_list"] == null ? [] : List<SingleMovieModel>.from(json["movie_list"]!.map((x) => SingleMovieModel.fromJson(x))),
    slider: json["slider"] == null ? [] : List<SingleMovieModel>.from(json["slider"]!.map((x) => SingleMovieModel.fromJson(x))),
    shorts: json["shorts"] == null ? [] : List<ShortModel>.from(json["shorts"]!.map((x) => ShortModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "movie_list": movieList == null ? [] : List<dynamic>.from(movieList!.map((x) => x.toJson())),
    "slider": slider == null ? [] : List<dynamic>.from(slider!.map((x) => x.toJson())),
    "shorts": shorts == null ? [] : List<dynamic>.from(shorts!.map((x) => x.toJson())),
  };
}

  class SingleMovieModel {
    String imdb;
    List<String> genres;
    String rating;
    String downloadUrl;
    String posterUrl;
    String description;
    String movieName;
    String type;
    String steamUrl;
    String trailerUrl;
    String poster2;
    bool inWatchList;

    SingleMovieModel({
      required this.imdb,
      required this.genres,
      required this.rating,
      required this.downloadUrl,
      required this.posterUrl,
      required this.description,
      required this.movieName,
      required this.type,
      required this.steamUrl,
      required this.trailerUrl,
       this.poster2="",
      this.inWatchList=false
    });

    factory SingleMovieModel.fromJson(Map<String, dynamic> json) {
     return  SingleMovieModel(
        imdb: json["imdb"],
        genres:json["genres"].runtimeType ==String? List<String>.from(jsonDecode(json["genres"]).map((x) => x)):List<String>.from(json["genres"].map((x) => x)),
        rating: json["rating"],
        downloadUrl: json["download_url"],
        posterUrl: json["poster_url"],
        description: json["description"],
        movieName: json["movie_name"],
        type: json["type"],
        steamUrl: json["steam_url"],
        trailerUrl: json["trailer_url"],
        poster2: json["poster_2"] ?? "",
      );
    }

    Map<String, dynamic> toJson() => {
      "imdb": imdb,
      "genres": jsonEncode(genres),
      "rating": rating,
      "download_url": downloadUrl,
      "poster_url": posterUrl,
      "description": description,
      "movie_name": movieName,
      "type": type,
      "steam_url": steamUrl,
      "trailer_url": trailerUrl,
      "poster_2": poster2,
    };
  }



