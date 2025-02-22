
import 'package:k_drama/export.dart';


class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitState());

  Future<void> getAllMovieAndSeries() async {
    try {
      List<AllMoviesList> data;
      if(Singleton.instance.moviesAndSeriesList== null) {
        data = await HomeRepository.getAllMovieAndSeries();
        Singleton.instance.moviesAndSeriesList=data;
      }
      else{
        data=Singleton.instance.moviesAndSeriesList!;
      }
      emit(CategorySuccessState(movieList: data));
    } catch (e) {
      logV("error===>$e");
      emit(CategoryErrorState(error: "Something went wrong"));
    }
  }
}
