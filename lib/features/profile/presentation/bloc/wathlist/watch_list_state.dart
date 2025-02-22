
import 'package:k_drama/features/home/data/model/home_response_model.dart';

abstract class WatchListState {}

class WatchListInitState extends WatchListState {}

class WatchListSuccessState extends WatchListState {
  List<SingleMovieModel> watchListMovie;
  WatchListSuccessState({required this.watchListMovie});
}

class WatchListErrorState extends WatchListState{
}
