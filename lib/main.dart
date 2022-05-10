import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'secrets.dart';
import 'old_login_screen.dart';
import 'landing_screen.dart';
import 'package:mariana_marketplace/api_calls.dart';

//Client appwriteClient = Client();

void main() {
  runApp(const MyApp());
  //registerAccount('evoteccit@gmail.com', 'SuperAwesomeLad'); //Disabled for testing
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //TODO?: Create an anonymous user session to actually display ads?
    deleteAllAccountSessions();
    //deleteAllDocumentsInCollection(accountDetailsCollectionID);
    //deleteAllFilesInBucket("6259fa52f2266bd32b41");
    //getAllAccountSessionsAwaited();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.green,
      ),
      home: const LandingScreen(),
    );
  }
}
