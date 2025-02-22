import 'package:k_drama/features/home/data/model/home_model_rt.dart';
import '../../../../../export.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitState()) {
    on<HomeInitEvent>(_init);
    on<AddNewShortsEvent>(_addShotsInDb);
  }

  EventHandler<HomeInitEvent, HomeState> get _init => (event, emit) async {
        logV("home state");
        try {
          emit(HomeInitState());
          bool interNetConnection = await isConnectionAvailable();
          if (!interNetConnection) {
            emit(HomeErrorState(
                error: "Please check your internet connection."));
          } else {
            HomeResponseModelRt homeResponseModel =
                Singleton.instance.homeResponseModel ??
                    await HomeRepository.getHomeData();

              if ((double.tryParse(Singleton.instance.currentAppVersion) ?? 0) <
                (double.tryParse(Singleton.instance.latestVersion) ?? 0)) {
              emit(ForceUpdateState());
            } else {
              Singleton.instance.likeCount = homeResponseModel.shorts.likeRange;
              if (homeResponseModel.shorts.addShort) {
                add(AddNewShortsEvent(homeResponseModel.shorts.count));
              }

              await checkInDatabase(homeResponseModel: homeResponseModel);
              Singleton.instance.homeResponseModel = homeResponseModel;
              emit(HomeSuccessState(homeResponseModel: homeResponseModel));
            }
          }
        } catch (e) {
          logV("error===>$e");
          emit(HomeErrorState(error: "Something went wrong"));
        }
      };

  EventHandler<AddNewShortsEvent, HomeState> get _addShotsInDb =>
      (event, emit) async {
        int count = await Singleton.instance.getShortLastStoreCount();
        if (count != event.count) {
          List<ShortModel> loadedShortList =
              await DatabaseHelper.getAllShorts();
          List<ShortModel> shortList = await HomeRepository.getAllShorts(
              FirebaseConstants.tempShortList);
          if (loadedShortList.isNotEmpty) {
            await DatabaseHelper.deleteFirstData(shortList.length);
          }
          logV("AddNewShortsEvent");
          await DatabaseHelper.insertShortsList(shortList);
          await Singleton.instance.setShortLastStoreCount(event.count);
        }
      };

  checkInDatabase({required HomeResponseModelRt homeResponseModel}) async {
    List<SingleMovieModel> dbData = await DatabaseHelper.getAllMovies();
    if (dbData.isNotEmpty) {
      for (SingleMovieModel item in dbData) {
        for (SingleMovieModel responseItem in homeResponseModel.movieList) {
          if (item.movieName.toLowerCase() ==
              responseItem.movieName.toLowerCase()) {
            responseItem.inWatchList = true;
          }
        }
        for (SingleMovieModel responseItem
            in homeResponseModel.sliderList.slider) {
          if (item.movieName.toLowerCase() ==
              responseItem.movieName.toLowerCase()) {
            responseItem.inWatchList = true;
          }
        }
      }
    }
  }
}
