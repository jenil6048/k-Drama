import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:k_drama/features/home/data/model/home_model_rt.dart';

import '../../../../export.dart';

class HomeRepository {
  static final databaseReference = FirebaseDatabase.instance.ref();

  // static Future<List<HomeResponseModel>> getCategoryList() async {
  //   QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore
  //       .instance
  //       .collection(FirebaseConstants.home)
  //       .get();
  //   log("data====>${response.docs.map((e) => jsonEncode(e.data())).toList()}");
  //   final databaseReference = FirebaseDatabase.instance.ref();
  //   final DatabaseEvent data2 =await databaseReference.child('home').once();
  //   log("reale time data====> ${jsonEncode(data2.snapshot.value)}");
  //   var data = response.docs.map((e) => e.data()).toList();
  //   var finalData = homeResponseModelFromJson(jsonEncode(data));
  //   return finalData;
  // }
  static Future<HomeResponseModelRt> getHomeData() async {
    final DatabaseEvent response =
        await databaseReference.child(FirebaseConstants.home).once();
    // final DatabaseEvent getAllMovieAndSeries =await databaseReference.child(FirebaseConstants.tempShortList).once();
    log("real time data====> ${jsonEncode(response.snapshot.value)}");
    final data = dashboardModelFromJson(jsonEncode(response.snapshot.value));
    Singleton.instance.latestVersion = data.version;
    Singleton.instance.likeCount = data.shorts.likeRange;
    Singleton.instance.showAdd = data.ads;
    Singleton.instance.inReview = data.inReview;
    logV("Singleton.instance.showAdd==>${Singleton.instance.showAdd}");
    final HomeResponseModelRt data2 =
        dashboardModelFromJson(jsonEncode(response.snapshot.value));
    return data2;
  }

  static Future<List<AllMoviesList>> getAllMovieAndSeries() async {
    final DatabaseEvent response =
        await databaseReference.child(FirebaseConstants.moviesSeries).once();
    var data = response.snapshot.value;
    log("finalData===>${jsonEncode(data)}");
    List<AllMoviesList> finalData = allMoviesListFromJson(jsonEncode(data));

    return finalData;
  }

  static Future<List<ShortModel>> getAllShorts(String collectionName) async {
    final DatabaseEvent response =
        await databaseReference.child(collectionName).once();
    final data = response.snapshot.value;
    log("finalData===>${jsonEncode(data)}");
    List<ShortModel> finalData = shortModelFromJson(jsonEncode(data));
    return finalData;
  }
}
