import 'package:chathub/allchatpage.dart';
import 'package:chathub/utils/constants.dart';
import 'package:chathub/utils/textstyle.dart';
import 'package:chathub/utils/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';

class ChatRoom extends StatefulWidget {
  final String userUId;
  final String userName;

  ChatRoom({this.userUId, this.userName});

  @override
  State<StatefulWidget> createState() {
    return _ChatRoomState();
  }
}

class _ChatRoomState extends State<ChatRoom> {
  var _formKey = GlobalKey<FormState>();

  TextEditingController textController = TextEditingController();

  var stream;

  var currentDate, previousDate, units, timeAgo, jiffy1, jiffy2;

  int firstTime = 0;

  var chatInfo;

  var participantsUId = "", hostUId = "";

  bool data = false;

  String firstUser = "", secondUser = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if (widget.firstTime == 1)
    //   initializeChat();
    // else
    //   getChatDetails();
    checkIfFirstTime();
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.userName + "JJJJJ");
    double statusBarHeight = MediaQuery.of(context).padding.top;
    //SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    stream = getChats(firstUser, secondUser);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.grey.shade200,
          //resizeToAvoidBottomPadding: false,
          body: Form(
            key: _formKey,
            child: data == false
                ? Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    Expanded(
                      child: Container(
                          height: MediaQuery.of(context).size.height,
                          padding: EdgeInsets.only(top: statusBarHeight),
                          child: Container(
                            child: StreamBuilder(
                              stream: stream,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.waiting &&
                                    firstTime == 0) {
                                  firstTime = 1;
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  print("else");
                                  return (snapshot.data == null ||
                                          !snapshot.hasData ||
                                          snapshot.data.documents.length == 0)
                                      ? Center(
                                          child: Text("No Message Found!"),
                                        )
                                      : Column(
                                          children: [
                                            getChatAppBar(
                                              widget.userName
                                            ),
                                            SizedBox(
                                                height: Constants.minPadding),
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height -
                                                  200,
                                              child: ListView.builder(
                                                  //physics: ScrollPhysics(),
                                                  //shrinkWrap: true,
                                                  cacheExtent: 3.0,
                                                  reverse: true,
                                                  itemCount: snapshot
                                                      .data.documents.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Column(
                                                      crossAxisAlignment: (FirebaseAuth
                                                                  .instance
                                                                  .currentUser
                                                                  .uid ==
                                                              snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data()[
                                                                  "senderUId"])
                                                          ? CrossAxisAlignment
                                                              .end
                                                          : CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        4),
                                                            //margin: EdgeInsets.symmetric(horizontal: 30),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1.2,
                                                            child: getChatBox(
                                                              snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data()[
                                                                  "message"],
                                                              snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data()[
                                                                  "senderName"],
                                                              snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data()[
                                                                  "senderUId"],
                                                              snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data()[
                                                                  "receiverUId"],
                                                              snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .data()[
                                                                  "messageDateTime"],
                                                            )),
                                                        SizedBox(
                                                            height: Constants
                                                                    .minPadding /
                                                                2)
                                                      ],
                                                    );
                                                  }),
                                            ),
                                          ],
                                        );
                                }
                              },
                            ),
                          ),
                        ),
                    ),
                    Divider(thickness: 1, color: Constants.themeRedColor),
                    writeComment(),
                    SizedBox(height: 12),
                  ],
                ),
          )),
    );
  }

  getChatAppBar(userName) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
      ),
      //width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: Constants.minPadding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
              onTap: () => goBack(), child: Icon(Icons.keyboard_arrow_left)),
          SizedBox(width: Constants.minPadding),
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
            width: MediaQuery.of(context).size.width - 140,
            height: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName,
                    style: textStyleNormalBold(
                        increaseSize: 2, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.start),
                SizedBox(height: Constants.minPadding / 2),
              ],
            ),
          )
        ],
      ),
    );
  }

  getChatBox(comment, senderName, senderUId, receiverUId, date) {
    //print(date + " $userName " + DateTime.now().toString());
    updateCommentTimeStamp(date);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade100),
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(40),
            topLeft: Radius.circular(40),
            bottomLeft: (FirebaseAuth.instance.currentUser.uid == senderUId)
                ? Radius.circular(40)
                : Radius.circular(0),
            bottomRight: (FirebaseAuth.instance.currentUser.uid != senderUId)
                ? Radius.circular(40)
                : Radius.circular(0)),
        color: (FirebaseAuth.instance.currentUser.uid == senderUId)
            ? Colors.green[100]
            : Colors.white,
      ),
      padding: EdgeInsets.symmetric(
          horizontal: Constants.minPadding / 2,
          vertical: Constants.minPadding / 4),
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
              height: 15,
              width: 15,
              fit: BoxFit.fitWidth,
              image: AssetImage("images/userimage.png"),
            ),
          ),
          SizedBox(width: Constants.minPadding),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: (MediaQuery.of(context).size.width / 1.5) - 45,
                child: Row(
                  children: [
                    Text(" " + senderName,
                        style: textStyleMyAccountText(),
                        textAlign: TextAlign.start),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        "$timeAgo ${(timeAgo == 1) ? units : units + "s"} ago",
                        style: textStyleNormalBold(
                            increaseSize: -2.0,
                            italics: true,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: Constants.minPadding / 2),
              Container(
                width: (MediaQuery.of(context).size.width / 1.5) - 45,
                padding: EdgeInsets.only(right: Constants.minPadding),
                child: Text(comment,
                    style: textStyleMyAccountText(),
                    textAlign: TextAlign.start),
              ),
            ],
          )
        ],
      ),
    );
  }

  writeComment() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Constants.minPadding / 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 7,
            child: TextFormField(
              keyboardType: TextInputType.text,
              style: textStyleEventPage(),
              //maxLength: 150,
              minLines: 1,
              maxLines: 4,
              controller: textController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                    left: 8.0, top: 14.0, bottom: 4.0, right: 2.0),
                isDense: true,
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey)),
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () => onPressSendMessage(),
                child: Container(
                    padding: EdgeInsets.all(Constants.minPadding / 2),
                    decoration: BoxDecoration(
                        color: Constants.themeRedColor, shape: BoxShape.circle),
                    margin: EdgeInsets.all(1),
                    child: Icon(Icons.send, size: 20, color: Colors.white)),
              )),
          SizedBox(height: Constants.minPadding)
        ],
      ),
    );
  }

  onPressSendMessage() {
    String message = textController.text.trim();

    if (message.length != 0) {
      var ref = FirebaseFirestore.instance
          .collection("chats")
          .doc("$firstUser-$secondUser")
          .collection("chatRoom")
          .doc();

      Map<String, dynamic> addMessage = {
        "message": message,
        "messageTimeStamp": FieldValue.serverTimestamp(),
        "messageDateTime": DateTime.now().toString(),
        "senderName": Constants.userName,
        "senderUId": FirebaseAuth.instance.currentUser.uid,
        "receiverName": widget.userName,
        "receiverUId": widget.userUId
      };
      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(ref, addMessage);
      });

      FirebaseFirestore.instance
          .collection("chats")
          .doc("$firstUser-$secondUser")
          .update({
        "lastMessage": message,
        "lastMessageDateTime": DateTime.now().toString(),
        "lastMessageTimeStamp": FieldValue.serverTimestamp()
      });
      textController.clear();
      FocusScope.of(context).requestFocus(new FocusNode());

      //scrollController.animateTo(0.0, duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
    }
  }

  initializeChat() async {
    print("finalll");
    Util.progressDialog(context).show();
    DocumentReference chatRoomFields = FirebaseFirestore.instance
        .collection('chats')
        .doc(
            "${FirebaseAuth.instance.currentUser.uid}-${widget.userUId}");

    List<String> userId = List<String>();
    userId.add(FirebaseAuth.instance.currentUser.uid);
    userId.add(widget.userUId);

    Map<String, dynamic> chatRoomCreation = {
      "chatRoomId": chatRoomFields.id,
      "firstUserId": FirebaseAuth.instance.currentUser.uid,
      "secondUserId": widget.userUId,
      "firstUserName": Constants.userName,
      "secondUserName": widget.userName,
      "userIdList": userId,
      "lastMessage": "",
      "lastMessageDateTime": DateTime.now().toString(),
      "lastMessageTimeStamp": FieldValue.serverTimestamp()
    };

    chatRoomFields.set(chatRoomCreation).then((value) {
      stream = getChats(FirebaseAuth.instance.currentUser.uid,
          widget.userUId);
      setState(() {
        firstUser = FirebaseAuth.instance.currentUser.uid;
        secondUser =widget.userUId;
        data = true;
      });
      Util.progressDialog(context).hide();
    }).catchError((e) {
      print(e);
    });
  }

  checkIfFirstTime() async {
    // await FirebaseFirestore.instance
    //     .collection('chats')
    //     .where("userIdList",
    //     arrayContains:
    //     FirebaseAuth.instance.currentUser.uid)
    //     .where("hostUId", isEqualTo: widget.receiverInfo.get("uid"))
    //     .where("participantUId", isEqualTo: FirebaseAuth.instance.currentUser.uid)
    //     .get()
    //     .then((event) {
    //   if (event.docs.isNotEmpty) {
    //     Map<String, dynamic> documentData = event.docs.single.data();
    //     setState(() {
    //       data = true;
    //       print("in chat details");
    //       chatInfo = documentData;
    //       participantsUId = chatInfo["participantUId"];
    //       hostUId = chatInfo["hostUId"];
    //     });
    //     Util.progressDialog(context).hide();
    //   }
    //   else{
    //     print("elseee");
    //   }
    // }).catchError((e) => print("error fetching data: $e"));

    var fireStore = FirebaseFirestore.instance;
    List<QueryDocumentSnapshot> list = List<QueryDocumentSnapshot>();
    List<QueryDocumentSnapshot> rList = List<QueryDocumentSnapshot>();
    print(widget.userUId);
    QuerySnapshot firstCheck = await fireStore
        .collection('chats')
        .where("secondUserId", isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .where("firstUserId", isEqualTo: widget.userUId)
        .get()
        .catchError((onError) {
      print(onError);
    });

    QuerySnapshot secondCheck = await fireStore
        .collection('chats')
        .where("secondUserId", isEqualTo: widget.userUId)
        .where("firstUserId", isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get()
        .catchError((onError) {
      print(onError);
    });

    if (firstCheck.docs.isEmpty && secondCheck.docs.isEmpty) {
      print("both user id null while checking fist time");
      initializeChat();
    } else {
      if (firstCheck.docs.isNotEmpty) {
        print("first user id null while checking fist time");
        stream = getChats(widget.userUId,
            FirebaseAuth.instance.currentUser.uid);
        setState(() {
          secondUser = FirebaseAuth.instance.currentUser.uid;
          firstUser = widget.userUId;
          data = true;
        });
      } else {
        print("second user id null while checking fist time");
        stream = getChats(FirebaseAuth.instance.currentUser.uid,
            widget.userUId);
        setState(() {
          firstUser = FirebaseAuth.instance.currentUser.uid;
          secondUser = widget.userUId;
          data = true;
        });
      }
    }
  }

  // Future<bool> checkNotExist() async {
  //   bool exists = true;
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('chats')
  //         .doc("${FirebaseAuth.instance.currentUser.uid}-${widget.receiverInfo.get("uid")}")
  //         .get()
  //         .then((doc) {
  //       if (doc.exists)
  //         exists = true;
  //       else
  //         exists = false;
  //     });
  //
  //     if(!exists){
  //       await FirebaseFirestore.instance
  //           .collection('chats')
  //           .doc("${widget.receiverInfo.get("uid")}-${FirebaseAuth.instance.currentUser.uid}")
  //           .get()
  //           .then((doc) {
  //         if (doc.exists)
  //           exists = true;
  //         else
  //           exists = false;
  //       });
  //     }
  //     return exists;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  // getChatDetails() async {
  //   print("yooooo");
  //     await FirebaseFirestore.instance
  //         .collection('chats')
  //         .where("userIdList",
  //         arrayContains:
  //         FirebaseAuth.instance.currentUser.uid)
  //         .where("userIdList", arrayContains: widget.receiverInfo.get("uid"))
  //         .get()
  //         .then((event) {
  //       if (event.docs.isNotEmpty) {
  //         Map<String, dynamic> documentData = event.docs.single.data();
  //         setState(() {
  //           data = true;
  //           print("in chat details");
  //           chatInfo = documentData;
  //           participantsUId = chatInfo["participantUId"];
  //           hostUId = chatInfo["hostUId"];
  //         });
  //         Util.progressDialog(context).hide();
  //       }
  //       else{
  //         print("elseee");
  //       }
  //     }).catchError((e) => print("error fetching data: $e"));
  // }

  getChats(firstUserId, secondUserId) {
    return FirebaseFirestore.instance
        .collection("chats")
        .doc("$firstUserId-$secondUserId")
        .collection("chatRoom")
        .orderBy("messageTimeStamp", descending: true)
        .snapshots();
  }

  void updateCommentTimeStamp(date) {
    currentDate = DateTime.now();
    previousDate = DateTime.parse(date == null ? currentDate.toString() : date);
    timeAgo = currentDate.difference(previousDate).inMinutes;
    units = "minute";
    if (timeAgo >= 60) {
      timeAgo = currentDate.difference(previousDate).inHours;
      units = "hour";
      if (timeAgo >= 24) {
        timeAgo = currentDate.difference(previousDate).inDays;
        units = "day";
        if (timeAgo >= 31) {
          jiffy1 = Jiffy(
              "${previousDate.year}-${previousDate.month}-${previousDate.day}",
              "yyyy-MM-dd");
          jiffy2 = Jiffy(
              "${currentDate.year}-${currentDate.month}-${currentDate.day}",
              "yyyy-MM-dd");
          timeAgo = jiffy2.diff(jiffy1, Units.MONTH);
          units = "month";
          if (timeAgo >= 12) {
            jiffy1 = Jiffy(
                "${previousDate.year}-${previousDate.month}-${previousDate.day}",
                "yyyy-MM-dd");
            jiffy2 = Jiffy(
                "${currentDate.year}-${currentDate.month}-${currentDate.day}",
                "yyyy-MM-dd");
            timeAgo = jiffy2.diff(jiffy1, Units.YEAR);
            units = "year";
          }
        }
      }
    }
  }

  goBack() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) => AllChatPage()),
        ));
  }
}
