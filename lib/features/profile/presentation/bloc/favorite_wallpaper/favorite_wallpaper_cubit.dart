import '../../../../../export.dart';

class FavoriteWallpaperCubit extends Cubit<FavoriteWallpaperState> {
  FavoriteWallpaperCubit() : super(FavoriteWallpaperInitState());

  Future<void> getFavoriteWallPaper() async {
    List<String> favoriteList = await DatabaseHelper.getAllWallpapers();
    emit(FavoriteWallpaperSuccessState(wallPaperList: favoriteList));
  }

  removeFromFavorite(List<String> favoriteList){
    emit(FavoriteWallpaperSuccessState(wallPaperList: favoriteList));
  }
}
