import 'dart:io';

import 'package:chathub/utils/textstyle.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Util {
  static getProgressBar(bool _progressBar) {
    return Visibility(
      visible: _progressBar,
      child: Center(
        child: Container(
          height: Constants.progressBarDimensions,
          width: Constants.progressBarDimensions,
          padding: EdgeInsets.all(Constants.progressBarPadding),
          child: Image.asset(
            "images/loading.gif",
          ),
        ),
      ),
    );
  }

//  static getAppBar(BuildContext context, title,
//      {bool driverMenu = false, bool homeBool = true}) {
//    return AppBar(
//      leading: IconButton(
//        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
//        onPressed: () => (driverMenu)
//            ? Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: ((context) => DriverMenu()),
//          ),
//        )
//            : Navigator.pop(context),
//      ),
//      title: Text(title, style: textStyleAppBar()),
//      centerTitle: true,
//      actions: (homeBool)
//          ? <Widget>[
//        Padding(
//          padding: EdgeInsets.only(right: 10.0),
//          child: GestureDetector(
//            onTap: () {
//              Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: ((context) => DriverMenu()),
//                ),
//              );
//            },
//            child: Icon(
//              Icons.home,
//              size: 30.0,
//            ),
//          ),
//        ),
//      ]
//          : null,
//    );
//  }

  static int hexToInt(String hex) {
    int val = 0;
    int len = hex.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = hex.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("Invalid hexadecimal value");
      }
    }
    return val;
  }

  static getTextField(String label, var controller,
      {var leadingIcon, var color, var margin = false , var marginDouble}) {
    return Container(
      padding: (margin)? EdgeInsets.symmetric(horizontal: 10.0) : (marginDouble != null) ? EdgeInsets.symmetric(horizontal: marginDouble) : null,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Text(label, style: textStyleLabelText()),
          Container(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIconConstraints: (leadingIcon != null)
                    ? BoxConstraints(minWidth: 23, maxHeight: 20)
                    : null,
                prefixIcon: (leadingIcon != null)
                    ? Padding(
                        padding:
                            EdgeInsets.only(right: Constants.minPadding / 2),
                        child: Icon(
                          leadingIcon,
                          color: (color != null) ? color : Constants.themeRedColor,
                        ))
                    : null,
              ),
            ),
          )
        ],
      ),
    );
  }

  static getButtonWithMethod(context, String title, Function method,
      {bool margin = true, double marginDouble}) {
    return Container(
      margin: (margin)? EdgeInsets.symmetric(horizontal: 10.0) : (marginDouble != null) ? EdgeInsets.symmetric(horizontal: marginDouble) : null,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9.0)),
        color: Constants.themeRedColor,
        child: Text(title, style: textStyleButtons()),
        onPressed: () {
          method();
        },
      ),
    );
  }

  static dialog(context, content, button,
      {title,
        Function method,
        dismissible = true,
        popPage = false}) {
    showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (_) => AlertDialog(
        title: (title != null)
            ? Text(title, style: textStyleAlertDialogHeading())
            : null,
        content: Text(
          content,
          style: textStyleAlertDialogBody(),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(button, style: textStyleAlertDialogButton()),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
              if (popPage) {
                Navigator.pop(context);
              }
              if (method != null) {
                method();
              }
            },
          ),
        ],
      ),
    );
  }

  static ProgressDialog progressDialog(BuildContext context){
//    return progressDialog(
//      context,
//      type: ProgressDialogType.Normal,
//      isDismissible: false,
//      showLogs: false,
//    );
  return ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: false, );
  }

  static getOtherApartmentText(String label, TextEditingController controller){
    print("hi");
    return Container(
      padding: EdgeInsets.all(Constants.minPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textStyleRegisterText(), textAlign: TextAlign.start),
          SizedBox(height: Constants.minPadding/2),
          TextField(
            decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero
            ),
            keyboardType: TextInputType.text,
            controller: controller,
          ),
          SizedBox(height: Constants.minPadding/2),
          Container(
            margin: EdgeInsets.symmetric(horizontal: Constants.minPadding * 2),
            child: RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(26.0)),
              color: Constants.themeRedColor,
              child: Text("update", style: textStyleButtons()),
              onPressed: () {

              },
            ),
          )
        ],
      ),
    );
  }
}
