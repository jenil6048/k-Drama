// To parse this JSON data, do
//
//     final allMoviesList = allMoviesListFromJson(jsonString);

import 'dart:convert';

import 'package:k_drama/features/home/data/model/home_response_model.dart';

List<AllMoviesList> allMoviesListFromJson(String str) => List<AllMoviesList>.from(json.decode(str).map((x) => AllMoviesList.fromJson(x)));

String allMoviesListToJson(List<AllMoviesList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllMoviesList {
  List<SingleMovieModel>? data;
  String? type;

  AllMoviesList({
    this.data,
    this.type,
  });

  factory AllMoviesList.fromJson(Map<String, dynamic> json) => AllMoviesList(
    data: json["data"] == null ? [] : List<SingleMovieModel>.from(json["data"]!.map((x) => SingleMovieModel.fromJson(x))),
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "type": type,
  };
}


