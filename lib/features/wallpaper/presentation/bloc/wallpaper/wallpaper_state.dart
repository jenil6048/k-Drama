

import '../../../../../export.dart';

abstract class WallpaperState {
  List<String>? category;
  List<WallpaperListRt>? wallPaperList;

  WallpaperState({this.category, this.wallPaperList});
}

class WallpaperInitialState extends WallpaperState {}

class WallpaperLoadingState extends WallpaperState {
  WallpaperLoadingState(
      {  List<String>? category,
        List<WallpaperListRt>? wallPaperList})
      : super(
    category: category,
    wallPaperList: wallPaperList,
  );
}

class WallpaperLoadedState extends WallpaperState {
  WallpaperLoadedState(
      {  List<String>? category,
      List<WallpaperListRt>? wallPaperList})
      : super(
          category: category,
          wallPaperList: wallPaperList,
        );
}

class WallpaperErrorState extends WallpaperState {
  final String error;

  WallpaperErrorState(this.error);
}
