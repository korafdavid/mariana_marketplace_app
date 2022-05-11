import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';
import 'package:flutter/material.dart';
import 'package:mariana_marketplace/screens/login_or_signup_screen.dart';
import 'package:mariana_marketplace/screens/account_screen.dart';
import 'package:mariana_marketplace/screens/landing_screen.dart';
import 'package:mariana_marketplace/screens/create_classified.dart';

class CreateClassifiedbutton extends StatelessWidget {
  const CreateClassifiedbutton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authNotifier = context.authNotifier;

    Widget widget;
    switch (authNotifier.status) {
      case AuthStatus.authenticated:
        widget = Expanded(
          flex: 3,
          child: Card(
            color: Colors.blueGrey,
            child: IconButton(
              icon: const Icon(
                Icons.add_circle_outline,
              ),
              onPressed: () {
                showAlertDialog(context);
              },
              color: Colors.black,
            ),
          ),
        );
        break;
      case AuthStatus.unauthenticated:
      case AuthStatus.authenticating:
      case AuthStatus.uninitialized:
      default:
        widget = Expanded(
          flex: 3,
          child: Card(
            color: Colors.blueGrey,
            child: IconButton(
              icon: const Icon(
                Icons.add_circle_outline,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Must log in to create listings."),
                ));
              },
              color: Colors.black,
            ),
          ),
        );
        break;
    }
    return widget;
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons

    Widget ClassifiedButton = TextButton(
      child: const Text("Classified Ad"),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateClassifiedScreen()),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
    );
    Widget CarClassifiedButton = TextButton(
      child: const Text("Vehicle"),
      onPressed: () {},
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Which type of ad would you like to post?",
        textAlign: TextAlign.center,
      ),
      content: const Text(""),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ClassifiedButton,
        CarClassifiedButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
