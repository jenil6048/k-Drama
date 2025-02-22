

import 'package:flutter/material.dart';
import 'package:k_drama/config/utils/size_utils.dart';

Widget customText({required String text,Color? color,FontWeight? fontWeight,double? fontSize,TextAlign? textAlign}){
  return Text(text,textAlign:textAlign ,style: customTextStyle(color: color,fontSize: fontSize,fontWeight: fontWeight,),);
}

TextStyle customTextStyle({Color? color,FontWeight? fontWeight,double? fontSize}){
  return TextStyle(
    color: color??Colors.white,

    fontWeight: fontWeight,
      fontFamily: 'Poppins',

    fontSize: getSize(fontSize??20)
  );
}


 const TextStyle poppinsTextStyle = TextStyle(
  fontSize: 18,
  color: Colors.white,
  fontWeight: FontWeight.w500,
   fontFamily: 'Poppins',
);