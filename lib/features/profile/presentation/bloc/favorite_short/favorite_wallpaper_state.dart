
import 'package:k_drama/features/shorts/data/model/short_model.dart';

abstract class FavoriteShortsState {
  List<ShortModel>? shortList;
  FavoriteShortsState({this.shortList});
}

class FavoriteShortsInitState extends FavoriteShortsState {}
class FavoriteShortsSuccessState extends FavoriteShortsState {

  FavoriteShortsSuccessState({ List<ShortModel>? wallPaperList}):super(shortList: wallPaperList);
}
