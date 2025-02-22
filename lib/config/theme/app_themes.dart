import 'package:flutter/material.dart';
import 'package:k_drama/core/constants/app_colors.dart';

ThemeData theme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.primaryDark,
    appBarTheme: appBarTheme(),
    splashColor: Colors.transparent,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(elevation: 0),
    highlightColor: Colors.transparent,
    indicatorColor: AppColors.primaryLight
  );
}

AppBarTheme appBarTheme() {
  return  AppBarTheme(
    backgroundColor: AppColors.primaryDark,
    // color: Colors.white,

    elevation: 0,
    centerTitle: false,
    iconTheme: const IconThemeData(color: Color(0XFF8B8B8B)),
    titleTextStyle: const TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
  );
}