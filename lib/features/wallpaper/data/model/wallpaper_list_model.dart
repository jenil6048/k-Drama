// // To parse this JSON data, do
// //
// //     final wallpaperList = wallpaperListFromJson(jsonString);
//
// import 'dart:convert';
//
// import 'package:k_drama/features/wallpaper/data/model/wallpaper_list_model_rp.dart';
//
// List<WallpaperList> wallpaperListFromJson(String str) => List<WallpaperList>.from(json.decode(str).map((x) => WallpaperList.fromJson(x)));
//
// String wallpaperListToJson(List<WallpaperList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// class WallpaperList {
//   Map<String, WallpaperData> wallpapers;
//   String type;
//   String membername;
//
//   WallpaperList({
//     required this.wallpapers,
//     required this.type,
//     required this.membername,
//   });
//
//   factory WallpaperList.fromJson(Map<String, dynamic> json) => WallpaperList(
//     wallpapers: Map.from(json["Wallpapers"]).map((k, v) => MapEntry<String, WallpaperData>(k, WallpaperData.fromJson(v))),
//     type: json["type"],
//     membername: json["membername"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "Wallpapers": Map.from(wallpapers).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
//     "type": type,
//     "membername": membername,
//   };
// }
//
// // class WallpaperData {
// //   String image;
// //   Premimum premimum;
// //   bool isFavorite;
// //
// //   WallpaperData({
// //     required this.image,
// //     required this.premimum,
// //     this.isFavorite=false
// //   });
// //
// //   factory WallpaperData.fromJson(Map<String, dynamic> json) => WallpaperData(
// //     image: json["image"],
// //     premimum: premimumValues.map[json["premimum"]]!,
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "image": image,
// //     "premimum": premimumValues.reverse[premimum],
// //   };
// // }
//
// enum Premimum {
//   FREE,
//   PRO
// }
//
// final premimumValues = EnumValues({
//   "Free": Premimum.FREE,
//   "Pro": Premimum.PRO
// });
//
// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }
