import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';
import 'package:flutter/material.dart';
import 'package:mariana_marketplace/screens/login_or_signup_screen.dart';
import 'package:mariana_marketplace/screens/account_screen.dart';

class AccountButton extends StatelessWidget {
  const AccountButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authNotifier = context.authNotifier;

    Widget widget;
    switch (authNotifier.status) {
      case AuthStatus.authenticated:
        widget = Expanded(
          child: Card(
            color: Colors.blueGrey,
            child: loginIconButton(Icons.person, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountScreen()),
              );
            }),
          ),
        );
        break;
      case AuthStatus.unauthenticated:
      case AuthStatus.authenticating:
        widget = Expanded(
          child: Card(
            color: Colors.blueGrey,
            child: loginIconButton(Icons.login, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => loginOrSignupScreen()),
              );
            }),
          ),
        );
        break;
      case AuthStatus.uninitialized:
      default:
        widget = Expanded(
          child: Card(
            color: Colors.blueGrey,
            child: loginIconButton(Icons.refresh, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => loginOrSignupScreen()),
              );
            }),
          ),
        );
        break;
    }
    return widget;
  }

  IconButton loginIconButton(IconData iconData, VoidCallback onPressedDo) {
    return IconButton(
      icon: Icon(
        iconData,
      ),
      onPressed: onPressedDo,
      color: Colors.black,
    );
  }
}
