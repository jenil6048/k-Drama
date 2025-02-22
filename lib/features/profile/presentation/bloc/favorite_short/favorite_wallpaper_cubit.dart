import 'dart:convert';
import '../../../../../export.dart';

class FavoriteShortsCubit extends Cubit<FavoriteShortsState> {
  FavoriteShortsCubit() : super(FavoriteShortsInitState());

  Future<void> getFavoriteShorts() async {
    List<ShortModel> shortList = await DatabaseHelper.getAllFavoriteShorts();
    logV("shortList===>${jsonEncode(shortList)}");
    emit(FavoriteShortsSuccessState(wallPaperList: shortList));
  }

  removeFromFavorite(int id){
    state.shortList?.removeWhere((element) => element.id==id);
    emit(FavoriteShortsSuccessState(wallPaperList:state.shortList ));
  }
}
