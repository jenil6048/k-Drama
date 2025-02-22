import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:k_drama/features/home/data/model/home_model_rt.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../export.dart';

class Singleton {
  Singleton._privateConstructor();

  static final Singleton _instance = Singleton._privateConstructor();

  static Singleton get instance => _instance;
  String currentAppVersion = "";
  String latestVersion = "";
  bool showAdd = false;
  bool inReview = false;
  List<String>? catList;
  List<WallpaperListRt>? wallpaperListRt;
  // List<WallPaperCategoryList>? catList;
  // List<WallpaperList>? singleCateItemList;
  HomeResponseModelRt? homeResponseModel;
  List<AllMoviesList>? moviesAndSeriesList;
  int likeCount = 1;
  bool isConnection =false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future getAppDetails() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    currentAppVersion = packageInfo.version;
  }

  appInIt() async {
    isConnection = await isConnectionAvailable();
    if (isConnection) {
      await Firebase.initializeApp();
      // unawaited(MobileAds.instance.initialize());

      await DatabaseHelper.initDatabase();
      await Singleton.instance.getAppDetails();
      await Singleton.instance.notification();
    }
  }

  Future<void> clearPref() async {
    final SharedPreferences prefs = await _prefs;
    prefs.clear();
  }

  Future<void> setShortLastStoreCount(int val) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt("short_add_last_count", val);
  }

  Future<int> getShortLastStoreCount() async {
    final SharedPreferences prefs = await _prefs;
    int val = prefs.getInt("short_add_last_count") ?? 0;
    return val;
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails("channel id", 'channel name',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
            channelShowBadge: true,
            color: AppColors.primaryDark,
            icon: "@mipmap/ic_launcher");
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      // iOS: initializationSettingsIOS
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  ///notification

  Future<dynamic> notification() async {
    await FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      logV('Notification onMessage: ${message.data.toString()}');
      await showNotification(
        title: message.notification!.title.toString(),
        id: 1,
        body: message.notification!.body.toString(),
      );

      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage message) async {
        logV('Notification onMessageOpenedApp: ${message.data.toString()}');
      });
    });
  }
}
