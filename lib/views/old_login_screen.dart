import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:mariana_marketplace/views/landing_screen.dart';
import 'package:appwrite/appwrite.dart';
import 'package:mariana_marketplace/secrets.dart';

import 'package:mariana_marketplace/controller/api_calls.dart';

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

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

  // Future<String?> _signupWrapper(BuildContext context, SignupData data) async {
  //   try {
  //     return signupUser(
  //       context,
  //         data.additionalSignupData?["firstname"] ?? "Missing",
  //         data.additionalSignupData?["lastname"] ?? "Missing",
  //         data.name ?? "Missing",
  //         data.password ?? "Missing",
  //         data.additionalSignupData?["phone"] ?? "Missing",
  //         data.additionalSignupData?["birthday"] ?? "Missing",
  //         data.additionalSignupData?["address"] ?? "Missing",
  //         data.additionalSignupData?["island"] ?? "Missing");
  //   } catch (e) {
  //     final String errorString =
  //         "Did not complete user signup fully, error: " + e.toString();
  //     debugPrint(errorString);
  //     return "Could not complete user signup";
  //   }
  // }

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
       // onSignup: _signupWrapper,
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const LandingScreen(),
          ));
        },
        onRecoverPassword: _recoverPassword,
        additionalSignupFields: const [
          UserFormField(
            keyName: "firstname",
            displayName: "First Name",
            userType: LoginUserType.name,
            icon: Icon(
              Icons.person,
              size: 24.0,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
          ),
          UserFormField(
              keyName: "lastname",
              displayName: "Last Name",
              userType: LoginUserType.name,
              icon: Icon(
                Icons.abc,
                color: Color.fromARGB(0, 255, 255, 255),
              )),
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
