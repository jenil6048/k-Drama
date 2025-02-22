import 'package:k_drama/features/wallpaper/data/model/wallpaper_list_model_rt.dart';

import '../../../../../export.dart';

abstract class WallpaperEvent {}

class WallpaperLoadEvent extends WallpaperEvent {}
class WallpaperTabChangeEvent extends WallpaperEvent {}

class WallpaperSuccessEvent extends WallpaperEvent {
  List<String>? category;
  List<WallpaperListRt>? wallPaperList;
  WallpaperSuccessEvent({this.category,this.wallPaperList});
}


