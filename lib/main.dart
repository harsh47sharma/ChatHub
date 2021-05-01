import 'package:chathub/allchatpage.dart';
import 'package:chathub/loginpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp((MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My app',
      home: isLoggedIn() ? AllChatPage() : PhoneAuthPage(),
      //home: TestScreen(),
      /*initialRoute: '/',
      routes: {
        '/': (context) => FrontPage(),
        '/internetPage': (context) => NoInternetPage(),
      },*/
      theme: ThemeData(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        primaryColor: Colors.redAccent,
        accentColor: Colors.redAccent,
        primarySwatch: Colors.deepPurple,
      ),
    );
  }

  handle() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var isLoggedIn = (prefs.getBool('isLoggedIn') == null) ? false : prefs.getBool('isLoggedIn');
    if(isLoggedIn){
      return AllChatPage();
    }
    else{
      return PhoneAuthPage();
    }
  }

  static bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }
}
