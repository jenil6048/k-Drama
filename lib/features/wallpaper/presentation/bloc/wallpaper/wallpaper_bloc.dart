import 'package:k_drama/export.dart';

class WallpaperBloc extends Bloc<WallpaperEvent, WallpaperState> {

  WallpaperBloc() : super(WallpaperInitialState()) {
    on<WallpaperLoadEvent>(_init);

    on<WallpaperSuccessEvent>(_successEvent);
  }

  EventHandler<WallpaperSuccessEvent, WallpaperState> get _successEvent =>
      (event, emit) async {
        emit(WallpaperLoadedState(
          category: event.category ?? state.category,
          wallPaperList: event.wallPaperList ?? state.wallPaperList,
        ));
      };


  EventHandler<WallpaperLoadEvent, WallpaperState> get _init =>
      (event, emit) async {
        try {
          if (Singleton.instance.catList == null) {
            List<WallpaperListRt> wallpaperList = await _catList();
            List<String> categoryList=wallpaperList.map((e) => e.name).toList();
            Singleton.instance.wallpaperListRt = wallpaperList;
            Singleton.instance.catList=categoryList;
            _checkIsFavorite(wallpaperList);
            add(WallpaperSuccessEvent(
              wallPaperList: wallpaperList,
              category: categoryList,
            ));

          }
         else{
            add(WallpaperSuccessEvent(
              wallPaperList: Singleton.instance.wallpaperListRt,
              category: Singleton.instance.catList,
            ));
          }
        } catch (e) {
          showToast("Something went wrong");
          emit(WallpaperErrorState(""));
        }
      };


  ///get all category list
  Future<List<WallpaperListRt>> _catList() async {
    List<WallpaperListRt> catList = await WallPaperRepo.getAllWallpaper();
    return catList;
  }



  ///check in local data base is favorite or not
  _checkIsFavorite(List<WallpaperListRt> wallpaperList) async {
    List<String> favoriteList = await DatabaseHelper.getAllWallpapers();
    logV("favoriteList===>$favoriteList");

    if (wallpaperList.isNotEmpty && favoriteList.isNotEmpty) {
      for (WallpaperListRt data in wallpaperList) {
        for (Wallpapers element in data.images) {
          for (WallpaperData data2 in element.wallpapers.values) {
            if (favoriteList.contains(data2.image)) {
              data2.isFavorite = true;
            }
          }
        }
      }
    }
  }

}
