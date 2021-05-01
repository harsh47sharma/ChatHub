import 'package:chathub/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color themeColor = Constants.themeRedColor;

TextStyle textStyleNoInternet() {
  return new TextStyle(
    fontFamily: 'RedHatText',
    color: Colors.black87,
    fontWeight: FontWeight.w700,
    fontSize: 29,
  );
}

TextStyle textStyleHeading({var colors, bool bold=false}) {
  (colors == null) ? colors = Constants.themeRedColor : print("not null");
  return new TextStyle(
    fontFamily: 'RedHatText',
    color: Constants.themeRedColor,
    fontWeight: (bold)?FontWeight.w700:null,
    fontSize: 30,
  );
}

TextStyle textStyleRegisterText() {
  return new TextStyle(
      fontFamily: 'RedHatText',
      color: Constants.themeRedColor,
      fontSize: 14,
      fontWeight: FontWeight.w600
  );
}

TextStyle textStyleHomePageHeading({var colors, bool bold=false}) {
  (colors == null) ? colors = Constants.themeRedColor : print("not null");
  return new TextStyle(
    fontFamily: 'RedHatText',
    color: Colors.white,
    fontWeight: (bold)?FontWeight.w600:null,
    fontSize: 18,
  );
}

TextStyle textStyleHomePageSubHeading({size = 18.0}) {
  return new TextStyle(fontSize: size);
}

TextStyle textStyleNormal({color = Colors.black, var increaseSize = 0.0}) {
  return new TextStyle(
    fontFamily: 'RedHatText',
    color: color,
    fontSize: 12 + increaseSize,
  );
}

TextStyle textStyleNormalBold({fontWeight=FontWeight.w700, var increaseSize = 0.0, italics=false, color = Colors.black}) {
  return new TextStyle(
    fontFamily: 'RedHatText',
    fontWeight: fontWeight,
    color: color,
    fontSize: 12.0 + increaseSize,
    fontStyle: italics ? FontStyle.italic : null
  );
}

TextStyle textStyleSmall({bold=false}) {
  return new TextStyle(
    fontFamily: 'RedHatText',
    color: Colors.black,
    fontWeight: bold ? FontWeight.w500 : null,
    fontSize: 12,
  );
}

TextStyle textStyleButtons() {
  return new TextStyle(
    fontFamily: 'RedHatText',
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 18,
  );
}

TextStyle textStyleSmallButtons() {
  return new TextStyle(
    fontFamily: 'RedHatText',
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 12,
  );
}

TextStyle textStyleLabelText({color}) {
  return new TextStyle(
    fontFamily: 'RedHatText',
    color: (color != null) ? color : Constants.themeRedColor,
    fontSize: 18,
  );
}

TextStyle textStyleEventPage() {
  return new TextStyle(
    fontFamily: 'RedHatText',
    color: Colors.black,
    fontSize: 13,
  );
}

TextStyle textStyleMyAccountText({bool italics = false, increaseSize = 0.0}) {
  return new TextStyle(
      fontFamily: 'RedHatText',
      color: Colors.black,
      fontSize: 12 + increaseSize,
      fontWeight: FontWeight.w500,
    fontStyle: (italics) ? FontStyle.italic : null
  );
}

TextStyle textStyleAlertDialogHeading() {
  return new TextStyle(
    fontFamily: 'RedHatText',
    fontWeight: FontWeight.w500,
    color: Colors.black,
    fontSize: 16,
  );
}

TextStyle textStyleAlertDialogBody() {
  return new TextStyle(
    fontFamily: 'RedHatText',
    color: Colors.grey.shade700,
    fontSize: 14,
  );
}

TextStyle textStyleAlertDialogButton() {
  return new TextStyle(
    fontFamily: 'RedHatText',
    color: Colors.blueAccent,
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );
}

TextStyle textStyleAppBar({bold = false}) {
  return new TextStyle(
    color: Colors.white,
    fontFamily: 'RedHatText',
    fontWeight:(bold) ? FontWeight.w800 : FontWeight.w400,
    fontSize: 16,
  );
}

TextStyle textStyleDropDown() {
  return new TextStyle(
    fontFamily: 'RedHatText',
    color: Colors.black,
    fontSize: 11,
  );
}

TextStyle textStyleHint() {
  return new TextStyle(
    fontFamily: 'RedHatText',
    color: Colors.grey,
    fontSize: 11,
  );
}

TextStyle textStylePublishPage({color = Colors.black, fontSize = 14.0}){
  return new TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.bold
  );
}

TextStyle textStyleUnderlinePublishPage(){
  return new TextStyle(
      color: Colors.blue,
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline);
}

BoxDecoration containerGrayBorder({color=Colors.white}) {
  return new BoxDecoration(
    border: Border.all(
      color: Colors.grey,
    ),
    color: color,
    borderRadius: BorderRadius.all(Radius.circular(7)),
  );
}

BoxDecoration dropDownDesign() {
  return BoxDecoration(
    border: Border.all(
      color: Colors.grey,
    ),
    color: Colors.grey.shade50,
    borderRadius: BorderRadius.all(Radius.circular(3)),
  );
}

