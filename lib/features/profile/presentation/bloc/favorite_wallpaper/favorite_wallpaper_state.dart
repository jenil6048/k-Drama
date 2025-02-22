
abstract class FavoriteWallpaperState {
  List<String>? wallPaperList;
  FavoriteWallpaperState({this.wallPaperList});
}

class FavoriteWallpaperInitState extends FavoriteWallpaperState {}
class FavoriteWallpaperSuccessState extends FavoriteWallpaperState {

  FavoriteWallpaperSuccessState({ List<String>? wallPaperList}):super(wallPaperList: wallPaperList);
}
