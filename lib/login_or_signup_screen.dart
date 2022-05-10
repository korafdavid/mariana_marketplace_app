import 'package:flutter/material.dart';
import 'package:mariana_marketplace/api_calls.dart';
import 'package:mariana_marketplace/login_screen.dart';
import 'package:mariana_marketplace/sign_up_screen.dart';

class loginOrSignupScreen extends StatefulWidget {
  loginOrSignupScreen({Key? key}) : super(key: key);

  @override
  State<loginOrSignupScreen> createState() => _loginOrSignupScreenState();
}

class _loginOrSignupScreenState extends State<loginOrSignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mariana Marketplace"),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50)),
                  onPressed: (() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }),
                  child: const Text("Login")),
              const SizedBox(height: 10),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50)),
                  onPressed: (() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpForm()),
                    );
                  }),
                  child: const Text("Sign Up"))
            ],
          ),
        ),
      ),
    );
  }
}
