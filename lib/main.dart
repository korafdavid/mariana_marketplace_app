import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:mariana_marketplace/controller/AuthState.dart';
import 'package:mariana_marketplace/controller/fav_provider.dart';
import 'package:provider/provider.dart';
import 'secrets.dart';
import 'views/old_login_screen.dart';
import 'views/landing_screen.dart';
import 'package:mariana_marketplace/controller/api_calls.dart';

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
    //deleteAllAccountSessions();
    //deleteAllDocumentsInCollection(accountDetailsCollectionID);
    //deleteAllFilesInBucket("6259fa52f2266bd32b41");
    //getAllAccountSessionsAwaited();
    return MultiProvider(
      providers: [
         ChangeNotifierProvider(create: (context) => AuthState()),
          ChangeNotifierProvider(create: (context) => IconState()),
        Provider(create: ((context) => ClientClass()))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
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




class ClientClass {
Client client = Client()
          ..setEndpoint(appwriteEndpoint)
          .setProject(appwriteProjectID);
late Account account = Account(client);
late Storage storage = Storage(client);
late Database database = Database(client);

}