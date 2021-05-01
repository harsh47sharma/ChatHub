import 'package:chathub/allchatpage.dart';
import 'package:chathub/utils/constants.dart';
import 'package:chathub/utils/textstyle.dart';
import 'package:chathub/utils/util.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneAuthPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _PhoneAuthPageState();
  }
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  var cardViewHeight = 0.0;
  var cardRoundBorder = 30.0;

  TextEditingController _otpController = TextEditingController();

  var _phoneNumber;

  String verificationId, smsCode;

  bool codeSent = false;

  bool isUserLoggedIn = false;

  TextEditingController userName = TextEditingController();

  @override
  void initState() {
    super.initState();
    //sharedPreference();
  }

//  sharedPreference() async {
//    PhoneAuthPage.sp = await SharedPreferences.getInstance();
//  }

  void onPhoneNumberChange(String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      _phoneNumber = internationalizedPhoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    cardViewHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).size.height / 5;
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              top: 0,
              height: MediaQuery.of(context).size.height / 4,
              child: Container(
                child: Image(
                  fit: BoxFit.fitHeight,
                  image: AssetImage("images/sample.png"),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              height: cardViewHeight,
              width: MediaQuery.of(context).size.width,
              child: Card(
                  margin: EdgeInsets.zero,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(cardRoundBorder),
                        topLeft: Radius.circular(cardRoundBorder)),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Text("welcome to",
                          style: textStyleHeading(),
                          textAlign: TextAlign.center),
                      SizedBox(height: Constants.minPadding),
                      Image(image: AssetImage('images/logo.JPG')),
                      SizedBox(height: Constants.minPadding),
                      (codeSent) ? getTextField("OTP", _otpController,
                          leadingIcon: Icons.lock,
                          marginDouble: Constants.minPadding * 2) : Container(
                        padding: EdgeInsets.symmetric(horizontal: Constants.minPadding*2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textFieldWithText("Name*", userName),
                            SizedBox(height: Constants.minPadding),
                            Text("Enter Number", style: textStyleLabelText(), textAlign: TextAlign.start,),
                            InternationalPhoneInput(
                                hintText: 'eg. 9999999999',
                                onPhoneNumberChange: onPhoneNumberChange,
                                initialPhoneNumber: _phoneNumber,
                                initialSelection: 'IN',
                                showCountryCodes: true
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Constants.minPadding * 2),
                      getButton()
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  getTextField(String label, var controller,
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
              onChanged: (val) {
                setState(() {
                  this.smsCode = val;
                });
              },
              keyboardType: TextInputType.phone,
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


  getButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Constants.minPadding * 4),
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(26.0)),
        color: Constants.themeRedColor,
        child: (codeSent) ? Text("Verify", style: textStyleButtons()): Text("Continue", style: textStyleButtons()),
        onPressed: () {
          //Util.progressDialog(context).show();
          (codeSent) ? signInWithOTP(smsCode, verificationId) : verifyPhoneNumber();
        },
      ),
    );
  }

  verifyPhoneNumber(){
    if(_phoneNumber != null && _phoneNumber.length != 0 && userName.text.length != 0){
      Util.progressDialog(context).show();
      onPressedLogin();
    }
    else{
      Util.progressDialog(context).hide();
      Util.dialog(context, "Invalid Phone Number", "OK", dismissible: true, title: "Alert!");

    }
  }

  Future<void> onPressedLogin() async{
          final PhoneVerificationCompleted verified = (AuthCredential authResult) {
        signIn(authResult);
      };

      final PhoneVerificationFailed verificationFailed = (
          FirebaseAuthException authException) {
        print('${authException.message}');
      };

      final PhoneCodeSent smsSent = (String verId, [int forcedResend]) {
        this.verificationId = verId;
        setState(() {
          this.codeSent = true;
          Util.progressDialog(context).hide();
        });
      };

      final PhoneCodeAutoRetrievalTimeout authTimeout = (String verId) {
        this.verificationId = verId;
      };

      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: _phoneNumber,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verified,
          verificationFailed: verificationFailed,
          codeSent: smsSent,
          codeAutoRetrievalTimeout: authTimeout).catchError((e){
            print(e);
      });
  }


  signIn(AuthCredential authCredentials) {
    print("in sign");
    Util.progressDialog(context).show();
    FirebaseAuth.instance.signInWithCredential(authCredentials).then((value){
      Util.progressDialog(context).hide();
        print("galat andar");
        addUserToDB();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => AllChatPage()),
            ));
    }).catchError((onError) {
      Util.progressDialog(context).hide();
      Util.dialog(context, "Invalid OTP", "OK", dismissible: true);
    }).timeout(Duration(seconds: 10));
  }

  signInWithOTP(smsCode, verId) async {
      if (_otpController.text.length == 0) {
        Util.dialog(context, "OTP cannot be null", "OK", dismissible: true);
      }
      else {
        AuthCredential authCredential = PhoneAuthProvider.getCredential(
            verificationId: verId, smsCode: smsCode);
        signIn(authCredential);
      }
  }

  addUserToDB(){
    Map<String, dynamic> userData = {
      'uid': FirebaseAuth.instance.currentUser.uid,
      'firstName': userName.text,
      'phoneNumber': _phoneNumber.toString()
    };

    CollectionReference users =
    FirebaseFirestore.instance.collection('users');
    users
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set(userData)
        .then((value) {
    }).catchError((e) {
      Util.dialog(
          context, "Something went wrong! Please try again later.", "OK",
          title: "Alert", dismissible: true);
    });
  }

  textFieldWithText(String label, controller, {readOnly = false}) {
    return Container(
      padding: EdgeInsets.all(Constants.minPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: textStyleRegisterText(), textAlign: TextAlign.start),
          SizedBox(height: Constants.minPadding / 2),
          TextFormField(
            readOnly: readOnly,
            decoration:
            InputDecoration(isDense: true, contentPadding: EdgeInsets.zero),
            keyboardType: TextInputType.text,
            controller: controller,
          )
        ],
      ),
    );
  }
}
