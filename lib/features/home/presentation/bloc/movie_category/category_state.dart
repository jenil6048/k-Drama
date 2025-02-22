import 'package:k_drama/features/home/data/model/all_movies_model.dart';

abstract class CategoryState {}

class CategoryInitState extends CategoryState {}

class CategorySuccessState extends CategoryState {
  List<AllMoviesList> movieList;
  CategorySuccessState({required this.movieList});
}

class CategoryErrorState extends CategoryState {
  String? error;
  CategoryErrorState({this.error});
}
