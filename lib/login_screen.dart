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
  Duration get loginTime => Duration(milliseconds: 2250);

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

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      Account account = Account(appwriteClient);

      Future result = account.create(
        userId: 'unique()',
        email: data.name!,
        password: data.password!,
      );

      result.then((response) {
        print(response);
        return response;
      }).catchError((error) {
        print(error.response);
        return error.response;
      });
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

  @override
  Widget build(BuildContext context) {
    appwriteClient
        .setEndpoint(
            'https://appwrite.saipan.life/v1') // Your Appwrite Endpoint
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
    );
  }
}
