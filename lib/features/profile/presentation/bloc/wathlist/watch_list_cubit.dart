import '../../../../../export.dart';

class WatchListCubit extends Cubit<WatchListState> {
  WatchListCubit() : super(WatchListInitState());

  Future<void> getWatchListMovies() async {
    List<SingleMovieModel> watchListMovie = await DatabaseHelper.getAllMovies();
    emit(WatchListSuccessState(watchListMovie: watchListMovie));
  }

  removeFromWatchList(SingleMovieModel movie){
    List<SingleMovieModel> watchListMovie= (state as WatchListSuccessState).watchListMovie;
    DatabaseHelper.removeMovieByName(movie.movieName);
    watchListMovie.remove(movie);
    emit(WatchListSuccessState(watchListMovie: watchListMovie));
  }
}
