import 'package:flutter/material.dart';

class AppColors{
  static Color primaryLight = const Color(0xFFe48bae);
  static Color primaryDark = const Color(0xFF121212);
  static Color purple = const Color(0xFF9575cd);
  static Color lightBottomNavigationColor = fromHex('#FFFFFF');
  static Color primaryColor = fromHex('#191a2c');
  static Color pink = fromHex('#f72585');
  static Color red = Colors.red;
  static Color navigationBarColor = fromHex('#101418');
  static Color textColor = fromHex('#e5e5e7');
  static var black =  fromHex('#070A0D');
  static var lightBlack =  Colors.black54;
  static var green = fromHex("#33C264");
  static var grey = Colors.grey.shade800;
  static var lightGrey = fromHex("#ECEBEB");
  static var appIconColor = fromHex("#7A7A7A");
  static var orderStatusColor = fromHex("#AEE9D1");
  static var indigo = Colors.indigo;
  static var transparent = Colors.transparent;
  static var originalGrey = Colors.grey.shade400;
  static var white = Colors.white;

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

}