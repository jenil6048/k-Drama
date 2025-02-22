import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:k_drama/features/wallpaper/data/model/wallpaper_list_model_rt.dart';

import '../../../../export.dart';

class WallPaperRepo{
 static final databaseReference = FirebaseDatabase.instance.ref();

 static Future< List<WallpaperListRt>> getAllWallpaper() async {
   final DatabaseEvent response =await databaseReference.child(FirebaseConstants.wallpapers).once();
    // var data=await FirebaseFirestore.instance
    //     .collection(collectionName)
    //     .get();
    // List<WallPaperCategoryList> catList = data.docs
    //     .map((e) => WallPaperCategoryList.fromJson(e.data()))
    //     .toList();
   final data=wallpaperListRtFromJson(jsonEncode(response.snapshot.value));
    return data;
  }


 // static Future<List<Wallpapers>> getSingleCatList(String collectionName,String docName) async {
 //    var data= await FirebaseFirestore.instance
 //        .collection(collectionName)
 //        .doc(docName)
 //        .collection("images")
 //        .get();
 //    List<WallpaperList> singleCateItemList = data.docs
 //        .map((e) => WallpaperList.fromJson(e.data()))
 //        .toList();
 //    return singleCateItemList;
 //  }
}