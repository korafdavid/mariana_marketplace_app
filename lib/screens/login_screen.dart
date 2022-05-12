import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appwrite/appwrite.dart';
import 'package:mariana_marketplace/api_calls.dart';
import 'package:mariana_marketplace/screens/landing_screen.dart';
import 'package:intl/intl.dart';
import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Form Vars
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";

  Future? loggingInUser;

  //Widget for submit button + loading indicator
  Widget? loggingInButton(Future? signingUp) {
    if (signingUp != null) {
      return FutureBuilder(
        future: signingUp,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            debugPrint("Status of loggingInButton after done: " +
                snapshot.data.toString());
            int seconds = 2;
            Future.delayed(
              Duration(seconds: seconds),
              (() async {
                debugPrint(
                    "Logged in, moving to landing after $seconds seconds.");
                //Move after sign up
                //Navigator.pushReplacement(
                //  context,
                //  MaterialPageRoute(builder: (context) => LandingScreen()),
                //);
              }),
            );
            return const Text("Finished");
          } else {
            return const Text("Logging in, please wait.");
          }
        },
      );
    }
    return const Text("Log In");
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = context.authNotifier;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      // The validator receives the text that the user has entered.
                      decoration: const InputDecoration(labelText: "Email"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          debugPrint("Setting Last Name = " + value!);
                          email = value;
                        });
                      },
                    ),
                    TextFormField(
                      // The validator receives the text that the user has entered.
                      decoration: const InputDecoration(labelText: "Password"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          //debugPrint("Setting password = " + value!);
                          password = value!;
                        });
                      },
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    _formKey.currentState?.save();

                    if (!await context.authNotifier
                        .createSession(email: email, password: password)) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              context.authNotifier.error ?? "Unknown error")));
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("Logged In")));
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LandingScreen()));
                    }

                    setState(() {
                      //loggingInUser = loginUserAccount(email, password);
                      //loggingInUser = context.authNotifier.account
                      //    .createSession(email: email, password: password);
                    });

                    // if (!await context.authNotifier
                    //     .createSession(email: email, password: password)) {
                    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //       content: Text(
                    //           context.authNotifier.error ?? "Unknown error")));
                    // }
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => LandingScreen()));

                    //If you want immidiate screen switch after clicking submit:
                    //Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //  builder: (context) => const LandingScreen(),
                    //));

                    // More at https://docs.flutter.dev/cookbook/forms/validation
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Form data invalid or missing image.')),
                    );
                  }
                },
                child: loggingInButton(loggingInUser),
              )
            ],
          ),
        ),
      ),
    );
  }
}
