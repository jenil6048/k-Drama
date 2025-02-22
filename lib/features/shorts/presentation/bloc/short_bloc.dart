import 'dart:convert';
import '../../../../export.dart';

List<ShortModel> loadedShortList = [];

class ShortBloc extends Bloc<ShortEvent, ShortState> {
  ShortBloc() : super(ShortInitState()) {
    on<ShortInitEvent>((event, emit) async {
      emit(ShortInitState());
      try {
        // loadedShortList=shortModelFromJson(jsonEncode(shortsUrlList));
        loadedShortList = await DatabaseHelper.getAllShorts();
        logV("short from database====>$loadedShortList");
        if (loadedShortList.isEmpty) {
          loadedShortList = await HomeRepository.getAllShorts(FirebaseConstants.short);
          DatabaseHelper.insertShortsList(loadedShortList);
        }
        logV("newList===>${jsonEncode(loadedShortList)}");
        logV("newList length===>${loadedShortList.length}");
        emit(ShortSuccessState(shortList: loadedShortList));
      } catch (e) {
        emit(ShortErrorState());
      }
    });
  }
}
