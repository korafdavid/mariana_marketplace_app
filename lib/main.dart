import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'secrets.dart';
import 'screens/landing_screen.dart';
import 'package:mariana_marketplace/api_calls.dart';
import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';
import 'appwrite_client.dart';

//Client appwriteClient = Client();

void main() {
  runApp(MyApp());
  //registerAccount('evoteccit@gmail.com', 'SuperAwesomeLad'); //Disabled for testing
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Client client;
  @override
  void initState() {
    super.initState();
    //initialize your client
    client = AppwriteClient.client;
  }

  @override
  Widget build(BuildContext context) {
    return FlAppwriteAccountKit(
      client: client,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          primarySwatch: Colors.green,
        ),
        home: const LandingScreen(),
      ),
    );
  }
}
