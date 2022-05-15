import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mariana_marketplace/controller/api_calls.dart';
import 'package:mariana_marketplace/views/login_screen.dart';
import 'package:mariana_marketplace/views/sign_up_screen.dart';
import 'package:appwrite/models.dart';
import 'package:mariana_marketplace/controller/AuthState.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Future<User?>? loggedInUser;
  Future<Session?>? session;

  DateTime dateTimeFromUnix(int UnixTimeStamp) {
    return DateTime.fromMillisecondsSinceEpoch(UnixTimeStamp * 1000);
  }

  Widget loggedInUserInfo(AuthState state) {
    loggedInUser = state.getLoggedIn();
    return FutureBuilder(
      future: loggedInUser,
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

  Widget currentSessionInfo(AuthState state) {
    session = state.getCurrentSession();
    return FutureBuilder(
      future: session,
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

  Widget logoutButton(AuthState state) {
    return ElevatedButton(
      onPressed: () {
        state.deleteCurrentSession(context);
      },
      child: Text(state.logOutDetail),
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthState state = Provider.of<AuthState>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text("Mariana Marketplace"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          loggedInUserInfo(state),
          currentSessionInfo(state),
          logoutButton(state)
        ],
      ),
    );
  }
}
