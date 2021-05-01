import 'package:chathub/chatroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:chathub/utils/constants.dart';
import 'package:chathub/utils/textstyle.dart';
import 'package:chathub/utils/util.dart';
import 'package:chathub/selectuser.dart';

class AllChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AllChatPageState();
  }
}

class _AllChatPageState extends State<AllChatPage> {
  var _formKey = GlobalKey<FormState>();

  Future _data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
    getAllChats();
  }

  @override
  Widget build(BuildContext context) {
    _data = getAllChats();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: getAppBar(),
          backgroundColor: Colors.white,
          //resizeToAvoidBottomPadding: false,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndFloat,
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.chat_bubble, color: Colors.white),
            backgroundColor: Constants.themeRedColor,
            onPressed: () {
              // setState(() {
              //   FirebaseAuth.instance.signOut();
              // });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => SelectUser()),
                  ));
            },
          ),
          body: Form(
            key: _formKey,
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: FutureBuilder(
                        future: _data,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return (snapshot.data == null ||
                                    snapshot.data.length == 0)
                                ? Center(child: Text("No chats Found!"))
                                : Container(
                                    height: MediaQuery.of(context).size.height,
                                    padding: EdgeInsets.only(top: 11),
                                    child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        //physics: ScrollPhysics(),
                                        //shrinkWrap: true,
                                        cacheExtent: 3.0,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              GestureDetector(
                                                  onTap: () => goToChatWindow(
                                              snapshot.data[index].data()["firstUserId"] == FirebaseAuth.instance.currentUser.uid
                                              ? snapshot.data[index].data()["secondUserName"]
                                                    : snapshot.data[index].data()["firstUserName"],
                                                    snapshot.data[index].data()["firstUserId"] == FirebaseAuth.instance.currentUser.uid
                                                        ? snapshot.data[index].data()["secondUserId"]
                                                    : snapshot.data[index].data()["firstUserId"],
                                                  ),
                                                  child: Container(
                                                padding: EdgeInsets.only(
                                                    left: Constants.minPadding /
                                                        2,
                                                    right:
                                                        Constants.minPadding /
                                                            2),
                                                child: getUserInfoText(snapshot
                                                                .data[index]
                                                                .data()[
                                                            "firstUserId"] ==
                                                        FirebaseAuth.instance
                                                            .currentUser.uid
                                                    ? snapshot.data[index]
                                                            .data()[
                                                        "secondUserName"]
                                                    : snapshot.data[index]
                                                            .data()[
                                                        "firstUserName"]),
                                              )),
                                              Divider(thickness: 1)
                                            ],
                                          );
                                        }),
                                  );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  getUserInfoText(userName) {
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
                Text(userName,
                    style: textStyleMyAccountText(increaseSize: 5.0),
                    textAlign: TextAlign.start),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future getAllChats() async {
    var fireStore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await fireStore
        .collection("chats")
        .where("userIdList",
            arrayContains: FirebaseAuth.instance.currentUser.uid)
        .orderBy("lastMessageTimeStamp", descending: true)
        .get()
        .catchError((onError) {
      print(onError);
    });
    print(querySnapshot.docs.length.toString() + "hhhhh");
    return querySnapshot.docs;
  }

  Future<void> getUserInfo() async {
    Util.progressDialog(context).show();
    await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId,
            isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((event) {
      if (event.docs.isNotEmpty) {
        Map<String, dynamic> documentData = event.docs.single.data();
        setState(() {
          Constants.userName = documentData["firstName"];
          //print("$userName and $apartmentName");
          Util.progressDialog(context).hide();
        });
      }
    }).catchError((e) => print("error fetching data: $e"));
  }

  goToChatWindow(userName, userId) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) => ChatRoom(userName: userName, userUId: userId)),
        ));
  }

  getAppBar() {
    return AppBar(
      toolbarHeight: 43,
      backgroundColor: Constants.themeRedColor,
      title: Text("Chat Hub", style: textStyleAppBar(bold: true)),
      centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: Icon(
                Icons.logout,
                size: 20.0,
              ),
            ),
          ),
        ]);
  }
}
