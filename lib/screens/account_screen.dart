import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mariana_marketplace/api_calls.dart';
import 'package:mariana_marketplace/screens/login_screen.dart';
import 'package:mariana_marketplace/screens/sign_up_screen.dart';
import 'package:appwrite/models.dart';
import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';
import 'package:mariana_marketplace/screens/landing_screen.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Future<User?> loggedInUser = getLoggedInUser();
  Future<Session?> currentSession = getCurrentSession();

  Future? loggingOutUser;

  DateTime dateTimeFromUnix(int UnixTimeStamp) {
    return DateTime.fromMillisecondsSinceEpoch(UnixTimeStamp * 1000);
  }

  Widget loggedInUserInfo() {
    return FutureBuilder(
      future: context.authNotifier.account.get(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          DateTime registrationdate =
              dateTimeFromUnix(snapshot.data!.registration);
          //return Text("Name: " + snapshot.data!.registration.toString());
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "Logged In User Info: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text("Name: " + snapshot.data!.name.toString()),
                      SizedBox(height: 10),
                      Text("Email: " + snapshot.data!.email.toString()),
                      SizedBox(height: 10),
                      Text(
                        "Prefs: \n" +
                            (snapshot.data!.prefs as Preferences)
                                .data
                                .toString(),
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                      Text("Email: " + snapshot.data!.email.toString()),
                      SizedBox(height: 10),
                      Text("Registration time: " + registrationdate.toString())
                    ],
                  ),
                )
              ],
            ),
          );
        } else {
          return Text("...");
        }
      },
    );
  }

  Widget currentSessionInfo() {
    return FutureBuilder(
      future: context.authNotifier.account.getSession(sessionId: 'current'),
      builder: (BuildContext context, AsyncSnapshot<Session?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          debugPrint("Snapshot Data: " + snapshot.data.toString());
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "Session Info: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text("clientCode: " + snapshot.data!.clientCode),
                      SizedBox(height: 10),
                      Text("clientName: " + snapshot.data!.clientName),
                      SizedBox(height: 10),
                      Text("clientType: " + snapshot.data!.clientType),
                      SizedBox(height: 10),
                      Text("countryName: " + snapshot.data!.countryName),
                      SizedBox(height: 10),
                      Text("deviceModel: " + snapshot.data!.deviceModel),
                      SizedBox(height: 10),
                      Text("ip: " + snapshot.data!.ip),
                      SizedBox(height: 10),
                      Text("expire: " +
                          dateTimeFromUnix(snapshot.data!.expire).toString()),
                      SizedBox(height: 10),
                    ],
                  ),
                )
              ],
            ),
          );
        } else {
          return Text("...");
        }
      },
    );
  }

  //Widget for submit button + loading indicator
  Widget? logoutButtonText(Future? loggingOut) {
    if (loggingOut != null) {
      return FutureBuilder(
        future: loggingOut,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            int seconds = 5;
            Future WaitTwoSecs = Future.delayed(
              Duration(seconds: seconds),
              (() async {}),
            );

            //Do the stuff after waiting two seconds.
            WaitTwoSecs.then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out.')),
              );
              Navigator.pop(context);
            });

            return const Text("Logged out, exiting.");
          } else {
            return const Text("Logging out, please wait.");
          }
        },
      );
    }
    return const Text("Log Out");
  }

  Widget logoutButton() {
    return ElevatedButton(
        onPressed: () async {
          // Validate returns true if the form is valid, or false otherwise.
          if (!await context.authNotifier.deleteSession()) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(context.authNotifier.error ?? "Unknown error")));
          }

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => LandingScreen()));

          setState(() {
            //loggingOutUser = deleteCurrentSession();
          });
        },
        child: Text("Logout") //logoutButtonText(loggingOutUser),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mariana Marketplace"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [loggedInUserInfo(), currentSessionInfo(), logoutButton()],
        ),
      ),
    );
  }
}
