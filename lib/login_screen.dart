import 'dart:io';

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:mariana_marketplace/landing_screen.dart';
import 'package:appwrite/appwrite.dart';
import 'package:mariana_marketplace/secrets.dart';

const users = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

Client appwriteClient = Client();

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2550);

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) async {
    try {
      //Sign up user
      User signedUpUser = await registerUserAccount(data);
      //Create session
      Session createdSession =
          await startUserSession(data.name!, data.password!);
      //Create database entry for user
      Document userInfoDocument = await createUserInfoEntry(
          signedUpUser.$id,
          signedUpUser.name,
          signedUpUser.email,
          data.additionalSignupData?["phone"] ?? "Missing",
          data.additionalSignupData?["birthday"] ?? "Missing",
          data.additionalSignupData?["address"] ?? "Missing",
          data.additionalSignupData?["island"] ?? "Missing");
      //Update user prefs
      User updatedUser = await updateUserPrefs(
          data.additionalSignupData?["phone"] ?? "Missing",
          data.additionalSignupData?["birthday"] ?? "Missing",
          data.additionalSignupData?["address"] ?? "Missing",
          data.additionalSignupData?["island"] ?? "Missing");

      //Everything successfully completed above, return null so caller knows we succeeded
      return null;
    } catch (e) {
      final String errorString =
          "Did not complete user signup fully, erorr: " + e.toString();
      debugPrint(errorString);
      return "Could not complete user signup";
    }
  }

  Future<User> registerUserAccount(SignupData data) {
    Account account = Account(appwriteClient);

    Future<User> result = account.create(
      userId: 'unique()',
      email: data.name!,
      password: data.password!,
    );

    return result;

    //result.then((response) {
    //  print("Response for registerUserAccount was: " + response.toString());
    //  return response;
    //}).catchError((error) {
    //  print(error.response);
    //  return error.response;
    //});
  }

  Future<Session> startUserSession(String anEmail, String anPassword) async {
    Account account = Account(appwriteClient);

    Future<Session> result = account.createSession(
      email: anEmail,
      password: anPassword,
    );

    return result;
    //result
    //  .then((response) {
    //    print(response);
    //  }).catchError((error) {
    //    print(error.response);
    //});
  }

  Future<Document> createUserInfoEntry(
      String anAccountID,
      String anName,
      String anEmail,
      String anPhone,
      String anBirthday,
      String anAddress,
      String anIsland) {
    // Init SDK
    Database database = Database(appwriteClient);

    Future<Document> result = database.createDocument(
        collectionId: accountDetailsCollectionID,
        documentId: 'unique()',
        data: {
          "account_id": anAccountID,
          "name": anName,
          "email": anEmail,
          "phone": anPhone,
          "birthday": anBirthday,
          "address": anAddress,
          "island": anIsland
        });

    return result;

    //result.then((response) {
    //  print(response);
    //  return response;
    //}).catchError((error) {
    //  print(error.response);
    //  return error.response;
    //});
  }

  Future<User> updateUserPrefs(
      String anPhone, String anBirthday, String anAddress, String anIsland) {
    // Init SDK
    Account account = Account(appwriteClient);

    Future<User> result = account.updatePrefs(
      prefs: {
        "phone": anPhone,
        "birthday": anBirthday,
        "address": anAddress,
        "island": anIsland
      },
    );

    return result;

    //result
    //  .then((response) {
    //    print(response);
    //  }).catchError((error) {
    //    print(error.response);
    //});
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    appwriteClient
        .setEndpoint(appwriteEndpoint) // Your Appwrite Endpoint
        .setProject(appwriteProjectID) // Your project ID
        .setSelfSigned(status: false);

    return FlutterLogin(
        title: 'Mariana\nMarketplace',
        //logo: AssetImage('assets/images/ecorp-lightblue.png'),

        onLogin: _authUser,
        onSignup: _signupUser,
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>
                const LandingScreen(title: 'Mariana Marketplace'),
          ));
        },
        onRecoverPassword: _recoverPassword,
        additionalSignupFields: const [
          UserFormField(
            keyName: "phone",
            displayName: "Phone Number",
            userType: LoginUserType.phone,
            icon: Icon(
              Icons.phone,
              size: 24.0,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
          ),
          UserFormField(
            keyName: "birthday",
            displayName: "Birthday",
            icon: Icon(
              Icons.cake,
              size: 24.0,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
          ),
          UserFormField(
            keyName: "island",
            displayName: "Island",
            icon: Icon(
              Icons.landscape,
              size: 24.0,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
          ),
          UserFormField(
              keyName: "address",
              displayName: "Address",
              icon: Icon(
                Icons.house,
                size: 24.0,
                semanticLabel: 'Text to announce in accessibility modes',
              )),
        ]);
  }
}
