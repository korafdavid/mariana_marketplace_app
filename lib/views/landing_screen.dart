import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:mariana_marketplace/views/classified_full_display.dart';
import 'package:mariana_marketplace/views/classifieds_screen.dart';
import 'package:mariana_marketplace/controller/AuthState.dart';
import 'package:mariana_marketplace/views/create_classified.dart';
import 'package:mariana_marketplace/components/home_widget.dart';
import 'package:mariana_marketplace/views/sign_up_screen.dart';
//import 'package:mariana_marketplace/test_screen.dart';
import 'package:mariana_marketplace/views/old_login_screen.dart';
import 'package:mariana_marketplace/views/car_screen.dart';
import 'package:mariana_marketplace/controller/api_calls.dart';
import 'package:mariana_marketplace/views/login_or_signup_screen.dart';
import 'package:mariana_marketplace/views/account_screen.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final Future<bool> loggedIn = getLoggedIn();

  IconButton loginIconButton(IconData iconData, VoidCallback onPressedDo) {
    return IconButton(
      icon: Icon(
        iconData,
      ),
      onPressed: onPressedDo,
      color: Colors.black,
    );
  }

  Widget createClassifiedButton() {
    return FutureBuilder(
      future: loggedIn,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return IconButton(
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
        );
      },
    );
  }

  int _currentIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      AuthState state = Provider.of<AuthState>(context, listen: false);
      state.getLoggedInStatus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthState state = Provider.of<AuthState>(context, listen: true);
    final tabs = [
      ClassifiedsScreen(queries: []),
      CarScreen(),
      ClassifiedsScreen(queries: [])
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.favorite,
          ),
          onPressed: () {
            // Navigator.push(
            // context,
            //  MaterialPageRoute(builder: (context) => TestScreen()),
            // );
          },
          color: Colors.black,
        ),
        title: const Text("Mariana Marketplace"),
        actions: [
          createClassifiedButton(),
          state.authStatus == AuthStatus.authenicated
              ? IconButton(
                  onPressed: (() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AccountScreen()),
                    );
                  }),
                  icon: const Icon(Icons.person))
              : state.authStatus == AuthStatus.authenicating
                  ? const Center(child: CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.black
                  ))
                  : IconButton(
                      onPressed: (() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => loginOrSignupScreen()),
                        );
                      }),
                      icon: const Icon(Icons.login)),
        ],
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined), label: 'Classified'),
          BottomNavigationBarItem(icon: Icon(Icons.car_rental), label: 'Cars'),
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
        ],
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




                          
    //  HomeWidet(
    //         title: 'Classifieds',
    //         icon: const Icon(
    //           Icons.shopping_bag_outlined,
    //           size: 120,
    //         ),
    //         onpressed: () {
    //           Navigator.push(context,
    //             MaterialPageRoute(
    //                 builder: (context) => ClassifiedsScreen(queries: [])),
    //           );
    //         },
    //       ),
    //       HomeWidet(
    //         icon: const Icon(Icons.car_rental, size: 120),
    //         onpressed: () {
    //           Navigator.push(context,
    //               MaterialPageRoute(builder: (context) => CarScreen()));
    //         },
    //         title: 'Cars',
    //       ),
    //      HomeWidet(title: 'Homes',
    //       icon: const Icon(
    //                   Icons.home,
    //                    size: 120,
    //                               ), 
    //       onpressed: (){
    //          Navigator.push(
    //                     context,
    //                     MaterialPageRoute(
    //                         builder: (context) =>
    //                             ClassifiedsScreen(queries: [])),
    //                   );
    //       })                      