import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';


const int paginationLimit = 10;

/// API METHODS
const String post = "POST";
const String get = "GET";

void logV(String content) {
  if (kDebugMode) {
    print(content);
  }
}

void logResponse(Response response, String url, String method) {
  if (kDebugMode) {
    log('<-- ${response.statusCode} $method $url', name: "Request");
    try {
      dynamic responseBody = json.decode(response.body);
      String prettyJson =
          const JsonEncoder.withIndent('  ').convert(responseBody);
      log(prettyJson, name: "Response");
    } catch (e) {
      log("error=> ${e.toString()}");
    }
  }
}

hideKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

void showInSnackBar(String value, BuildContext context) {
  var snackBar = SnackBar(content: Text(value));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

int getPaginationPageSize(int size) {
  if (size < paginationLimit) {
    return 0;
  }

  int newPage = (size / paginationLimit).floor();

  return ++newPage;
}

Future<bool> isConnectionAvailable() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}

showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0);
}


getSizeBox({double? height,double? width}){
  return SizedBox(height:height??0,width: width??0,);
}

extension StringExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }
}