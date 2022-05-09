import 'package:flutter/material.dart';
import 'package:mariana_marketplace/classified_full_display.dart';
import 'package:mariana_marketplace/classifieds_screen.dart';
import 'package:mariana_marketplace/create_classified.dart';
import 'package:mariana_marketplace/sign_up_screen.dart';
import 'package:mariana_marketplace/test_screen.dart';
import 'package:mariana_marketplace/old_login_screen.dart';
import 'package:mariana_marketplace/car_screen.dart';
import 'package:mariana_marketplace/api_calls.dart';
import 'package:mariana_marketplace/login_or_signup_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _counter = 0;
  final Future<bool> loggedIn = getLoggedIn();

  Widget checkLoginIconButtonStatus(AsyncSnapshot snapshot) {
    print(snapshot.connectionState);
    if (snapshot.connectionState == ConnectionState.waiting) {
      return loginIconButton(Icons.key, loginOrSignupScreen());
    } else if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        return loginIconButton(Icons.error, loginOrSignupScreen());
      } else if (snapshot.hasData) {
        if (snapshot.data == true) {
          return loginIconButton(Icons.person, loginOrSignupScreen());
        } else {
          return loginIconButton(Icons.login, loginOrSignupScreen());
        }
      } else {
        return const Text('Empty data');
      }
    } else {
      debugPrint("Issue with login Icon");
      return loginIconButton(Icons.error, loginOrSignupScreen());
    }
  }

  IconButton loginIconButton(IconData iconData, Widget onPressedNav) {
    return IconButton(
      icon: Icon(
        iconData,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => onPressedNav),
        );
      },
      color: Colors.black,
    );
  }

  Widget createClassifiedButton() {
    return FutureBuilder(
      future: loggedIn,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Expanded(
          flex: 3,
          child: Card(
            color: Colors.blueGrey,
            child: IconButton(
              icon: const Icon(
                Icons.add_circle_outline,
              ),
              onPressed: () {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data == true) {
                  showAlertDialog(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Must log in to create listings."),
                  ));
                }
              },
              color: Colors.black,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mariana Marketplace"),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
        color: Color.fromARGB(255, 255, 255, 255),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Card(
                  color: Colors.blueGrey,
                  child: IconButton(
                    icon: const Icon(
                      Icons.favorite,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TestScreen()),
                      );
                    },
                    color: Colors.black,
                  ),
                ),
                createClassifiedButton(),
                Expanded(
                  child: Card(
                    color: Colors.blueGrey,
                    child: FutureBuilder(
                      future: loggedIn,
                      initialData: false,
                      builder: (context, AsyncSnapshot<bool> snapshot) {
                        return checkLoginIconButtonStatus(snapshot);
                      },
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ClassifiedsScreen(queries: [])),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Card(
                          color: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          // shadowColor: Colors.grey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Spacer(),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.shopping_bag_outlined,
                                      size: 120,
                                    ),
                                  ]),
                              const Spacer(),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Align(
                                      alignment: FractionalOffset.bottomCenter,
                                      child: Text(
                                        'Classifieds',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CarScreen()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Card(
                          color: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          // shadowColor: Colors.grey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Spacer(),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.car_rental,
                                      size: 120,
                                    ),
                                  ]),
                              const Spacer(),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Align(
                                      alignment: FractionalOffset.bottomCenter,
                                      child: Text(
                                        'Cars',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ClassifiedsScreen(queries: [])),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Card(
                          color: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          // shadowColor: Colors.grey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Spacer(),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.home,
                                      size: 120,
                                    ),
                                  ]),
                              const Spacer(),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Align(
                                      alignment: FractionalOffset.bottomCenter,
                                      child: Text(
                                        'Homes',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
