import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:chathub/utils/constants.dart';
import 'package:chathub/utils/textstyle.dart';
import 'package:chathub/utils/util.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:chathub/chatroom.dart';

class SelectUser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SelectUserState();
  }
}

class _SelectUserState extends State<SelectUser> {
  var _formKey = GlobalKey<FormState>();

  Future _data;

  List<QueryDocumentSnapshot> finalUserList = List<QueryDocumentSnapshot>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContactsFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: getAppBar(),
          backgroundColor: Colors.white,
          //resizeToAvoidBottomPadding: false,
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.only(top: 11),
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        //physics: ScrollPhysics(),
                        //shrinkWrap: true,
                        cacheExtent: 3.0,
                        itemCount: finalUserList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: ((context) => ChatRoom(
                                              userName: finalUserList[index]
                                                  .data()["firstName"],
                                              userUId: finalUserList[index]
                                                  .data()["uid"])),
                                        ));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: Constants.minPadding / 2,
                                        right: Constants.minPadding / 2),
                                    child: getUserList(index),
                                  )),
                              Divider(thickness: 1)
                            ],
                          );
                        }),
                  )
                ],
              ),
            ),
          )),
    );
  }

  getUserList(index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      //width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: Constants.minPadding / 1.5,
                vertical: Constants.minPadding / 1.5),
            decoration:
                BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
            margin: EdgeInsets.all(5),
            child: Image(
              height: 20,
              width: 20,
              fit: BoxFit.fill,
              image: AssetImage("images/userimage.png"),
            ),
          ),
          SizedBox(width: Constants.minPadding),
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Text(finalUserList[index].get("firstName"),
                    style: textStyleMyAccountText(increaseSize: 5.0),
                    textAlign: TextAlign.start),
              ],
            ),
          )
        ],
      ),
    );
  }

  getContactsFromFirebase() async {
    Util.progressDialog(context).show();
    await FirebaseFirestore.instance
        .collection('users')
        .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((event) {
      if (event.docs.isNotEmpty) {
        setState(() {
          print(event.docs.first);
          finalUserList = event.docs;
        });
        //print(event.docs.length.toString() + "aaa");
      } else
        print("empty");
      Util.progressDialog(context).hide();
    }).catchError((e) => print("error fetching data: $e"));
  }

  getAppBar() {
    return AppBar(
      toolbarHeight: 43,
      backgroundColor: Constants.themeRedColor,
      leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      title: Text("Chat with user", style: textStyleAppBar(bold: true)),
      centerTitle: true,
    );
  }
}
