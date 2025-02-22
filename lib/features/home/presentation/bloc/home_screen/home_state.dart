import 'package:k_drama/features/home/data/model/home_model_rt.dart';
import 'package:k_drama/features/home/data/model/home_response_model.dart';

abstract class HomeState {}

class HomeInitState extends HomeState {}

class HomeSuccessState extends HomeState {
  HomeResponseModelRt homeResponseModel;

  HomeSuccessState({required this.homeResponseModel});
}

class HomeErrorState extends HomeState {
  String? error;
  HomeErrorState({this.error});
}

class ForceUpdateState extends HomeState {
  ForceUpdateState();
}
