
import 'package:k_drama/features/shorts/data/model/short_model.dart';

abstract class ShortState {}

class ShortInitState extends ShortState {}

class ShortLoadingState extends ShortState {}

class ShortSuccessState extends ShortState {
  List<ShortModel> shortList;
  ShortSuccessState({required this.shortList});
}

class ShortErrorState extends ShortState {}


