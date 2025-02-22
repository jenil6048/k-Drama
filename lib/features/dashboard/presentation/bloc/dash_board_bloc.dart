import '../../../../export.dart';

class DashBoardBloc extends Bloc<DashBoardEvent, DashBoardState> {
  DashBoardBloc() : super(DashBoardInItState(selectedIndex: 0)) {
    on<DashBoardInItEvent>((event, emit) async {
      // var data = await FirestoreService().getAppVersion();
      // logV("short data=====>$data");
      // if (Singleton.instance.appVersion != Singleton.instance.latestVersion) {
      //   emit(ForceUpdateState(selectedIndex: 0));
      // } else {
      //   Singleton.instance.likeCount=data.likeRange;
      //   if (data.addShort) {
      //     // add(AddNewShortsEvent(data.count));
      //   }
        emit(DashBoardInItState(selectedIndex: 0));
      // }
    });
    on<DashBoardIndexChangeEvent>((event, emit) {
      emit(DashBoardIndexChangeState(selectedIndex: event.index));
    });
    // on<AddNewShortsEvent>((event, emit) async {
    //   int count= await Singleton.instance.getShortLastStoreCount();
    //   if(count != event.count){
    //
    //     List<ShortModel> loadedShortList = await DatabaseHelper.getAllShorts();
    //     List<ShortModel> shortList = await FirestoreService.getAllShorts();
    //     if (loadedShortList.isNotEmpty) {
    //       await DatabaseHelper.deleteFirstData(shortList.length);
    //     }
    //     logV("AddNewShortsEvent");
    //     await DatabaseHelper.insertShortsList(shortList);
    //     await Singleton.instance.setShortLastStoreCount(event.count);
    //   }
    // });
  }
}
